import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/geometry.dart';
import 'package:snuffles_run/game.dart';
import 'package:snuffles_run/components/snuffles.dart';
import 'package:snuffles_run/game_state.dart';

class Obstacle extends SpriteComponent
    with HasGameRef<SnufflesGame>, HasHitboxes, Collidable {
  Obstacle() {
    size = Vector2(50, 50);
    // All Obstacles will be removed after 7 seconds
    add(RemoveEffect(delay: 7));
  }

  /// Called to create a generic obstacle for debugging
  Obstacle.forTesting();

  final velocity = Vector2(-250, 0);

  @override
  Future<void> onLoad() async {
    // Load random stone sprite images
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

    position += velocity * dt;

    super.update(dt);
  }
}
