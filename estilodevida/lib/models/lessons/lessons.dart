import 'package:json_annotation/json_annotation.dart';
part 'lessons.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class LessonsModel {
  final int amount;

  LessonsModel({required this.amount});

  factory LessonsModel.fromJson(Map<String, dynamic> json) =>
      _$LessonsModelFromJson(json);

  Map<String, dynamic> toJson() => _$LessonsModelToJson(this);
}
