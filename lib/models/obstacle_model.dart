import 'package:json_annotation/json_annotation.dart';

part 'obstacle_model.g.dart';

@JsonSerializable()
class ObstacleModel {
  final String type;
  final String filename;

  ObstacleModel({required this.type, required this.filename});

  factory ObstacleModel.fromJson(Map<String, dynamic> json) =>
      _$ObstacleModelFromJson(json);
  Map<String, dynamic> toJson() => _$ObstacleModelToJson(this);
}
