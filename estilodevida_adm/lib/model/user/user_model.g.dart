// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      photoURL: json['photoURL'] as String,
      phone: json['phone'] as String?,
      email: json['email'] as String,
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'name': instance.name,
    'photoURL': instance.photoURL,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('phone', instance.phone);
  val['email'] = instance.email;
  val['createdAt'] = const TimestampConverter().toJson(instance.createdAt);
  return val;
}
