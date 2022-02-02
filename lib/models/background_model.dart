import 'package:json_annotation/json_annotation.dart';

part 'background_model.g.dart';

@JsonSerializable()
class BackgroundModel {
  final List<String> filenames;

  BackgroundModel(this.filenames);

  factory BackgroundModel.fromJson(Map<String, dynamic> json) =>
      _$BackgroundModelFromJson(json);
  Map<String, dynamic> toJson() => _$BackgroundModelToJson(this);
}
