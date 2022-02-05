import 'dart:convert';

import 'package:flame/flame.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snuffles_run/game_data.dart';
import 'package:snuffles_run/player_data.dart';
import 'package:snuffles_run/screens/achievements.dart';
import 'package:snuffles_run/screens/endless.dart';
import 'package:snuffles_run/screens/main_menu.dart';
import 'package:snuffles_run/screens/options.dart';
import 'package:snuffles_run/screens/playmode.dart';

import 'game.dart';

// Single instance of player and game data here
late PlayerData playerData;
late GameData gameData;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.setLandscape();
  await Flame.device.fullScreen();

  // Load game data
  var json = await rootBundle
      .loadString('assets/game_data.json')
      .then((value) => jsonDecode(value));
  gameData = GameData.fromJson(json);

  // Load saved data

  var prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('data')) {
    playerData = PlayerData.fromJson(
      jsonDecode(prefs.get('data').toString()),
    );
  } else {
    playerData = PlayerData();
  }

  var themeData = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.lightBlue,
    scaffoldBackgroundColor: Colors.white,
    backgroundColor: Colors.blueAccent,
    fontFamily: 'Georgia',
    textTheme: const TextTheme(
      headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
    ),
  );

  runApp(
    MaterialApp(
      title: 'Snuffles Run',
      //themeMode: ThemeMode.system,
      theme: themeData,
      home: App(),
    ),
  );
}

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => Page(const MainMenu()),
      ),
      GoRoute(
        path: '/playmode',
        pageBuilder: (context, state) => Page(const PlayMode()),
      ),
      GoRoute(
        path: '/game',
        pageBuilder: (context, state) => Page(const GameLoader()),
      ),
      GoRoute(
        path: '/endless',
        pageBuilder: (context, state) => Page(const Endless()),
      ),
      GoRoute(
        path: '/options',
        pageBuilder: (context, state) => Page(const OptionsMenu()),
      ),
      GoRoute(
        path: '/achievements',
        pageBuilder: (context, state) => Page(const Achievements()),
      )
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
    );
  }
}

/// Custom Fade transistion
class Page extends CustomTransitionPage {
  Page(child)
      : super(
          child: child,
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        );
}
