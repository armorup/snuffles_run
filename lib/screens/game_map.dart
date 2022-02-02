import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:snuffles_run/game.dart';
import 'package:snuffles_run/game_data.dart';

class GameMap extends StatelessWidget {
  const GameMap({Key? key, required this.game}) : super(key: key);
  final SnufflesGame game;

  @override
  Widget build(BuildContext context) {
    final numScenes = game.playerData.scenes.length;
    final scenes = game.playerData.scenes.keys
        .map(
          (sceneType) => SceneCard(
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
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {
                  game.overlays.remove('map');
                  //game.overlays.add('main menu');
                  context.go('/');
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

/// The scene to show on map
class SceneCard extends StatelessWidget {
  const SceneCard({Key? key, required this.game, required this.sceneType})
      : super(key: key);
  final SnufflesGame game;
  final SceneType sceneType;

  @override
  Widget build(BuildContext context) {
    final sceneName = sceneType.toString().split('.').last;
    final unlocked = game.playerData.scenes[sceneType]!['unlocked'];
    final highScore = game.playerData.scenes[sceneType]!['highscore'];
    final scoreHeader = unlocked ? 'High Score' : '';
    final scoreText = unlocked ? '$highScore' : '';

    //final path = 'assets/images/$sceneName/obstacles/';
    return SizedBox(
      width: MediaQuery.of(context).size.width / 4,
      child: ElevatedButton(
        onPressed: () {
          if (!unlocked) return;
          game.overlays.remove('map');
          game.goScene(sceneType);
        },
        child: Stack(
          children: [
            SvgPicture.asset(
                'assets/images/$sceneName/obstacles/game_card.svg'),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 110),
                  Text(
                    sceneName,
                    style: const TextStyle(fontSize: 30),
                  ),
                  if (!unlocked) const Icon(Icons.lock, size: 40),
                  if (unlocked)
                    Text(
                      scoreHeader,
                      style: const TextStyle(fontSize: 20),
                    ),
                  if (unlocked)
                    Text(
                      scoreText,
                      style: const TextStyle(fontSize: 40),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
