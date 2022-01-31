import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Achievements extends StatelessWidget {
  const Achievements({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Achievements Page',
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
