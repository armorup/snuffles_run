import 'package:flutter/material.dart';
import 'package:snuffles_run/game.dart';
import 'package:snuffles_run/main.dart';

class CutScene extends StatelessWidget {
  const CutScene({
    Key? key,
    required this.game,
  }) : super(key: key);
  final SnufflesGame game;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await game.goScene(playerData.curScene);
        game.overlays.remove('cutscene');
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text(
            'Play cutscene for ${playerData.scene}',
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
