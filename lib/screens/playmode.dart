import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PlayMode extends StatelessWidget {
  const PlayMode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        child: const Icon(
          Icons.arrow_back,
          size: 50,
          color: Colors.black,
        ),
        onPressed: () => context.go('/'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Snuffles Run',
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
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
                  context.go('/game');
                },
                child: const Text('Story'),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: ElevatedButton(
                onPressed: () {
                  FlameAudio.audioCache.play('sfx/Abstract1.mp3');
                  context.go('/Endless');
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
