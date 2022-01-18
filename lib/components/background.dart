import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:snuffles_run/components/game.dart';

class Background extends ParallaxComponent<SnufflesGame> {
  Vector2 _baseVelocity = Vector2(10, 0);
  final _velocityMultiplierDelta = Vector2(1.8, 0);
  late ParallaxComponent<FlameGame> background;

  // The parallax list should always show the ground and sky
  final ground = ParallaxImageData('background/_01_ground.png');
  final sky = ParallaxImageData('background/_11_background.png');
  List<String> imageStrings = [
    'background/_02_trees and bushes.png',
    'background/_03_distant_trees.png',
    'background/_04_bushes.png',
    'background/_05_hill1.png',
    'background/_08_clouds.png',
    'background/_10_distant_clouds.png',
  ];

  List<ParallaxImageData> imageData = [];
  List<ParallaxImageData> currentImages = [];

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Load all parallax layers into cache
    imageData = imageStrings.map((e) => ParallaxImageData(e)).toList();

    // Add the ground and sky
    currentImages.add(sky);
    currentImages.add(ground);

    addParallaxLayer();
    addParallaxLayer();
    addParallaxLayer();
    parallax = await gameRef.loadParallax(
      currentImages,
      baseVelocity: _baseVelocity,
      velocityMultiplierDelta: _velocityMultiplierDelta,
    );
  }

  // Add next parallax layer
  void addParallaxLayer() {
    final length = currentImages.length - 2;

    currentImages = currentImages.reversed.toList();
    // remove the first an last images from current parallax
    final sky = currentImages.removeLast();
    currentImages.add(imageData[length]);
    currentImages.add(sky);
    currentImages = currentImages.reversed.toList();
  }

  // Return true if background is scrolling
  bool _isScrolling() {
    if (parallax == null) return false;
    return background.parallax!.baseVelocity != Vector2.zero();
  }

  /// Pause or play parallax
  void toggleParallax() {
    if (_isScrolling()) {
      background.parallax!.baseVelocity = Vector2.zero();
    } else {
      background.parallax!.baseVelocity = _baseVelocity;
    }
  }
}
