import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:snuffles_run/game.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key, required this.game}) : super(key: key);
  final SnufflesGame game;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        onPressed: () {
          game.overlays.add('options');
          game.overlays.remove('main_menu');
        },
        child: const Icon(
          Icons.settings,
          size: 50,
          color: Colors.blue,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Snuffles Run',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                  fontSize: 50,
                  color: Theme.of(context).primaryColor,
                  shadows: [
                    const Shadow(
                      blurRadius: 20,
                      color: Colors.lightBlue,
                      offset: Offset(-2, 2),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: ElevatedButton(
                onPressed: () {
                  FlameAudio.audioCache.play('sfx/Abstract1.mp3');
                  game.overlays.add('map');
                  game.overlays.remove('main_menu');
                },
                child: const Text('Play'),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: ElevatedButton(
                onPressed: () {
                  FlameAudio.audioCache.play('sfx/Abstract1.mp3');
                  game.overlays.add('endless');
                  game.overlays.remove('main_menu');
                },
                child: const Text('Endless'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
