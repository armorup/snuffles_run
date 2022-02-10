import 'package:flutter/material.dart';
import 'package:snuffles_run/game.dart';

class OptionsMenu extends StatelessWidget {
  const OptionsMenu({Key? key, required this.game}) : super(key: key);
  final SnufflesGame game;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        onPressed: () {
          game.overlays.add('main_menu');
          game.overlays.remove('options');
        },
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
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
              'Options Menu',
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: ElevatedButton(
                onPressed: () {
                  game.overlays.add('achievements');
                  game.overlays.remove('options');
                },
                child: const Text('Achievements'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
