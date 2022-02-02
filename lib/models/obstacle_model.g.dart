// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'obstacle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ObstacleModel _$ObstacleModelFromJson(Map<String, dynamic> json) =>
    ObstacleModel(
      type: json['type'] as String,
      filename: json['filename'] as String,
    );

Map<String, dynamic> _$ObstacleModelToJson(ObstacleModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'filename': instance.filename,
    };
