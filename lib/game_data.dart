import 'package:json_annotation/json_annotation.dart';
import 'package:snuffles_run/models/hero_model.dart';
import 'package:snuffles_run/models/scene_model.dart';

part 'game_data.g.dart';

enum HeroType { bunny }

/// The scenario type must be in this order
/// Matches scene type name to folder that contains the parallax images
enum SceneType {
  forest,
  backyard,
  kitchen,
}

@JsonSerializable(explicitToJson: true)
class GameData {
  final List<HeroModel> heros;
  final List<SceneModel> scenes;
  final MusicMap music;
  final SfxMap sfx;

  GameData({
    required this.heros,
    required this.music,
    required this.sfx,
    required this.scenes,
  });

  factory GameData.fromJson(Map<String, dynamic> json) =>
      _$GameDataFromJson(json);
  Map<String, dynamic> toJson() => _$GameDataToJson(this);

  SceneModel getScene(SceneType sceneType) {
    return scenes.firstWhere((scene) => scene.type == sceneType);
  }
}

@JsonSerializable()
class MusicMap {
  final String menu;
  final String game;

  MusicMap({required this.menu, required this.game});

  factory MusicMap.fromJson(Map<String, dynamic> json) =>
      _$MusicMapFromJson(json);
  Map<String, dynamic> toJson() => _$MusicMapToJson(this);
}

@JsonSerializable()
class SfxMap {
  final String click;

  SfxMap({required this.click});

  factory SfxMap.fromJson(Map<String, dynamic> json) => _$SfxMapFromJson(json);
  Map<String, dynamic> toJson() => _$SfxMapToJson(this);
}
