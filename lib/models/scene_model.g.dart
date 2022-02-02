// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scene_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SceneModel _$SceneModelFromJson(Map<String, dynamic> json) => SceneModel(
      type: $enumDecode(_$SceneTypeEnumMap, json['type']),
      obstacles: (json['obstacles'] as List<dynamic>)
          .map((e) => ObstacleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      background:
          BackgroundModel.fromJson(json['background'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SceneModelToJson(SceneModel instance) =>
    <String, dynamic>{
      'type': _$SceneTypeEnumMap[instance.type],
      'obstacles': instance.obstacles.map((e) => e.toJson()).toList(),
      'background': instance.background.toJson(),
    };

const _$SceneTypeEnumMap = {
  SceneType.outdoor: 'outdoor',
  SceneType.forest: 'forest',
  SceneType.backyard: 'backyard',
  SceneType.kitchen: 'kitchen',
};
