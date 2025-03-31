import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estilodevida_adm/time_stamp_converter.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user_model.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class UserModel {
  final String id;

  @JsonKey(defaultValue: 'N/N')
  final String name;
  @JsonKey(defaultValue: '')
  final String photoURL;
  final String? phone;
  final String email;
  @TimestampConverter()
  final DateTime createdAt;
  UserModel({
    required this.id,
    required this.name,
    required this.photoURL,
    required this.phone,
    required this.email,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
