// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pack_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PackModel _$PackModelFromJson(Map<String, dynamic> json) => PackModel(
      id: json['id'] as String,
      title: json['title'] as String,
      lessons: (json['lessons'] as num).toInt(),
      unitPrice: (json['unitPrice'] as num).toDouble(),
      dueDays: (json['dueDays'] as num).toInt(),
    );

Map<String, dynamic> _$PackModelToJson(PackModel instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'lessons': instance.lessons,
      'dueDays': instance.dueDays,
      'unitPrice': instance.unitPrice,
    };
