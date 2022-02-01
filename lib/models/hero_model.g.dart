// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hero_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HeroModel _$HeroModelFromJson(Map<String, dynamic> json) => HeroModel(
      type: $enumDecode(_$HeroTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$HeroModelToJson(HeroModel instance) => <String, dynamic>{
      'type': _$HeroTypeEnumMap[instance.type],
    };

const _$HeroTypeEnumMap = {
  HeroType.bunny: 'bunny',
  HeroType.dog: 'dog',
};
