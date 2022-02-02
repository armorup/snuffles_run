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
