import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:snuffles_run/main.dart';
import 'package:snuffles_run/models/obstacle_model.dart';
import 'package:snuffles_run/models/scene_model.dart';

class Achievements extends StatelessWidget {
  const Achievements({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get a list of all game obstacle models
    List<Widget> svgs = [];
    for (SceneModel sceneModel in gameData.scenes) {
      String sceneName = sceneModel.type.toString().split('.').last;
      String path = 'assets/images/$sceneName/obstacles/';
      for (ObstacleModel obstModel in sceneModel.obstacles) {
        String name = obstModel.type.toString().split('.').last;
        String assetPath = '$path${obstModel.filename}';
        Widget svg = SvgPicture.asset(assetPath, semanticsLabel: name);
        svgs.add(svg);
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Achievements Page',
              style: TextStyle(fontSize: 30),
            ),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Back to Menu'),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: GridView.count(
                scrollDirection: Axis.horizontal,
                crossAxisCount: 2,
                children: svgs,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
