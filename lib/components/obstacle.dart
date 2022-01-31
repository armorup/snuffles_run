import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/geometry.dart';
import 'package:flame_svg/flame_svg.dart';
import 'package:snuffles_run/game.dart';
import 'package:snuffles_run/components/snuffles.dart';
import 'package:snuffles_run/game_state.dart';

class Obstacle extends SpriteComponent
    with HasGameRef<SnufflesGame>, HasHitboxes, Collidable {
  /// Delay factor is a value between 0 (no start delay) and 1
  Obstacle({
    this.delayFactor = 0,
    this.speedScale = 1,
  }) {
    size = Vector2.all(50);
    anchor = Anchor.bottomLeft;
    // All Obstacles will be removed after 7 seconds
    add(RemoveEffect(delay: 7));
  }

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
  // true if this is the last obstacle in the level
  bool isLastInLevel = false;

  @override
  Future<void> onLoad() async {
    // Load random stone sprite images
    // TODO: Load all game images once in main game

    var numImages = 5;
    var imageNames = <String>[];
    var scene = gameRef.data.curScene.toString().split('.').last;
    var path = '$scene/obstacles/';

    for (var i = 0; i < numImages; i++) {
      imageNames.add('${path}obst_${i + 1}.png');
      await gameRef.images.load(imageNames[i]);
    }
    var r = Random().nextInt(numImages);
    sprite = Sprite(gameRef.images.fromCache(imageNames[r]));

    // try svg
    final svgInstance =
        await Svg.load('images/outdoor/obstacles/game_map_image.svg');
    final rock = SvgComponent.fromSvg(svgInstance)
      ..position = position
      ..size = (Vector2.all(100))
      ..anchor = Anchor.center;
    add(rock);

    // Set obstacle velocity
    _velocity += _velocityDelta * speedScale.toDouble();

    addHitbox(HitboxRectangle(relation: Vector2(0.8, 0.8)));
    return super.onLoad();
  }

  void increaseSpeed() => _velocity += _velocityDelta;

  void decreaseSpeed() => _velocity -= _velocityDelta;

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    if (other is SnufflesComponent && !_collided) {
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
