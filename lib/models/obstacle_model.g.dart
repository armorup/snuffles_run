// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'obstacle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ObstacleModel _$ObstacleModelFromJson(Map<String, dynamic> json) =>
    ObstacleModel(
      type: $enumDecode(_$ObstacleTypeEnumMap, json['type']),
      filename: json['filename'] as String,
    );

Map<String, dynamic> _$ObstacleModelToJson(ObstacleModel instance) =>
    <String, dynamic>{
      'type': _$ObstacleTypeEnumMap[instance.type],
      'filename': instance.filename,
    };

const _$ObstacleTypeEnumMap = {
  ObstacleType.rock: 'rock',
  ObstacleType.fork: 'fork',
};
