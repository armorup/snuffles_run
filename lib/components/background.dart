import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:snuffles_run/game.dart';
import 'package:snuffles_run/main.dart';
import 'package:snuffles_run/models/background_model.dart';

class Background extends ParallaxComponent<SnufflesGame> {
  Background(this.bgModel);

  factory Background.initial() {
    return Background(gameData.scenes.first.background);
  }

  final BackgroundModel bgModel;

  final Vector2 _baseVelocity = Vector2(10, 0);
  final _velocityMultiplierDelta = Vector2(1.5, 0);

  List<ParallaxImageData> imageData = [];
  List<ParallaxImageData> currentImages = [];

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Load all parallax layers into cache from file
    await reset();
  }

  /// Load images into parallax
  Future<void> _load() async {
    parallax = await gameRef.loadParallax(
      currentImages,
      baseVelocity: _baseVelocity,
      velocityMultiplierDelta: _velocityMultiplierDelta,
    );
  }

  Future<void> reset() async {
    // Load file images
    String path = playerData.scene + '/background/';
    imageData = bgModel.filenames
        .map(
          (filename) => ParallaxImageData('$path$filename'),
        )
        .toList();

    currentImages.clear();
    // Add the ground and sky and one other layer
    currentImages.add(imageData.last);
    currentImages.add(imageData.first);
    addParallaxLayer();

    // Load into parallax
    await _load();
  }

  // Add next parallax layer
  void addParallaxLayer() async {
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

    await _load();
  }

  /// Start parallax
  void start() {
    assert(parallax != null);
    if (parallax!.baseVelocity != Vector2.zero()) return;
    parallax!.baseVelocity = _baseVelocity;
  }

  /// Stop parallax
  void stop() {
    assert(parallax != null);
    if (parallax!.baseVelocity == Vector2.zero()) return;
    parallax!.baseVelocity = Vector2.zero();
  }
}
