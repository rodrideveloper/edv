import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) => timestamp.toDate();

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}

class NullableTimestampConverter
    implements JsonConverter<DateTime?, Timestamp?> {
  const NullableTimestampConverter();

  @override
  DateTime? fromJson(Timestamp? timestamp) => timestamp?.toDate();

  @override
  Timestamp? toJson(DateTime? date) =>
      date != null ? Timestamp.fromDate(date) : null;
}

/// I made this converter because with the normal ones i couldnt handle the 3 cases i have with this field.
///
/// Example with the field "createdAt".
///
/// Case 1: get "createdAt" from firestore, at FS is of type "Timestamp" and i have to return "DateTime".
///
/// Case 2: when using an existing "createdAt", is a "DateTime" from "Case 1", and should be transform to "Timestamp".
///
/// Case 3: when adding a new "createdAt", is a "serverTimestamp" Flag (this is of type "FieldValue").

class DynamicAuditConverter {
  // Case 1
  static DateTime fromJson(Timestamp timestamp) => timestamp.toDate();

  static Object toJson(Object fieldValueOrDateTime) {
    if (fieldValueOrDateTime is DateTime) {
      // Case 2
      return Timestamp.fromDate(fieldValueOrDateTime);
    }
    // Case 3
    return fieldValueOrDateTime;
  }
}

/// I made this converter because with the normal ones i couldnt handle the 3 cases i have with this field.
///
/// Example with the field "createdAt".
///
/// Case 1: get "createdAt" from firestore, at FS is of type "Timestamp" and i have to return "DateTime".
///
/// Case 2: reading a null timestamp because reading document from cache, and the FieldValue flag was not yet set.
///
/// Case 3: when using an existing "createdAt", is a "DateTime" from "Case 1", and should be transform to "Timestamp".
///
/// Case 4: when adding a new "createdAt", is a "serverTimestamp" Flag (this is of type "FieldValue").

class DynamicNullableAuditConverter {
  static DateTime? fromJson(Timestamp? nullableTimestamp) {
    if (nullableTimestamp != null) {
      // Case 1
      return nullableTimestamp.toDate();
    }
    // Case 2
    return null;
  }

  static Object? toJson(Object? fieldValueOrDateTime) {
    if (fieldValueOrDateTime is DateTime) {
      // Case 3
      return Timestamp.fromDate(fieldValueOrDateTime);
    }
    // Case 4
    return fieldValueOrDateTime;
  }
}
