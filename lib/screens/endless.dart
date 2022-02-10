import 'package:flutter/material.dart';
import 'package:snuffles_run/game.dart';

class Endless extends StatelessWidget {
  const Endless({Key? key, required this.game}) : super(key: key);
  final SnufflesGame game;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Endless Mode',
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                game.overlays.add('main_menu');
                game.overlays.remove('endless');
              },
              child: const Text('Back to Menu'),
            ),
          ],
        ),
      ),
    );
  }
}
