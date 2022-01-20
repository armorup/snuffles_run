import 'package:flame/components.dart';
import 'package:snuffles_run/game.dart';
import 'package:snuffles_run/components/obstacle.dart';

enum SpawnState { spawning, inactive, ready }

/// A spawn point for game obstacles
class ObstacleSpawner extends PositionComponent with HasGameRef<SnufflesGame> {
  SpawnState spawnState = SpawnState.inactive;
  double baseDelay = 5;

  // List of delay times before each obstacle spawn as a fraction
  // of the base delay time
  List<double> spawnDelays = [0, 0.5, 0.9];
  Obstacle curObstacle = Obstacle.forTesting();
  double curDelay = 0;
  // List of all obstacles and their delay before spawning for this level
  List<SpawnObject> spawnObjects = [];
  double timer = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    if (debugMode) {
      add(RectangleComponent(size: Vector2(100, 100)));
    }

    for (double delay in spawnDelays) {
      spawnObjects.add(SpawnObject(Obstacle(), delay));
    }

    spawnState = SpawnState.ready;
  }

  /// A callback for the game when next level should begin
  /// Spawn based on scene and level
  void beginSpawning() {
    spawnState = SpawnState.ready;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (spawnState == SpawnState.inactive) return;

    if (spawnState == SpawnState.ready) {
      var spawnObject = spawnObjects.removeAt(0);
      curObstacle = spawnObject.obstacle;
      curDelay = spawnObject.delay * baseDelay;
      spawnState = SpawnState.spawning;
    } else if (spawnState == SpawnState.spawning) {
      timer += dt;
      if (timer > curDelay) {
        timer = 0;
        curObstacle.position.y -= curObstacle.size.y;
        add(curObstacle);
        if (spawnObjects.isEmpty) {
          spawnState = SpawnState.inactive;
        } else {
          spawnState = SpawnState.ready;
        }
      }
    }
  }
}

/// An object to associate spawn object to the delay before they're spawned
class SpawnObject {
  final Obstacle obstacle;
  final double delay;

  SpawnObject(this.obstacle, this.delay);
}
