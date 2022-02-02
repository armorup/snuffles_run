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

// class ObstaclesModelList {
//   final List<ObstacleModel> obstacleModels;

//   ObstaclesModelList({required this.obstacleModels});

//   factory ObstaclesModelList.fromJson(List<dynamic> json) => ObstaclesModelList(
//         obstacleModels: json
//             .map((e) => ObstacleModel.fromJson(e as Map<String, dynamic>))
//             .toList(),
//       );
// }
