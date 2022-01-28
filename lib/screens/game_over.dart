import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GameOverScreen extends StatelessWidget {
  const GameOverScreen({Key? key}) : super(key: key);

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
                'Game Over',
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
                  context.go('/');
                },
                child: const Text('Start Over'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
