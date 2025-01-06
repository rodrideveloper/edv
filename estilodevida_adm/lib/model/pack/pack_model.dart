import 'package:json_annotation/json_annotation.dart';
part 'pack_model.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class PackModel {
  final String title;
  final int lessons;
  final int dueDays;
  final double price;

  PackModel({
    required this.title,
    required this.lessons,
    required this.price,
    required this.dueDays,
  });

  factory PackModel.fromJson(Map<String, dynamic> json) =>
      _$PackModelFromJson(json);

  Map<String, dynamic> toJson() => _$PackModelToJson(this);
}
