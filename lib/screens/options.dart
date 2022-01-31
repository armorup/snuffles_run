import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OptionsMenu extends StatelessWidget {
  const OptionsMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
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
                onPressed: () => context.push('/achievements'),
                child: const Text('Achievements'),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Back'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
