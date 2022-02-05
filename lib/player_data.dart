import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snuffles_run/game_data.dart';

part 'player_data.g.dart';

/// The Player's data
@JsonSerializable()
class PlayerData {
  HeroType hero;
  SceneType curScene;
  late List<SceneDetails> scenes;

  /// Constructor for brand new game
  PlayerData({
    this.hero = HeroType.bunny,
    this.curScene = SceneType.outdoor,
  }) {
    scenes = [
      SceneDetails(
        sceneType: SceneType.outdoor,
        unlocked: true,
        highscore: 0,
      ),
    ];
  }

  /// Constructor for debugging that unlocks every scene
  factory PlayerData.debug() {
    var pd = PlayerData();
    for (var sceneType in SceneType.values) {
      pd.scenes.add(
        SceneDetails(
          sceneType: sceneType,
          unlocked: true,
          highscore: 0,
        ),
      );
    }
    return pd;
  }

  /// Generated code for reading from/to json
  factory PlayerData.fromJson(Map<String, dynamic> json) =>
      _$PlayerDataFromJson(json);
  Map<String, dynamic> toJson() => _$PlayerDataToJson(this);

  /// Instantiate from save
  factory PlayerData.fromSave(SharedPreferences prefs) {
    return prefs.containsKey('data')
        ? PlayerData.fromJson(
            jsonDecode(prefs.get('data').toString()),
          )
        : PlayerData();
  }

  String get scene => curScene.toString().split('.').last;

  int highscoreOf({required SceneType sceneType}) {
    return scenes.firstWhere((scene) => scene.sceneType == sceneType).highscore;
  }

  /// Save the current data to shared prefs
  void save() async {
    var prefs = await SharedPreferences.getInstance();
    String json = jsonEncode(toJson());
    prefs.setString('data', json);
  }

  /// Return unlocked scenes
  List<SceneType> unlockedScenes() {
    return scenes
        .where((scene) => scene.unlocked)
        .map((e) => e.sceneType)
        .toList();
  }

  /// Discover a new scene. Return true if it's a new discover
  bool discoverScene(SceneType sceneType) {
    if (scenes.firstWhere((scene) => scene.sceneType == sceneType) == null) {
      scenes.add(
        SceneDetails(
          sceneType: sceneType,
          unlocked: false,
          highscore: 0,
        ),
      );
      return true;
    }
    return false;
  }

  bool isUnlocked(SceneType sceneType) {
    return (scenes
        .firstWhere((scene) => scene.sceneType == sceneType)
        .unlocked);
  }

  void unlock(SceneType sceneType) {
    scenes.firstWhere((scene) => scene.sceneType == sceneType).unlocked = true;
  }

  /// Unlock a scene. Return true if a scene was unlocked, false otherwise
  bool unlockScene(SceneType sceneType) {
    if (isUnlocked(sceneType)) {
      return false;
    }
    unlock(sceneType);
    return true;
  }

  /// Update high score for current scene
  void updateHighscore(int score) {
    final highscore =
        scenes.firstWhere((scene) => scene.sceneType == curScene).highscore;
    if (score > highscore) {
      scenes.firstWhere((scene) => scene.sceneType == curScene).highscore =
          score;
    }
  }

  /// Player Achievements
}

/// Player scene details
@JsonSerializable()
class SceneDetails {
  SceneType sceneType;
  bool unlocked;
  int highscore;
  SceneDetails({
    required this.sceneType,
    required this.unlocked,
    required this.highscore,
  });

  factory SceneDetails.fromJson(Map<String, dynamic> json) =>
      _$SceneDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$SceneDetailsToJson(this);
}
