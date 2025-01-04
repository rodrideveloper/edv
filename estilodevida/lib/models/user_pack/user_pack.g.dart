// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_pack.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserPackModel _$UserPackModelFromJson(Map<String, dynamic> json) =>
    UserPackModel(
      id: json['id'] as String,
      userName: json['userName'] as String?,
      buyDate:
          const TimestampConverter().fromJson(json['buyDate'] as Timestamp),
      dueDate:
          const TimestampConverter().fromJson(json['dueDate'] as Timestamp),
      totalLessons: (json['totalLessons'] as num).toInt(),
      usedLessons: (json['usedLessons'] as num?)?.toInt(),
      packId: json['packId'] as String,
    );

Map<String, dynamic> _$UserPackModelToJson(UserPackModel instance) {
  final val = <String, dynamic>{
    'id': instance.id,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('userName', instance.userName);
  val['buyDate'] = const TimestampConverter().toJson(instance.buyDate);
  val['dueDate'] = const TimestampConverter().toJson(instance.dueDate);
  val['totalLessons'] = instance.totalLessons;
  writeNotNull('usedLessons', instance.usedLessons);
  val['packId'] = instance.packId;
  return val;
}
