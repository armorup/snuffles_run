// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'background_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BackgroundModel _$BackgroundModelFromJson(Map<String, dynamic> json) =>
    BackgroundModel(
      $enumDecode(_$BackgroundTypeEnumMap, json['type']),
      (json['filenames'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$BackgroundModelToJson(BackgroundModel instance) =>
    <String, dynamic>{
      'type': _$BackgroundTypeEnumMap[instance.type],
      'filenames': instance.filenames,
    };

const _$BackgroundTypeEnumMap = {
  BackgroundType.outdoor: 'outdoor',
  BackgroundType.forest: 'forest',
  BackgroundType.backyard: 'backyard',
  BackgroundType.kitchen: 'kitchen',
};
