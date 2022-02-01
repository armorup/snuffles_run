import 'package:json_annotation/json_annotation.dart';
import 'package:snuffles_run/game_data.dart';
import 'package:snuffles_run/models/obstacle_model.dart';
import 'package:snuffles_run/models/background_model.dart';

part 'scene_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SceneModel {
  final SceneType type;
  final List<ObstacleModel> obstacles;
  final BackgroundModel background;

  SceneModel(
      {required this.type, required this.obstacles, required this.background});

  factory SceneModel.fromJson(Map<String, dynamic> json) =>
      _$SceneModelFromJson(json);
  Map<String, dynamic> toJson() => _$SceneModelToJson(this);
}

class SceneModelList {
  final List<SceneModel> scenes;
  SceneModelList({required this.scenes});

  factory SceneModelList.fromJson(List<dynamic> json) => SceneModelList(
        scenes: json
            .map((e) => SceneModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
