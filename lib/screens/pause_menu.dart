import 'package:flutter/material.dart';
import 'package:snuffles_run/game.dart';

import '../game_state.dart';

class PauseMenu extends StatelessWidget {
  const PauseMenu({Key? key, required this.game}) : super(key: key);

  final SnufflesGame game;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          child: Container(
            width: 320,
            padding: const EdgeInsets.all(8),
            color: Colors.white,
            child: ListView(
              shrinkWrap: true,
              children: [
                Center(
                  child: Text(
                    _getTitle(),
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                if (GameState.playState == PlayState.paused)
                  ElevatedButton(
                    onPressed: () => game.overlays.remove('pause'),
                    child: const Text('Resume'),
                  ),
                if (GameState.playState == PlayState.paused)
                  const Padding(padding: EdgeInsets.only(top: 10)),
                ElevatedButton(
                  onPressed: () {
                    game.overlays.remove('pause');
                    game.restart();
                  },
                  child: const Text('Restart'),
                ),
                const Padding(padding: EdgeInsets.only(top: 10)),
                ElevatedButton(
                  onPressed: () {
                    game.overlays.remove('pause');
                    game.overlays.add('levels');
                  },
                  child: const Text('Levels'),
                ),
                const Padding(padding: EdgeInsets.only(top: 10)),
                ElevatedButton(
                  onPressed: () {
                    GameState.showDebugInfo = !GameState.showDebugInfo;
                    game.overlays.remove('pause');
                  },
                  child: const Text('DEBUG'),
                ),
                const Padding(padding: EdgeInsets.only(top: 10)),
                ElevatedButton(
                  onPressed: () => game.overlays.remove('pause'),
                  child: const Text('Exit'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getTitle() {
    if (GameState.playState == PlayState.paused) {
      return 'Pause';
    } else {
      return 'Winner';
    }
  }
}
