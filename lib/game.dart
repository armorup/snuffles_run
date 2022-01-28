import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:snuffles_run/components/game_text.dart';
import 'package:snuffles_run/components/ground.dart';
import 'package:snuffles_run/components/obstacle_spawner.dart';
import 'package:snuffles_run/components/score_text.dart';
import 'package:snuffles_run/components/snuffles.dart';
import 'package:snuffles_run/data.dart';
import 'package:snuffles_run/game_state.dart';
import 'package:snuffles_run/screens/main_menu.dart';
import 'package:snuffles_run/screens/pause_menu.dart';
import 'components/background.dart';

// Single instance of game
SnufflesGame _game = SnufflesGame();

class GamePlay extends StatelessWidget {
  const GamePlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GameWidget(
        game: _game,
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
              child: Text('Sorry, something went wrong. Reload me'),
            ),
          );
        },
        overlayBuilderMap: {
          'main menu': (context, SnufflesGame game) => const MainMenu(),
          'pause': (context, SnufflesGame game) => PauseMenu(game: game),
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
  var background = Background(Data.scene);
  double score = 0;

  @override
  bool get debugMode => false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    FlameAudio.audioCache.loadAll(['sfx/Abstract1.mp3', 'sfx/Abstract2.mp3']);
    snuffles = SnufflesComponent(
      await loadArtboard(RiveFile.asset('assets/images/snuffles.riv')),
    );

    // Add background first
    await add(background);
    final ground = Ground();
    await add(ground);
    add(ScoreText());
    add(snuffles);
    spawner.position = Vector2(size.x + 20, ground.y);
    add(spawner);

    add(GameText('Let\'s Go!'));
    start();
  }

  /// Starts the game
  void start() {
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
    Data.scene = SceneType.forest;
    background.loadScene(Data.scene);
    await background.load();
    spawner.loadTestWaves();
    spawner.start();
  }

  /// Called by obstacle when wave is finished
  void onWaveComplete() async {
    add(GameText('Wave Complete!'));
    background.addParallaxLayer();
    await background.load();
    spawner.launcher.loadNextWave();
    spawner.start();
  }

  void restart() {
    GameState.playState = PlayState.playing;
    resumeEngine();
    score = 0;
  }

  /// Called when game is over
  void gameOver() {
    GameState.playState = PlayState.lost;
    pauseEngine();
    overlays.add('main menu');
  }
}
