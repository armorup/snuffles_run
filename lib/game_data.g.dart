// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameData _$GameDataFromJson(Map<String, dynamic> json) => GameData(
      heros: (json['heros'] as List<dynamic>)
          .map((e) => HeroModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      music: MusicMap.fromJson(json['music'] as Map<String, dynamic>),
      sfx: SfxMap.fromJson(json['sfx'] as Map<String, dynamic>),
      scenes: (json['scenes'] as List<dynamic>)
          .map((e) => SceneModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GameDataToJson(GameData instance) => <String, dynamic>{
      'heros': instance.heros.map((e) => e.toJson()).toList(),
      'scenes': instance.scenes.map((e) => e.toJson()).toList(),
      'music': instance.music.toJson(),
      'sfx': instance.sfx.toJson(),
    };

MusicMap _$MusicMapFromJson(Map<String, dynamic> json) => MusicMap(
      menu: json['menu'] as String,
      game: json['game'] as String,
    );

Map<String, dynamic> _$MusicMapToJson(MusicMap instance) => <String, dynamic>{
      'menu': instance.menu,
      'game': instance.game,
    };

SfxMap _$SfxMapFromJson(Map<String, dynamic> json) => SfxMap(
      click: json['click'] as String,
    );

Map<String, dynamic> _$SfxMapToJson(SfxMap instance) => <String, dynamic>{
      'click': instance.click,
    };
