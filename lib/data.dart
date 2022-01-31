import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'data.g.dart';

/// The scenario type
/// Matches scene type name to folder that contains the parallax images
enum SceneType {
  outdoor,
  forest,
}

enum HeroType {
  bunny,
  dog,
}

/// The game data utilities
@JsonSerializable()
class Data {
  Data({
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

  HeroType hero;
  SceneType curScene;
  late Map<SceneType, Map<String, dynamic>> scenes;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  factory Data.fromSave(SharedPreferences prefs) {
    String data = prefs.get('data').toString();

    return prefs.get('data') == null
        ? Data()
        : Data.fromJson(
            jsonDecode(data),
          );
  }

  Map<String, dynamic> toJson() => _$DataToJson(this);

  void save() async {
    String json = jsonEncode(toJson());
    var prefs = await SharedPreferences.getInstance();

    prefs.setString('data', json);
  }

  void loadFromSave() async {
    //var json = await rootBundle.loadString('assets/data.json');
    //var restoredData = Data.fromJson(jsonDecode(json));
    //print(restoredData);
  }

  /// Add a scene
  bool addScene(SceneType sceneType) {
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

  // List of file names for each scene
  static Map<SceneType, List<String>> bgFilenames = {
    SceneType.outdoor: [
      '01_ground.png',
      '02_trees and bushes.png',
      '03_distant_trees.png',
      '04_bushes.png',
      '05_hill1.png',
      '06_hill2.png',
      '07_huge_clouds.png',
      '08_clouds.png',
      '09_distant_clouds1.png',
      '10_distant_clouds.png',
      '11_background.png',
    ],
    SceneType.forest: [
      '00_ground.png',
      '01_Mist.png',
      '02_Bushes.png',
      '03_Particles.png',
      '04_Forest.png',
      '05_Particles.png',
      '06_Forest.png',
      '07_Forest.png',
      '08_Forest.png',
      '09_Forest.png',
      '10_Sky.png',
    ]
  };
}
