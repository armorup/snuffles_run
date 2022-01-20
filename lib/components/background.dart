import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:snuffles_run/game.dart';
import 'package:snuffles_run/data.dart';

class Background extends ParallaxComponent<SnufflesGame> {
  Background.forTesting() {
    scene = SceneType.outdoor;
  }

  Background(this.scene);
  late final SceneType scene;

  final Vector2 _baseVelocity = Vector2(10, 0);
  final _velocityMultiplierDelta = Vector2(1.8, 0);

  List<ParallaxImageData> imageData = [];
  List<ParallaxImageData> currentImages = [];

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load all parallax layers into cache
    String folder = scene.toString().split('.').last;
    imageData = Data.bgFilenames[scene]!
        .map((e) => ParallaxImageData('$folder/$e'))
        .toList();

    // Add the ground and sky
    currentImages.add(imageData.last);
    currentImages.add(imageData.first);
    addParallaxLayer();
    addParallaxLayer();
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
    if (currentImages.length == imageData.length) return;

    // There should be at minimum 2 layers, ground and sky
    assert(currentImages.length >= 2);
    final length = currentImages.length - 2;

    currentImages = currentImages.reversed.toList();
    // remove the last image which is the sky from current parallax
    final sky = currentImages.removeLast();
    currentImages.add(imageData[length]);
    currentImages.add(sky);
    currentImages = currentImages.reversed.toList();
  }

  // Return true if background is scrolling
  bool _isScrolling() {
    if (parallax == null) return false;

    return parallax!.baseVelocity != Vector2.zero();
  }

  /// Pause or play parallax
  void toggleParallax() {
    if (_isScrolling()) {
      parallax!.baseVelocity = Vector2.zero();
    } else {
      parallax!.baseVelocity = _baseVelocity;
    }
  }
}
