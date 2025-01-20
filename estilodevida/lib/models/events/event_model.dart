import 'package:json_annotation/json_annotation.dart';
part 'event_model.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class EventModel {
  final String id;
  final String title;
  final String subTitle;
  final double price;

  EventModel({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.price,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);

  Map<String, dynamic> toJson() => _$EventModelToJson(this);
}
