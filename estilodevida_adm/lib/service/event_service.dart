// file: lib/service/event_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estilodevida_adm/model/events/event_model.dart';

class EventService {
  final CollectionReference _eventsRef =
      FirebaseFirestore.instance.collection('events');

  /// Devuelve un stream con la lista de eventos
  Stream<List<EventModel>> getAllEvents() {
    return _eventsRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return EventModel.fromJson({
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        });
      }).toList();
    });
  }

  Future<void> addEvent(EventModel event) async {
    final docRef = _eventsRef.doc();

    final newId = docRef.id;

    final newEvent = EventModel(
      id: newId,
      title: event.title,
      subTitle: event.subTitle,
      price: event.price,
    );

    await docRef.set(newEvent.toJson());
  }

  Future<void> updateEvent(String id, EventModel event) async {
    final data = event.toJson();
    data.remove('id');
    await _eventsRef.doc(id).update(data);
  }

  Future<void> deleteEvent(String id) async {
    await _eventsRef.doc(id).delete();
  }
}
