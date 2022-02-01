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
    )..scenes = (json['scenes'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            $enumDecode(_$SceneTypeEnumMap, k), e as Map<String, dynamic>),
      );

Map<String, dynamic> _$PlayerDataToJson(PlayerData instance) =>
    <String, dynamic>{
      'hero': _$HeroTypeEnumMap[instance.hero],
      'curScene': _$SceneTypeEnumMap[instance.curScene],
      'scenes':
          instance.scenes.map((k, e) => MapEntry(_$SceneTypeEnumMap[k], e)),
    };

const _$HeroTypeEnumMap = {
  HeroType.bunny: 'bunny',
  HeroType.dog: 'dog',
};

const _$SceneTypeEnumMap = {
  SceneType.outdoor: 'outdoor',
  SceneType.forest: 'forest',
  SceneType.backyard: 'backyard',
};
