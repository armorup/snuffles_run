import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:snuffles_run/game.dart';
import 'package:snuffles_run/components/snuffles.dart';
import 'package:snuffles_run/components/obstacle.dart';

/// An invisible platform
class Ground extends PositionComponent
    with HasGameRef<SnufflesGame>, HasHitboxes, Collidable {
  @override
  Future<void>? onLoad() {
    size = Vector2(gameRef.size.x, gameRef.size.y * 0.18);
    position = Vector2(0, gameRef.size.y - size.y);
    collidableType = CollidableType.passive;
    addHitbox(HitboxRectangle());

    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    if (other is SnufflesComponent || other is Obstacle) {
      //other.position.y = position.y - size.y / 2 - 24;
    }
    super.onCollision(intersectionPoints, other);
  }
}
