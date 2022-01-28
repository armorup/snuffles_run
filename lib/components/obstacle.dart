import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/geometry.dart';
import 'package:snuffles_run/game.dart';
import 'package:snuffles_run/components/snuffles.dart';
import 'package:snuffles_run/game_state.dart';

class Obstacle extends SpriteComponent
    with HasGameRef<SnufflesGame>, HasHitboxes, Collidable {
  /// Delay factor is a value between 0 (no start delay) and 1
  Obstacle({this.delayFactor = 0}) {
    size = Vector2.all(50);
    anchor = Anchor.bottomLeft;
    // All Obstacles will be removed after 7 seconds
    add(RemoveEffect(delay: 7));
  }

  // What should this be?
  var velocity = Vector2(-250, 0);
  var velocityDelta = Vector2(-30, 0);

  // Delay before spawning
  double delayFactor;
  // true if this is the last obstacle in the wave
  bool isLastInWave = false;
  // true if this is the last obstacle in the level
  bool isLastInLevel = false;

  @override
  Future<void> onLoad() async {
    // Load random stone sprite images
    // TODO: Load all game images once in main game
    var length = 5;
    var imageNames = <String>[];
    for (var i = 0; i < length; i++) {
      imageNames.add('stone0${i + 1}.png');
      await gameRef.images.load(imageNames[i]);
    }
    var r = Random().nextInt(length);
    sprite = Sprite(gameRef.images.fromCache(imageNames[r]));

    addHitbox(HitboxRectangle(relation: Vector2(0.8, 0.8)));
    return super.onLoad();
  }

  void increaseSpeed() {
    velocity += velocityDelta;
  }

  void decreaseSpeed() {
    velocity -= velocityDelta;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    if (other is SnufflesComponent) {
      gameRef.gameOver();
    }
    super.onCollision(intersectionPoints, other);
  }

  @override
  void update(double dt) {
    if (GameState.playState != PlayState.playing) return;

    // move obstacle
    position += velocity * dt;

    // TODO: how to get global coordinates? Or create left edge collider
    var leftEdge = gameRef.size.x + gameRef.spawner.size.x;
    if (position.x < -leftEdge) {
      if (isLastInLevel) {
        isLastInLevel = false;
        gameRef.onLevelComplete();
      } else if (isLastInWave) {
        isLastInWave = false;
        gameRef.onWaveComplete();
      }
    }

    super.update(dt);
  }
}
