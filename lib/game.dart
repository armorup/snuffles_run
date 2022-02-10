import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:snuffles_run/components/scene.dart';
import 'package:snuffles_run/components/game_text.dart';
import 'package:snuffles_run/components/score_text.dart';
import 'package:snuffles_run/components/hero_component.dart';
import 'package:snuffles_run/game_data.dart';
import 'package:snuffles_run/player_data.dart';
import 'package:snuffles_run/game_state.dart';
import 'package:snuffles_run/screens/achievements.dart';
import 'package:snuffles_run/screens/cutscene.dart';
import 'package:snuffles_run/screens/endless.dart';
import 'package:snuffles_run/screens/game_map.dart';
import 'package:snuffles_run/main.dart';
import 'package:snuffles_run/screens/main_menu.dart';
import 'package:snuffles_run/screens/options.dart';

class GameLoader extends StatelessWidget {
  const GameLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GameWidget(
        // Create the game
        game: SnufflesGame(context: context),
        loadingBuilder: (context) => const Material(
          child: Center(child: CircularProgressIndicator()),
        ),
        errorBuilder: (context, ex) {
          debugPrint(ex.toString());
          return const Material(
            child: Center(
              child: Text('Oops, something went wrong. Reload me'),
            ),
          );
        },
        overlayBuilderMap: {
          'main_menu': (context, SnufflesGame game) => MainMenu(game: game),
          'map': (context, SnufflesGame game) => GameMap(game: game),
          'options': (context, SnufflesGame game) => OptionsMenu(game: game),
          'achievements': (context, SnufflesGame game) =>
              Achievements(game: game),
          'endless': (context, SnufflesGame game) => Endless(game: game),
          'cutscene': (context, SnufflesGame game) => CutScene(game: game),
        },
      ),
    );
  }
}

/// The game
class SnufflesGame extends FlameGame with HasCollidables, TapDetector {
  SnufflesGame({required this.context});
  BuildContext context;

  @override
  bool get debugMode => true;

  double score = 0;

  late HeroComponent hero = HeroComponent(playerData.hero);
  late Scene scene = Scene();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    GameState.state = PlayState.loading;

    loadAudio();

    await add(scene);
    await add(hero);
    await add(ScoreText());

    if (debugMode) {
      playerData = PlayerData.debug();
    }

    overlays.add('main_menu');
    GameState.state = PlayState.inMenu;
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Ensure scene is loaded before playing the game
    if (scene.isLoaded) {
      GameState.state == PlayState.playing;
    }

    if (GameState.state == PlayState.playing) {
      // Increase the score
      score += dt;
    } else if (GameState.state == PlayState.gameover) {
      // Do something
    }

    if (GameState.musicOn && GameState.state == PlayState.inMenu) {
      if (!FlameAudio.bgm.isPlaying) {
        FlameAudio.bgm.play(gameData.music.menu);
      }
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

    /// TODO: show cutscene
  }

  /// Called by obstacle when wave is finished
  void onWaveComplete() async {
    // Change after first wave, then every 3 waves
    if (scene.spawner.waveNumber == 1 || scene.spawner.waveNumber % 3 == 0) {
      scene.background.addParallaxLayer();
    }

    // Start next wave to get correct wavenumber
    scene.spawner.nextWave();
    scene.spawner.startSpawning();

    // Display achievement message
    if (scene.spawner.waveNumber == 5 &&
        playerData.discoverScene(SceneType.backyard)) {
      add(GameText('New Scene!'));
    } else if (scene.spawner.waveNumber == 10 &&
        playerData.unlockScene(SceneType.backyard)) {
      add(GameText('Scene Unlocked!'));
    } else {
      add(GameText('Wave ${scene.spawner.waveNumber}'));
    }
  }

  /// Go to the correct game scene
  Future<void> goScene(SceneType sceneType) async {
    playerData.curScene = sceneType;

    score = 0;
    await scene.loadScene(sceneType);
    scene.unpause();
    resumeEngine();
    GameState.state = PlayState.playing;
    FlameAudio.bgm.play(gameData.music.game);

    add(GameText('Wave ${scene.spawner.waveNumber}'));
  }

  /// Called when bunny collides with obstacle
  void onGameOver() async {
    // camera.followComponent(snuffles);
    // camera.zoom = 2;
    // background.stop();
    GameState.state = PlayState.gameover;
    playerData.updateHighscore(scene.spawner.waveNumber);
    playerData.save();
    pauseEngine();
    overlays.add('main_menu');
    FlameAudio.bgm.play(gameData.music.menu);
  }

  /// Load game audio
  void loadAudio() async {
    FlameAudio.bgm.initialize();
    await FlameAudio.audioCache.loadAll(
        [gameData.music.game, gameData.music.menu, gameData.sfx.click]);
    // await FlameAudio.bgm.loadAll([
    //   gameData.music.game,
    //   gameData.music.menu,
    // ]);
    FlameAudio.bgm.play(gameData.music.menu);
    //FlameAudio.audioCache.loadAll([gameData.sfx.click]);
  }
}
