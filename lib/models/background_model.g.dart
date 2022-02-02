// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'background_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BackgroundModel _$BackgroundModelFromJson(Map<String, dynamic> json) =>
    BackgroundModel(
      (json['filenames'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$BackgroundModelToJson(BackgroundModel instance) =>
    <String, dynamic>{
      'filenames': instance.filenames,
    };
