import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snuffles_run/data.dart';
import 'package:snuffles_run/game.dart';

class Debug extends StatelessWidget {
  const Debug({Key? key, required this.game}) : super(key: key);
  final SnufflesGame game;

  @override
  Widget build(BuildContext context) {
    final scenes = SceneType.values
        .map(
          (sceneType) => Scene(
            game: game,
            sceneType: sceneType,
          ),
        )
        .toList();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {
                  game.overlays.remove('debug');
                  context.go('/');
                },
                child: const Text(
                  'Exit to Main Menu',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                scrollDirection: Axis.vertical,
                itemCount: scenes.length,
                itemBuilder: (context, index) => scenes[index],
                separatorBuilder: (context, index) => const SizedBox(
                  width: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The scene to show on map
class Scene extends StatelessWidget {
  const Scene({Key? key, required this.game, required this.sceneType})
      : super(key: key);
  final SnufflesGame game;
  final SceneType sceneType;

  @override
  Widget build(BuildContext context) {
    final sceneName = sceneType.toString().split('.').last;
    final highScore = game.data.scenes[sceneType]?['highscore'];
    final text = '$sceneName: $highScore';

    return SizedBox(
      width: MediaQuery.of(context).size.width / 4,
      child: ElevatedButton(
        onPressed: () {
          game.overlays.remove('debug');
          game.goScene(sceneType);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
