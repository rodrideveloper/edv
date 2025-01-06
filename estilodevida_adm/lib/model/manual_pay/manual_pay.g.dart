// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manual_pay.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ManualPayModel _$ManualPayModelFromJson(Map<String, dynamic> json) =>
    ManualPayModel(
      id: json['id'] as String,
      date: const TimestampConverter().fromJson(json['date'] as Timestamp),
      packName: json['packName'] as String,
      packId: json['packId'] as String,
      userName: json['userName'] as String,
      userId: json['userId'] as String,
      status: json['status'] as bool,
      metodo: json['metodo'] as String,
    );

Map<String, dynamic> _$ManualPayModelToJson(ManualPayModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': const TimestampConverter().toJson(instance.date),
      'packName': instance.packName,
      'packId': instance.packId,
      'userName': instance.userName,
      'userId': instance.userId,
      'status': instance.status,
      'metodo': instance.metodo,
    };
