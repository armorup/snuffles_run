import 'package:json_annotation/json_annotation.dart';
import 'package:snuffles_run/models/hero_model.dart';
import 'package:snuffles_run/models/scene_model.dart';

part 'data.g.dart';

enum HeroType { bunny }

/// The scenario type
/// Matches scene type name to folder that contains the parallax images
enum SceneType {
  outdoor,
  forest,
  backyard,
  kitchen,
}

@JsonSerializable(explicitToJson: true)
class GameData {
  final List<HeroModel> heros;
  final List<SceneModel> scenes;

  GameData({required this.heros, required this.scenes});

  factory GameData.fromJson(Map<String, dynamic> json) =>
      _$GameDataFromJson(json);
  Map<String, dynamic> toJson() => _$GameDataToJson(this);

  SceneModel getScene(SceneType sceneType) {
    return scenes.firstWhere((scene) => scene.type == sceneType);
  }
}
