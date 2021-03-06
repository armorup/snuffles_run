import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/geometry.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:flame_svg/flame_svg.dart';
import 'package:rive/rive.dart';
import 'package:snuffles_run/components/hero_component.dart';
import 'package:snuffles_run/game.dart';
import 'package:snuffles_run/game_state.dart';
import 'package:snuffles_run/main.dart';
import 'package:snuffles_run/models/obstacle_model.dart';

class Obstacle extends PositionComponent
    with HasGameRef<SnufflesGame>, HasHitboxes, Collidable {
  /// Delay factor is a value between 0 (no start delay) and 1
  Obstacle({
    required this.model,
    this.delayFactor = 0,
    this.speedScale = 1,
  }) {
    size = Vector2.all(50);
    anchor = Anchor.bottomCenter;
    // All Obstacles will be removed after some time
    add(RemoveEffect(delay: 7));
  }

  final ObstacleModel model;

  // Higher speed factor means faster obstacle
  var speedScale = 1;
  var _velocity = Vector2(-250, 0);

  // How much to change velocity each increase
  final _velocityDelta = Vector2(-40, 0);

  bool _collided = false;
  // Delay before spawning
  double delayFactor;
  // true if this is the last obstacle in the wave
  bool isLastInWave = false;

  @override
  Future<void> onLoad() async {
    final filename = 'images/${playerData.scene}/obstacles/${model.filename}';
    final svgInstance = await Svg.load(filename);
    final obst = _ObstacleSvgComponent(svgInstance)..position += size / 2;

    add(obst);
    _velocity += _velocityDelta * speedScale.toDouble();

    addHitbox(HitboxRectangle(relation: Vector2(0.8, 0.8)));

    return super.onLoad();
  }

  void increaseSpeed() => _velocity += _velocityDelta;
  void decreaseSpeed() => _velocity -= _velocityDelta;

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    if (other is HeroComponent && !_collided) {
      _collided = true;

      // TODO: How to fix this?
      position.x = -1000;
      gameRef.onGameOver();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (GameState.state != PlayState.playing) return;
    if (_collided) return;

    // move obstacle
    position += _velocity * dt;

    // TODO: how to get global coordinates? Or create left edge collider
    var offset = 100;
    var leftEdge = gameRef.size.x + offset;
    if (position.x < -leftEdge && isLastInWave) {
      isLastInWave = false;
      gameRef.onWaveComplete();
    }

    super.update(dt);
  }
}

class _ObstacleSvgComponent extends SvgComponent {
  _ObstacleSvgComponent(svgInstance) : super.fromSvg(svgInstance) {
    size = Vector2.all(90);
    //position.x += size.x / 2;
    anchor = Anchor.center;
  }
}

class _ObstacleRiveComponent extends RiveComponent {
  _ObstacleRiveComponent({required artboard})
      : super(
          artboard: artboard,
          size: Vector2.all(330),
        );

  @override
  Future<void> onLoad() async {
    final controller = SimpleAnimation('Running');
    artboard.addController(controller);
    await super.onLoad();
  }
}
