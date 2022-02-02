// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameData _$GameDataFromJson(Map<String, dynamic> json) => GameData(
      heros: (json['heros'] as List<dynamic>)
          .map((e) => HeroModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      scenes: (json['scenes'] as List<dynamic>)
          .map((e) => SceneModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GameDataToJson(GameData instance) => <String, dynamic>{
      'heros': instance.heros.map((e) => e.toJson()).toList(),
      'scenes': instance.scenes.map((e) => e.toJson()).toList(),
    };
