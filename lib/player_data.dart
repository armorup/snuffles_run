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
  late Map<SceneType, SceneDetails> scenes;

  /// Constructor for brand new game
  PlayerData({
    this.hero = HeroType.bunny,
    this.curScene = SceneType.forest,
  }) {
    scenes = {
      SceneType.forest: SceneDetails(
        unlocked: true,
        highscore: 0,
      ),
    };
  }

  /// Constructor for debugging that unlocks every scene
  factory PlayerData.debug() {
    var pd = PlayerData();
    for (var sceneType in SceneType.values) {
      pd.scenes.putIfAbsent(
        sceneType,
        () => SceneDetails(
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
    return scenes[sceneType]?.highscore ?? 0;
  }

  /// Save the current data to shared prefs
  void save() async {
    var prefs = await SharedPreferences.getInstance();
    String json = jsonEncode(toJson());
    prefs.setString('data', json);
  }

  /// Discover a new scene. Return true if it's a new discover
  bool discoverScene(SceneType sceneType) {
    if (scenes.containsKey(sceneType)) return false;
    scenes.putIfAbsent(
      sceneType,
      () => SceneDetails(
        unlocked: false,
        highscore: 0,
      ),
    );
    return true;
  }

  /// Unlock a scene
  bool unlockScene(SceneType sceneType) {
    if (scenes.containsKey(sceneType)) {
      if (!scenes[sceneType]!.unlocked) {
        scenes[sceneType]!.unlocked = true;
        return true;
      }
    }
    return false;
  }

  /// Update high score for current scene
  void updateHighscore(int score) {
    final highscore = scenes[curScene]?.highscore ?? 0;
    if (score > highscore) {
      scenes[curScene]?.highscore = score;
    }
  }

  /// Player Achievements
}

/// Player scene details
@JsonSerializable()
class SceneDetails {
  bool unlocked;
  int highscore;
  SceneDetails({
    required this.unlocked,
    required this.highscore,
  });

  factory SceneDetails.fromJson(Map<String, dynamic> json) =>
      _$SceneDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$SceneDetailsToJson(this);
}
