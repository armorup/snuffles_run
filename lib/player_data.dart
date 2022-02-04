import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snuffles_run/game_data.dart';

part 'player_data.g.dart';

/// The game data utilities
@JsonSerializable()
class PlayerData {
  /// Default Constructor
  PlayerData({
    this.hero = HeroType.bunny,
    this.curScene = SceneType.outdoor,
  }) {
    scenes = {
      SceneType.outdoor: {
        'unlocked': true,
        'highscore': 0,
      }
    };
  }

  PlayerData.debug(
      {this.hero = HeroType.bunny, this.curScene = SceneType.outdoor}) {
    scenes = {};
    for (var sceneType in SceneType.values) {
      scenes.putIfAbsent(
        sceneType,
        () => {'unlocked': true, 'highscore': 1},
      );
    }
  }

  HeroType hero;
  SceneType curScene;
  late Map<SceneType, Map<String, dynamic>> scenes;

  String get scene => curScene.toString().split('.').last;

  /// Generated code for reading from/to json
  factory PlayerData.fromJson(Map<String, dynamic> json) =>
      _$PlayerDataFromJson(json);
  Map<String, dynamic> toJson() => _$PlayerDataToJson(this);

  /// Instantiate from save
  factory PlayerData.fromSave(SharedPreferences prefs) {
    String data = prefs.get('data').toString();
    return prefs.get('data') == null
        ? PlayerData()
        : PlayerData.fromJson(
            jsonDecode(data),
          );
  }

  /// Save the current data to shared prefs
  void save() async {
    String json = jsonEncode(toJson());
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('data', json);
  }

  /// Discover a new scene
  bool discoverScene(SceneType sceneType) {
    if (scenes.containsKey(sceneType)) return false;
    scenes.putIfAbsent(sceneType, () => {'unlocked': false, 'highscore': 0});
    return true;
  }

  /// Unlock a scene. Return true if a scene was unlocked, false otherwise
  bool unlockScene(SceneType sceneType) {
    if (!scenes.containsKey(sceneType)) return false;
    var unlocked = scenes[sceneType]!['unlocked'];
    if (unlocked) return false;
    scenes[sceneType]!['unlocked'] = false;
    return true;
  }

  /// Update high score for current scene
  void updateHighscore(int score) {
    final high = scenes[curScene]!['highscore'];
    if (score > high) {
      scenes[curScene]!['highscore'] = score;
    }
  }

  /// Player Achievements
}
