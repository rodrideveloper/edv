part of 'event_pay.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventPay _$EventPayFromJson(Map<String, dynamic> json) => EventPay(
      id: json['id'] as String,
      date: const TimestampConverter().fromJson(json['date'] as Timestamp),
      eventName: json['eventName'] as String,
      eventId: json['eventId'] as String,
      userName: json['userName'] as String,
      userId: json['userId'] as String,
      status: json['status'] as bool,
      metodo: json['metodo'] as String,
    );

Map<String, dynamic> _$EventPayToJson(EventPay instance) => <String, dynamic>{
      'id': instance.id,
      'date': const TimestampConverter().toJson(instance.date),
      'eventName': instance.eventName,
      'eventId': instance.eventId,
      'userName': instance.userName,
      'userId': instance.userId,
      'status': instance.status,
      'metodo': instance.metodo,
    };
