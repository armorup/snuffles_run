import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:snuffles_run/game.dart';
import 'package:snuffles_run/main.dart';
import 'package:snuffles_run/models/obstacle_model.dart';
import 'package:snuffles_run/models/scene_model.dart';

class Achievements extends StatelessWidget {
  const Achievements({Key? key, required this.game}) : super(key: key);
  final SnufflesGame game;

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
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        onPressed: () {
          game.overlays.add('options');
          game.overlays.remove('achievements');
        },
        elevation: 0,
        child: const Icon(
          Icons.arrow_back_ios_new,
          size: 50,
          color: Colors.blue,
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Achievements',
              style: TextStyle(fontSize: 30, color: Colors.blue),
            ),
            Expanded(
              child: GridView.count(
                scrollDirection: Axis.horizontal,
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                padding: const EdgeInsets.all(20),
                shrinkWrap: true,
                children: svgs
                    .map(
                      (svg) => Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.amber),
                          color: Colors.amber.shade200,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              offset: const Offset(3, 3),
                            )
                          ],
                        ),
                        child: svg,
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
