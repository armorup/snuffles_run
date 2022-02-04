import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:snuffles_run/components/scene.dart';
import 'package:snuffles_run/game.dart';
import 'package:snuffles_run/main.dart';
import 'package:snuffles_run/models/background_model.dart';

class Background extends ParallaxComponent<SnufflesGame> implements Pausable {
  Background(this.bgModel);

  final BackgroundModel bgModel;
  PausedState state = PausedState.paused;

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

  /// Load images into parallax
  Future<void> _load() async {
    parallax = await gameRef.loadParallax(
      currentImages,
      baseVelocity: _baseVelocity,
      velocityMultiplierDelta: _velocityMultiplierDelta,
    );
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

  @override
  void update(double dt) {
    super.update(dt);
    if (parallax == null) return;
    switch (state) {
      case PausedState.paused:
        if (parallax!.baseVelocity == Vector2.zero()) return;
        parallax!.baseVelocity = Vector2.zero();
        break;
      case PausedState.unpaused:
        if (parallax!.baseVelocity != Vector2.zero()) return;
        parallax!.baseVelocity = _baseVelocity;
        break;
      default:
    }
  }

  /// Start parallax
  @override
  void unpause() {
    state = PausedState.unpaused;
  }

  /// Stop parallax
  @override
  void pause() {
    state = PausedState.paused;
  }
}
