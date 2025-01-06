import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estilodevida_adm/time_stamp_converter.dart';

import 'package:json_annotation/json_annotation.dart';
part 'manual_pay.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class ManualPayModel {
  final String id;
  @TimestampConverter()
  final DateTime date;
  final String packName;
  final String packId;
  final String userName;
  final String userId;
  final bool status;
  final String metodo;

  ManualPayModel({
    required this.id,
    required this.date,
    required this.packName,
    required this.packId,
    required this.userName,
    required this.userId,
    required this.status,
    required this.metodo,
  });

  factory ManualPayModel.fromJson(Map<String, dynamic> json) =>
      _$ManualPayModelFromJson(json);

  Map<String, dynamic> toJson() => _$ManualPayModelToJson(this);
}
