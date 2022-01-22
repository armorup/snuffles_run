import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rive/rive.dart';
import 'package:snuffles_run/components/game_text.dart';
import 'package:snuffles_run/components/ground.dart';
import 'package:snuffles_run/components/obstacle_spawner.dart';
import 'package:snuffles_run/components/score_text.dart';
import 'package:snuffles_run/components/snuffles.dart';
import 'package:snuffles_run/data.dart';
import 'package:snuffles_run/game_state.dart';
import 'package:snuffles_run/widgets/pause_menu.dart';
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
  double score = 0;

  @override
  bool get debugMode => kDebugMode;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    snuffles = SnufflesComponent(
      await loadArtboard(RiveFile.asset('assets/images/snuffles.riv')),
    );

    // Add background first
    await add(Background(Data.scene));
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
  void onLevelComplete() {
    add(GameText('Level Complete'));
  }

  /// Called by obstacle when wave is finished
  void onWaveComplete() {
    add(GameText('Wave Complete!'));
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
    overlays.add('pause');
  }
}
