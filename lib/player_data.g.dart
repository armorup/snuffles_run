// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerData _$PlayerDataFromJson(Map<String, dynamic> json) => PlayerData(
      hero: $enumDecodeNullable(_$HeroTypeEnumMap, json['hero']) ??
          HeroType.bunny,
      curScene: $enumDecodeNullable(_$SceneTypeEnumMap, json['curScene']) ??
          SceneType.outdoor,
    )..scenes = (json['scenes'] as List<dynamic>)
        .map((e) => SceneDetails.fromJson(e as Map<String, dynamic>))
        .toList();

Map<String, dynamic> _$PlayerDataToJson(PlayerData instance) =>
    <String, dynamic>{
      'hero': _$HeroTypeEnumMap[instance.hero],
      'curScene': _$SceneTypeEnumMap[instance.curScene],
      'scenes': instance.scenes,
    };

const _$HeroTypeEnumMap = {
  HeroType.bunny: 'bunny',
};

const _$SceneTypeEnumMap = {
  SceneType.outdoor: 'outdoor',
  SceneType.forest: 'forest',
  SceneType.backyard: 'backyard',
  SceneType.kitchen: 'kitchen',
};

SceneDetails _$SceneDetailsFromJson(Map<String, dynamic> json) => SceneDetails(
      sceneType: $enumDecode(_$SceneTypeEnumMap, json['sceneType']),
      unlocked: json['unlocked'] as bool,
      highscore: json['highscore'] as int,
    );

Map<String, dynamic> _$SceneDetailsToJson(SceneDetails instance) =>
    <String, dynamic>{
      'sceneType': _$SceneTypeEnumMap[instance.sceneType],
      'unlocked': instance.unlocked,
      'highscore': instance.highscore,
    };
