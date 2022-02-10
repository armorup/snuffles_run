import 'dart:convert';

import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snuffles_run/game_data.dart';
import 'package:snuffles_run/player_data.dart';

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
      home: const GameLoader(),
    ),
  );
}
