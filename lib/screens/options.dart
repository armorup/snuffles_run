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
            Text(
              'Options Menu',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Back'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
