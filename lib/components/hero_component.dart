import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:rive/rive.dart';
import 'package:snuffles_run/game.dart';
import 'package:snuffles_run/components/ground.dart';
import 'package:snuffles_run/game_data.dart';

enum PlayerState { idle, jumping, running }

class HeroComponent extends PositionComponent
    with HasGameRef<SnufflesGame>, HasHitboxes, Collidable {
  HeroComponent(HeroType heroType) : super(size: Vector2.all(320)) {
    anchor = Anchor.center;
    flipHorizontally();
  }

  // Ground y value
  final startPos = Vector2(150, 380);
  final _gravity = Vector2(0, 30);
  final _jumpVelocity = Vector2(0, -13);
  Vector2 _velocity = Vector2(0, 0);

  PlayerState playerState = PlayerState.running;

  @override
  Future<void>? onLoad() async {
    // Add rive component
    var artboard =
        await loadArtboard(RiveFile.asset('assets/images/heros/bunny.riv'));
    await add(RiveComponent(artboard: artboard));

    final controller = SimpleAnimation('Running');
    artboard.addController(controller);

    position = startPos;
    addHitbox(HitboxRectangle(relation: Vector2(0.2, 0.25)));
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    if (other is Ground) {
      playerState = PlayerState.running;
      _velocity = Vector2.zero();
      const offset = 5; // Snuffles image height correction
      position.y = other.position.y - other.size.y / 2 - offset;
    }
  }

  /// Make snuffles jump
  void jump() {
    if (playerState != PlayerState.jumping) {
      _velocity = _jumpVelocity;
      playerState = PlayerState.jumping;
    }
  }

  void applyGravity(double dt) {
    _velocity += _gravity * dt;
    position += _velocity;
  }

  @override
  void update(double dt) {
    if (playerState == PlayerState.jumping) applyGravity(dt);
    super.update(dt);
  }
}
