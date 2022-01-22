import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snuffles_run/game.dart';
import 'package:snuffles_run/screens/options.dart';

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  final _router = GoRouter(routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainMenu(),
    ),
    GoRoute(
      path: '/game',
      builder: (context, state) => const GamePlay(),
    ),
    GoRoute(
      path: '/options',
      builder: (context, state) => const OptionsMenu(),
    )
  ]);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
    );
  }
}

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
                onPressed: () => context.go('/game'),
                child: const Text('Play'),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: ElevatedButton(
                onPressed: () => context.go('/options'),
                child: const Text('Options'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
