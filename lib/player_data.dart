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
  late EndlessDetails endless;
  late Map<SceneType, SceneDetails> scenes;

  /// Constructor for brand new game
  PlayerData({
    this.hero = HeroType.bunny,
    this.curScene = SceneType.forest,
  }) {
    endless = EndlessDetails(
      highscore: 0,
      unlocked: false,
      startingPoint: 0,
    );
    scenes = {
      SceneType.forest: SceneDetails(
        unlocked: true,
        highscore: 0,
        cutscenePlayed: false,
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
          cutscenePlayed: false,
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

  /// Get the name of the current scene
  String get scene => curScene.toString().split('.').last;

  /// Returns true if the current scene has already been played
  bool get cutscenePlayed => scenes[curScene]!.cutscenePlayed;
  set cutscenePlayed(bool played) => scenes[curScene]!.cutscenePlayed = played;

  /// Return the highscore of the given scene
  int highscoreOf({required SceneType sceneType}) =>
      scenes[sceneType]?.highscore ?? 0;

  /// Save the current data to shared prefs
  void save() async {
    var prefs = await SharedPreferences.getInstance();
    String json = jsonEncode(toJson());
    prefs.setString('data', json);
  }

  /// Discover a new scene. Return true if it's a new discover, false if
  /// the scene was already discovered
  bool discoverScene(SceneType sceneType) {
    if (scenes.containsKey(sceneType)) return false;
    scenes.putIfAbsent(
      sceneType,
      () => SceneDetails(
        unlocked: false,
        highscore: 0,
        cutscenePlayed: false,
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
  bool cutscenePlayed;
  SceneDetails({
    required this.unlocked,
    required this.highscore,
    required this.cutscenePlayed,
  });

  factory SceneDetails.fromJson(Map<String, dynamic> json) =>
      _$SceneDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$SceneDetailsToJson(this);
}

/// Player endless details
@JsonSerializable()
class EndlessDetails {
  bool unlocked;
  int highscore;
  int startingPoint;
  EndlessDetails({
    required this.unlocked,
    required this.highscore,
    required this.startingPoint,
  });

  factory EndlessDetails.fromJson(Map<String, dynamic> json) =>
      _$EndlessDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$EndlessDetailsToJson(this);
}
