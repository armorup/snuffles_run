import 'package:json_annotation/json_annotation.dart';
import 'package:snuffles_run/game_data.dart';

part 'background_model.g.dart';

@JsonSerializable()
class BackgroundModel {
  final BackgroundType type;
  final List<String> filenames;

  BackgroundModel(this.type, this.filenames);

  factory BackgroundModel.fromJson(Map<String, dynamic> json) =>
      _$BackgroundModelFromJson(json);
  Map<String, dynamic> toJson() => _$BackgroundModelToJson(this);
}
