import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:snuffles_run/components/game.dart';
import 'package:snuffles_run/components/snuffles.dart';
import 'package:snuffles_run/game_state.dart';

class Obstacle extends SpriteComponent
    with HasGameRef<SnufflesGame>, HasHitboxes, Collidable {
  Obstacle() {
    size = Vector2(50, 50);
  }
  // to be used by the Spawn generator to determine the spawn delay
  // time after the previous spawn before spawning it
  final velocity = Vector2(-250, 0);

  Obstacle.forTesting();

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('stone05.png');

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
