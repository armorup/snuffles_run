import 'package:json_annotation/json_annotation.dart';

part 'hero_model.g.dart';

@JsonSerializable()
class HeroModel {
  final String type;
  final String filename;

  HeroModel({required this.type, required this.filename});

  factory HeroModel.fromJson(Map<String, dynamic> json) =>
      _$HeroModelFromJson(json);
  Map<String, dynamic> toJson() => _$HeroModelToJson(this);
}

// class HeroModelList {
//   final List<HeroModel> heros;

//   HeroModelList({required this.heros});

//   factory HeroModelList.fromJson(List<dynamic> json) => HeroModelList(
//         heros: json
//             .map((e) => HeroModel.fromJson(e as Map<String, dynamic>))
//             .toList(),
//       );
// }
