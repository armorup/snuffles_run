import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snuffles_run/data.dart';
import 'package:snuffles_run/game.dart';

class GameMap extends StatelessWidget {
  const GameMap({Key? key, required this.game}) : super(key: key);
  final SnufflesGame game;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'The Game map',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 4,
                  child: ElevatedButton(
                    onPressed: () {
                      game.overlays.remove('map');
                      game.goScene(SceneType.outdoor);
                    },
                    child: const Text('Outdoor'),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 4,
                  child: ElevatedButton(
                    onPressed: () => game.overlays.remove('map'),
                    child: const Text('Forest'),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 4,
                  child: ElevatedButton(
                    onPressed: () => context.go('/'),
                    child: const Text('Main Menu'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
