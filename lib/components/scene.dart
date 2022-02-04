import 'package:flame/components.dart';
import 'package:snuffles_run/components/background.dart';
import 'package:snuffles_run/components/ground.dart';
import 'package:snuffles_run/components/obstacle_spawner.dart';
import 'package:snuffles_run/game.dart';
import 'package:snuffles_run/game_data.dart';
import 'package:snuffles_run/main.dart';

enum PausedState { paused, unpaused, pausing, unpausing }

abstract class Pausable {
  void pause();
  void unpause();
}

class Scene extends Component
    with HasGameRef<SnufflesGame>
    implements Pausable {
  late Background background;
  late ObstacleSpawner spawner;
  late Ground ground;
  PausedState state = PausedState.paused;

  @override
  void update(double dt) {
    super.update(dt);

    if (state == PausedState.paused) return;
    if (state == PausedState.pausing) {
      children.whereType<Pausable>().forEach((child) => child.pause());
      state == PausedState.paused;
    }
    if (state == PausedState.unpausing) {
      children.whereType<Pausable>().forEach((child) => child.unpause());
      state == PausedState.unpaused;
    }
  }

  @override
  void pause() {
    state = PausedState.pausing;
  }

  @override
  void unpause() {
    state = PausedState.unpausing;
  }

  Future<void> loadScene(SceneType sceneType) async {
    var sceneModel = gameData.getScene(sceneType);
    removeAll(children);

    // Add background before other components
    background = Background(sceneModel.background);
    ground = Ground();

    await add(background);
    await add(ground);
    // Add spawner last
    spawner = ObstacleSpawner(sceneModel.obstacles)
      ..position = Vector2(gameRef.size.x + 20, ground.y);
    await add(spawner);
  }
}
