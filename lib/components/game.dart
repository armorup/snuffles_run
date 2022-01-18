import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:flutter/foundation.dart';
import 'package:rive/rive.dart';
import 'package:snuffles_run/components/ground.dart';
import 'package:snuffles_run/components/obstacle_spawner.dart';
import 'package:snuffles_run/components/score_text.dart';
import 'package:snuffles_run/components/snuffles.dart';
import 'package:snuffles_run/game_state.dart';

import 'background.dart';

/// The main character is a bunny
class SnufflesGame extends FlameGame with HasCollidables, TapDetector {
  /// Reference to the bunny
  late SnufflesComponent snuffles;
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
    await add(Background());
    final ground = Ground();
    await add(ground);
    add(ScoreText());
    add(snuffles);
    add(
      ObstacleSpawner(
        position: Vector2(size.x / 2, 140),
      ),
    );
    restart();
  }

  @override
  void update(double dt) {
    // Spawn obstacle

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

  // TODO: restart the game
  void restart() {
    GameState.playState = PlayState.playing;
    score = 0;
  }

  /// Called when game is over
  void gameOver() {
    GameState.playState = PlayState.lost;
    overlays.add('pause');
  }
}
