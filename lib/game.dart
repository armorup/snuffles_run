import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:snuffles_run/components/game_text.dart';
import 'package:snuffles_run/components/ground.dart';
import 'package:snuffles_run/components/obstacle.dart';
import 'package:snuffles_run/components/obstacle_spawner.dart';
import 'package:snuffles_run/components/score_text.dart';
import 'package:snuffles_run/components/snuffles.dart';
import 'package:snuffles_run/data.dart';
import 'package:snuffles_run/game_state.dart';
import 'package:snuffles_run/screens/game_map.dart';
import 'package:snuffles_run/screens/main_menu.dart';
import 'package:snuffles_run/screens/pause_menu.dart';
import 'components/background.dart';

class Game extends StatelessWidget {
  const Game({Key? key, required this.game}) : super(key: key);
  final SnufflesGame game;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GameWidget(
        game: game,
        //Work in progress loading screen on game start
        loadingBuilder: (context) => const Material(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        //Work in progress error handling
        errorBuilder: (context, ex) {
          //Print the error in th dev console
          debugPrint(ex.toString());

          return const Material(
            child: Center(
              child: Text('Oops, something went wrong. Reload me'),
            ),
          );
        },
        overlayBuilderMap: {
          'main menu': (context, SnufflesGame game) => const MainMenu(),
          'pause': (context, SnufflesGame game) => PauseMenu(game: game),
          'map': (context, SnufflesGame game) => GameMap(game: game),
        },
      ),
    );
  }
}

/// The game
class SnufflesGame extends FlameGame with HasCollidables, TapDetector {
  // The bunny main hero
  late SnufflesComponent snuffles;

  // The main obstacle spawner
  final spawner = ObstacleSpawner();
  var background = Background(Data.curScene);
  final ground = Ground();
  double score = 0;

  @override
  bool get debugMode => false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    FlameAudio.bgm.initialize();
    await FlameAudio.bgm
        .loadAll(['music/Dark Beach.mp3', 'music/Paradise.mp3']);
    FlameAudio.bgm.play('music/Dark Beach.mp3');
    FlameAudio.audioCache.loadAll(['sfx/Abstract1.mp3', 'sfx/Abstract2.mp3']);

    snuffles = SnufflesComponent(
      await loadArtboard(RiveFile.asset('assets/images/snuffles.riv')),
    );

    // Add background first
    await add(background);
    await add(ground);
    add(ScoreText());
    add(snuffles);
    spawner.position = Vector2(size.x + 20, ground.y);
    add(spawner);

    GameState.playState = PlayState.playing;
    spawner.start();
  }

  @override
  void update(double dt) {
    // Increase the score
    score += dt;
    super.update(dt);
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (snuffles.playerState != PlayerState.jumping) {
      snuffles.jump();
    }
  }

  /// Called by obstacle when the level is finished
  void onLevelComplete() async {
    add(GameText('Level Complete'));
    goScene(Data.curScene);
  }

  /// Called by obstacle when wave is finished
  void onWaveComplete() async {
    // Change after first wave, then every 3 waves
    if (spawner.waveNumber == 1 || spawner.waveNumber % 3 == 0) {
      background.addParallaxLayer();
    }
    spawner.nextWave();
    spawner.start();
  }

  void restart() async {
    GameState.playState = PlayState.playing;
    await background.resetTo(Data.curScene);
    spawner.restart();
    score = 0;
  }

  // Go to the correct game scene
  void goScene(SceneType scene) async {
    Data.curScene = SceneType.outdoor;
    restart();
    resumeEngine();
  }

  void gameOver() {
    //camera.zoom = 2;
    //camera.followComponent(snuffles);
    GameState.playState = PlayState.paused;
    // stop background parallax
    background.stop();
    removeAll(children.whereType<Obstacle>());
    // determine high score
    updateHighscore(Data.curScene, spawner.waveNumber);
    goMap();
  }

  void updateHighscore(SceneType sceneType, int score) {
    final high = Data.scenes[sceneType]!['highscore'];
    if (score > high) {
      Data.scenes[sceneType]!['highscore'] = score;
    }
  }

  /// Go to map when game is over
  void goMap() {
    pauseEngine();
    overlays.add('map');
  }
}
