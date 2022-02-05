import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OptionsMenu extends StatelessWidget {
  const OptionsMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        onPressed: () => context.go('/'),
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
                onPressed: () => context.go('/achievements'),
                child: const Text('Achievements'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
