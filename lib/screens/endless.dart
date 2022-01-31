import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Endless extends StatelessWidget {
  const Endless({Key? key}) : super(key: key);

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
              onPressed: () => context.go('/'),
              child: const Text('Back to Menu'),
            ),
          ],
        ),
      ),
    );
  }
}
