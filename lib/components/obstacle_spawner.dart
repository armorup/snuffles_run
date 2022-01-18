import 'package:flame/components.dart';
import 'package:snuffles_run/components/game.dart';
import 'package:snuffles_run/components/obstacle.dart';
import 'package:snuffles_run/game_state.dart';

class ObstacleSpawner extends PositionComponent with HasGameRef<SnufflesGame> {
  ObstacleSpawner({required Vector2 position}) : super(position: position);

  // List of all obstacles for this level
  List<PositionComponent> obstacles = [];
  double timer = 0;
  double spawnDelay = 10;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(RectangleComponent(size: size));

    obstacles.add(Obstacle());
    obstacles.add(Obstacle());
    obstacles.add(Obstacle());
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Exit loop if the game isn't playing
    if (GameState.playState != PlayState.playing) return;

    // Spawn obstacles from this generator
    if (obstacles.isNotEmpty) {
      timer += dt * 10;
      if (timer > spawnDelay) {
        timer = 0;
        // spawn the next obstacle
        final obstacle = obstacles.removeAt(0);
        obstacle.position = position;

        add(obstacle);
      }
    } else {
      // What to do when obstacle list is empty
    }
  }
}
