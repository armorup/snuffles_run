import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:snuffles_run/game.dart';

class CutScene extends StatelessWidget {
  const CutScene({Key? key, required this.game}) : super(key: key);
  final SnufflesGame game;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GameWidget(
        game: CutSceneGame(game: game),
        //Work in progress loading screen on game start
        loadingBuilder: (context) => const Material(
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

/// add the cut scene components to this game
class CutSceneGame extends FlameGame with TapDetector {
  CutSceneGame({required this.game});
  final SnufflesGame game;
  @override
  Future<void> onLoad() async {
    await super.onLoad();
  }

  void beginCutScene() {
    // Use Data to determine which cutscene to play
  }

  void endCutScene() {
    //game.overlays.remove('cutscene');
    //game.goScene(?);
  }
}
