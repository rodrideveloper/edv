import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estilodevida_adm/time_stamp_converter.dart';
import 'package:json_annotation/json_annotation.dart';
part 'register_lesson_model.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class RegisterLessonModel {
  final String id;
  final String packId;
  final String? userName;
  @TimestampConverter()
  final DateTime date;
  final String? userPhoto;

  RegisterLessonModel({
    required this.id,
    required this.userName,
    required this.date,
    required this.packId,
    required this.userPhoto,
  });
  factory RegisterLessonModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterLessonModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterLessonModelToJson(this);
}
