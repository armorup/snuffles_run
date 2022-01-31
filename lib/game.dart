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
import 'package:snuffles_run/screens/cutscene.dart';
import 'package:snuffles_run/screens/debug.dart';
import 'package:snuffles_run/screens/game_map.dart';
import 'package:snuffles_run/main.dart';
import 'package:snuffles_run/screens/pause_menu.dart';
import 'components/background.dart';

class GameLoader extends StatelessWidget {
  const GameLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GameWidget(
        // Create the game
        game: SnufflesGame(data: playerData),
        loadingBuilder: (context) => const Material(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
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
          'debug': (context, SnufflesGame game) => Debug(game: game),
          'pause': (context, SnufflesGame game) => PauseMenu(game: game),
          'map': (context, SnufflesGame game) => GameMap(game: game),
          'cutscene': (context, SnufflesGame game) => CutScene(game: game),
        },
      ),
    );
  }
}

/// The game
class SnufflesGame extends FlameGame with HasCollidables, TapDetector {
  SnufflesGame({required this.data});

  @override
  bool get debugMode => false;

  // Player data
  Data data;

  // The main hero
  late SnufflesComponent snuffles;
  Background background = Background(SceneType.outdoor);

  // The main obstacle spawner
  final spawner = ObstacleSpawner();
  final ground = Ground();
  double score = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    GameState.state = PlayState.loading;

    // TODO: Fix this Load audio
    FlameAudio.bgm.initialize();
    await FlameAudio.bgm
        .loadAll(['music/Dark Beach.mp3', 'music/Paradise.mp3']);
    //FlameAudio.bgm.play('music/Paradise.mp3');
    FlameAudio.audioCache.loadAll(['sfx/Abstract1.mp3', 'sfx/Abstract2.mp3']);

    snuffles = SnufflesComponent(
      await loadArtboard(RiveFile.asset('assets/images/snuffles.riv')),
    );

    // Add background before other components
    background = Background(data.curScene);
    await add(background);
    await add(ground);
    add(ScoreText());
    add(snuffles);
    spawner.position = Vector2(size.x + 20, ground.y);
    add(spawner);

    if (debugMode) {
      data = Data();
      overlays.add('debug');
    } else {
      // Start the game
      restart();
    }
  }

  /// Restart the game
  void restart() async {
    GameState.state = PlayState.playing;
    await background.resetTo(data.curScene);
    spawner.restart();
    score = 0;
    add(GameText('Wave ${spawner.waveNumber}'));
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (GameState.state == PlayState.playing) {
      // Increase the score
      score += dt;
    }
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (GameState.state == PlayState.playing) {
      if (snuffles.playerState != PlayerState.jumping) {
        snuffles.jump();
      }
    }
  }

  /// Called by obstacle when the level is finished
  void onLevelComplete() async {
    add(GameText('Level Complete'));
    goScene(data.curScene);
  }

  /// Called by obstacle when wave is finished
  void onWaveComplete() async {
    // Change after first wave, then every 3 waves
    if (spawner.waveNumber == 1 || spawner.waveNumber % 3 == 0) {
      background.addParallaxLayer();
    }

    // Start next wave to get correct wavenumber
    spawner.nextWave();
    spawner.start();

    // Display achievement message
    if (spawner.waveNumber == 5 && data.addScene(SceneType.forest)) {
      add(GameText('New Scene!'));
    } else if (spawner.waveNumber == 10 && data.unlockScene(SceneType.forest)) {
      add(GameText('Scene Unlocked!'));
    } else {
      add(GameText('Wave ${spawner.waveNumber}'));
    }
  }

  /// Go to the correct game scene
  void goScene(SceneType scene) async {
    data.curScene = scene;
    resumeEngine();
    restart();
  }

  /// Called when bunny collides with obstacle
  void onGameOver() async {
    // camera.followComponent(snuffles);
    // camera.zoom = 2;
    // background.stop();
    GameState.state = PlayState.paused;
    data.updateHighscore(spawner.waveNumber);
    data.save();
    pauseEngine();
    overlays.add('map');
  }
}
