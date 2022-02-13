import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/timer.dart';
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
        game: SnufflesGame(),
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
  SnufflesGame();
  Timer timer = Timer(0);
  double score = 0;
  late HeroComponent hero = HeroComponent(playerData.hero);
  late Scene scene = Scene();

  @override
  bool get debugMode => false;

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

    // Show the main menu
    overlays.add('main_menu');
    GameState.state = PlayState.inMenu;
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Ensure scene is loaded before playing the game
    if (scene.isLoaded && GameState.state == PlayState.playing) {
      GameState.state == PlayState.playing;
    }

    // Check for correct action for given GameState
    if (GameState.state == PlayState.playing) {
      // Increase the score
      score += dt;
    } else if (GameState.state == PlayState.gameover) {
      timer.update(dt);
    }

    // Check if audio is on or off
    if (GameState.musicOn && GameState.state == PlayState.inMenu) {
      if (!FlameAudio.bgm.isPlaying) {
        //FlameAudio.bgm.play(gameData.music.menu);
      }
    }
  }

  /// Hero jumps on tap
  @override
  void onTapDown(TapDownInfo info) {
    if (GameState.state == PlayState.playing) {
      if (hero.playerState != PlayerState.jumping) {
        hero.jump();
      }
    }
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
    String text = '';
    if (GameState.mode == GameMode.story) {
      if (scene.spawner.waveNumber == 5 && discoverNextScene()) {
        text = 'Scene Discovered!';
      } else if (scene.spawner.waveNumber == 10 && unlockNextScene()) {
        text = 'Scene Unlocked!';
      } else {
        text = 'Wave ${scene.spawner.waveNumber}';
      }
      add(GameText(text));
    }
  }

  bool discoverNextScene() {
    int index = playerData.curScene.index + 1;
    if (index < SceneType.values.length) {
      SceneType nextScene = SceneType.values[index];
      return playerData.discoverScene(nextScene);
    }
    return false;
  }

  bool unlockNextScene() {
    int index = playerData.curScene.index + 1;
    if (index < SceneType.values.length) {
      SceneType nextScene = SceneType.values[index];
      return playerData.unlockScene(nextScene);
    }
    return false;
  }

  /// Go to the correct game scene
  Future<void> goScene(SceneType sceneType) async {
    assert(playerData.scenes.containsKey(sceneType));
    playerData.curScene = sceneType;
    if (GameState.mode == GameMode.story && !playerData.cutscenePlayed) {
      overlays.add('cutscene');
      playerData.cutscenePlayed = true;
    } else {
      score = 0;
      await scene.loadScene(sceneType);
      scene.unpause();
      resumeEngine();
      GameState.state = PlayState.playing;
      //FlameAudio.bgm.play(gameData.music.game);

      add(GameText('Wave ${scene.spawner.waveNumber}'));
    }
  }

  /// Called when bunny collides with obstacle
  void onGameOver() async {
    camera.shake(duration: 0.3, intensity: 5);
    scene.pause();
    playerData.updateHighscore(scene.spawner.waveNumber);
    playerData.save();
    add(GameText('Game Over', duration: 3));
    timer = Timer(3, onTick: () {
      GameState.state == PlayState.inMenu;
      overlays.add('map');
      pauseEngine();
    });
    GameState.state = PlayState.gameover;

    //FlameAudio.bgm.play(gameData.music.menu);
  }

  /// Load game audio
  void loadAudio() async {
    //FlameAudio.bgm.initialize();
    //await FlameAudio.audioCache.loadAll(
    //    [gameData.music.game, gameData.music.menu, gameData.sfx.click]);
    //await FlameAudio.bgm.loadAll([
    //  gameData.music.game,
    //  gameData.music.menu,
    //]);
    //FlameAudio.bgm.play(gameData.music.menu);
    //FlameAudio.audioCache.loadAll([gameData.sfx.click]);
  }
}

//

