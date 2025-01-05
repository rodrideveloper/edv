// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_lesson_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterLessonModel _$RegisterLessonModelFromJson(Map<String, dynamic> json) =>
    RegisterLessonModel(
      (json['lessons'] as num?)?.toInt(),
      id: json['id'] as String,
      userName: json['userName'] as String?,
      date: const TimestampConverter().fromJson(json['date'] as Timestamp),
      packId: json['packId'] as String,
      userPhoto: json['userPhoto'] as String?,
    );

Map<String, dynamic> _$RegisterLessonModelToJson(RegisterLessonModel instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'packId': instance.packId,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('userName', instance.userName);
  val['date'] = const TimestampConverter().toJson(instance.date);
  writeNotNull('userPhoto', instance.userPhoto);
  writeNotNull('lessons', instance.lessons);
  return val;
}
