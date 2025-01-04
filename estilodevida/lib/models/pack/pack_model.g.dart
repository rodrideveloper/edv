// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pack_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PackModel _$PackModelFromJson(Map<String, dynamic> json) => PackModel(
      title: json['title'] as String,
      lessons: (json['lessons'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      dueDays: (json['dueDays'] as num).toInt(),
    );

Map<String, dynamic> _$PackModelToJson(PackModel instance) => <String, dynamic>{
      'title': instance.title,
      'lessons': instance.lessons,
      'dueDays': instance.dueDays,
      'price': instance.price,
    };
