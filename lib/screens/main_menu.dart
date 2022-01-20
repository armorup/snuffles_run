import 'package:flutter/material.dart';
import 'package:snuffles_run/game.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Snuffles Run',
                style: Theme.of(context).textTheme.headline1?.copyWith(
                  fontSize: 50,
                  color: Colors.white,
                  shadows: [
                    const Shadow(
                      blurRadius: 20,
                      color: Colors.blue,
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
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const GamePlay(),
                    ),
                  );
                },
                child: const Text('Play'),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Options'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
