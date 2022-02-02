import 'package:flame/components.dart';
import 'package:snuffles_run/components/background.dart';
import 'package:snuffles_run/components/ground.dart';
import 'package:snuffles_run/components/obstacle_spawner.dart';
import 'package:snuffles_run/game.dart';
import 'package:snuffles_run/game_data.dart';
import 'package:snuffles_run/main.dart';

class Scene extends Component with HasGameRef<SnufflesGame> {
  Scene({required this.sceneType});
  final SceneType sceneType;

  late Background background = Background.initial();
  late ObstacleSpawner spawner = ObstacleSpawner.initial();
  late Ground ground = Ground();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await loadScene();
  }

  Future<void> loadScene() async {
    var sceneModel = gameData.getScene(sceneType);
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
