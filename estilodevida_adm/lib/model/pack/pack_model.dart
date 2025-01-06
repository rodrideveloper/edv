import 'package:json_annotation/json_annotation.dart';
part 'pack_model.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class PackModel {
  final String id;
  final String title;
  final int lessons;
  final int dueDays;
  final double unitPrice;

  PackModel({
    required this.id,
    required this.title,
    required this.lessons,
    required this.unitPrice,
    required this.dueDays,
  });

  factory PackModel.fromJson(Map<String, dynamic> json) =>
      _$PackModelFromJson(json);

  Map<String, dynamic> toJson() => _$PackModelToJson(this);
}
