import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estilodevida/models/utils/time_stamp_converter.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user_pack.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class UserPackModel {
  final String id;
  final String? userName;
  @TimestampConverter()
  final DateTime buyDate;
  @TimestampConverter()
  final DateTime dueDate;
  final int totalLessons;
  final int? usedLessons;
  final String packId;

  UserPackModel({
    required this.id,
    required this.userName,
    required this.buyDate,
    required this.dueDate,
    required this.totalLessons,
    required this.usedLessons,
    required this.packId,
  });

  factory UserPackModel.fromJson(Map<String, dynamic> json) =>
      _$UserPackModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserPackModelToJson(this);

  bool get isActive => dueDate.isAfter(DateTime.now());

  int get remainingLessons => totalLessons - (usedLessons ?? 0);
}
