import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estilodevida/models/utils/time_stamp_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event_pay.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class EventPay {
  final String id;
  @TimestampConverter()
  final DateTime date;
  final String eventName;
  final String eventId;
  final String userName;
  final String userId;
  final bool status;
  final String metodo;

  EventPay({
    required this.id,
    required this.date,
    required this.eventName,
    required this.eventId,
    required this.userName,
    required this.userId,
    required this.status,
    required this.metodo,
  });

  factory EventPay.fromJson(Map<String, dynamic> json) =>
      _$EventPayFromJson(json);

  Map<String, dynamic> toJson() => _$EventPayToJson(this);
}
