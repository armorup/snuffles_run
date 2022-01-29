import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snuffles_run/data.dart';
import 'package:snuffles_run/game.dart';

class GameMap extends StatelessWidget {
  const GameMap({Key? key, required this.game}) : super(key: key);
  final SnufflesGame game;

  @override
  Widget build(BuildContext context) {
    final numScenes = Data.scenes.length;
    final scenes = Data.scenes.keys
        .map(
          (sceneType) => Scene(
            game: game,
            sceneType: sceneType,
          ),
        )
        .toList();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: Text(
                'Game map',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {
                  game.overlays.remove('map');
                  game.overlays.add('main menu');
                },
                child: const Text('Exit to Main Menu'),
              ),
            ),
            Expanded(
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: numScenes,
                itemBuilder: (context, index) => scenes[index],
                separatorBuilder: (context, index) => const SizedBox(
                  width: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Scene extends StatelessWidget {
  const Scene({Key? key, required this.game, required this.sceneType})
      : super(key: key);
  final SnufflesGame game;
  final SceneType sceneType;

  @override
  Widget build(BuildContext context) {
    final sceneName = sceneType.toString().split('.').last;
    final locked = Data.scenes[sceneType]!['locked'];
    final highScore = Data.scenes[sceneType]!['highscore'];
    final scoreHeader = locked ? '' : 'High Score';
    final scoreText = locked ? '' : '$highScore';
    return SizedBox(
      width: MediaQuery.of(context).size.width / 4,
      child: ElevatedButton(
        onPressed: () {
          if (locked) return;
          game.overlays.remove('map');
          game.goScene(sceneType);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              sceneName,
              style: const TextStyle(fontSize: 30),
            ),
            const SizedBox(
              height: 15,
            ),
            locked ? const Icon(Icons.lock) : const Icon(Icons.check),
            const SizedBox(
              height: 15,
            ),
            Text(
              scoreHeader,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 7,
            ),
            Text(
              scoreText,
              style: const TextStyle(fontSize: 40),
            ),
          ],
        ),
      ),
    );
  }
}
