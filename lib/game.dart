import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:snuffles_run/components/scene.dart';
import 'package:snuffles_run/components/game_text.dart';
import 'package:snuffles_run/components/score_text.dart';
import 'package:snuffles_run/components/hero_component.dart';
import 'package:snuffles_run/game_data.dart';
import 'package:snuffles_run/player_data.dart';
import 'package:snuffles_run/game_state.dart';
import 'package:snuffles_run/screens/cutscene.dart';
import 'package:snuffles_run/screens/debug.dart';
import 'package:snuffles_run/screens/game_map.dart';
import 'package:snuffles_run/main.dart';
import 'package:snuffles_run/screens/pause_menu.dart';

class GameLoader extends StatelessWidget {
  const GameLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GameWidget(
        // Create the game
        game: SnufflesGame(playerData: playerData),
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
  SnufflesGame({required this.playerData});

  @override
  bool get debugMode => false;

  PlayerData playerData;
  double score = 0;

  late HeroComponent hero;
  late Scene scene = Scene(sceneType: playerData.curScene);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    GameState.state = PlayState.loading;

    loadAudio();

    // Load Scene
    await add(scene);

    // Need to load all rive artboards before creating rive component
    var artboard =
        await loadArtboard(RiveFile.asset('assets/images/heros/bunny.riv'));
    await add(RiveComponent(artboard: artboard));
    hero = HeroComponent(playerData.hero);

    await add(ScoreText());
    await add(hero);

    if (debugMode) {
      playerData = PlayerData();
      overlays.add('debug');
    } else {
      // Start the game
      restart();
    }
  }

  /// Restart the game
  void restart() async {
    GameState.state = PlayState.playing;
    await scene.background.reset();
    scene.spawner.restart();
    score = 0;
    add(GameText('Wave ${scene.spawner.waveNumber}'));
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
      if (hero.playerState != PlayerState.jumping) {
        hero.jump();
      }
    }
  }

  /// Called by obstacle when the level is finished
  void onLevelComplete() async {
    add(GameText('Level Complete'));
    goScene(playerData.curScene);
  }

  /// Called by obstacle when wave is finished
  void onWaveComplete() async {
    // Change after first wave, then every 3 waves
    if (scene.spawner.waveNumber == 1 || scene.spawner.waveNumber % 3 == 0) {
      scene.background.addParallaxLayer();
    }

    // Start next wave to get correct wavenumber
    scene.spawner.nextWave();
    scene.spawner.start();

    // Display achievement message
    if (scene.spawner.waveNumber == 5 &&
        playerData.discoverScene(SceneType.forest)) {
      add(GameText('New Scene!'));
    } else if (scene.spawner.waveNumber == 10 &&
        playerData.unlockScene(SceneType.forest)) {
      add(GameText('Scene Unlocked!'));
    } else {
      add(GameText('Wave ${scene.spawner.waveNumber}'));
    }
  }

  /// Go to the correct game scene
  void goScene(SceneType scene) async {
    playerData.curScene = scene;
    resumeEngine();
    restart();
  }

  /// Called when bunny collides with obstacle
  void onGameOver() async {
    // camera.followComponent(snuffles);
    // camera.zoom = 2;
    // background.stop();
    GameState.state = PlayState.paused;
    playerData.updateHighscore(scene.spawner.waveNumber);
    playerData.save();
    pauseEngine();
    overlays.add('map');
  }

  // TODO: Fix this Load audio
  void loadAudio() async {
    FlameAudio.bgm.initialize();
    await FlameAudio.bgm
        .loadAll(['music/Dark Beach.mp3', 'music/Paradise.mp3']);
    //FlameAudio.bgm.play('music/Paradise.mp3');
    FlameAudio.audioCache.loadAll(['sfx/Abstract1.mp3', 'sfx/Abstract2.mp3']);
  }
}
