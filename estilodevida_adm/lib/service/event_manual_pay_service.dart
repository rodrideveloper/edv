import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estilodevida_adm/model/event_pay/event_pay.dart';

class EventPayService {
  final CollectionReference _eventPayCollection =
      FirebaseFirestore.instance.collection('event_pay');

  /// Obtiene todos los documentos donde `status` es `false`,
  /// lo que significa que están pendientes de aprobación.
  Stream<List<EventPay>> getPendingEventPays() {
    return _eventPayCollection
        .where('status', isEqualTo: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return EventPay.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  /// Actualiza el registro `EventPay` para ponerlo en `status = true`.
  /// En caso de que necesites crear algo adicional en otra colección,
  /// puedes hacerlo aquí (por ejemplo, "user_events").
  Future<void> allowNow({
    required String eventPayId,
  }) async {
    // 1) Marcar el pago como "status = true"
    await _eventPayCollection.doc(eventPayId).update({'status': true});

    // 2) (Opcional) Si quieres crear un documento en la colección
    // "user_events" o similar para registrar la entrada, lo harías aquí.
    // Ejemplo ficticio:
    // await FirebaseFirestore.instance
    //     .collection('user_events')
    //     .doc(userId)
    //     .collection('my_events')
    //     .doc(eventPayId)
    //     .set({
    //   'eventId': event.id,
    //   'title': event.title,
    //   'approvedAt': DateTime.now(),
    //   // etc.
    // });
  }

  /// Elimina un registro de `event_pay` por ID.
  /// Útil si el administrador decide rechazarlo o ya no procede.
  Future<void> deleteEventPay(String id) async {
    await _eventPayCollection.doc(id).delete();
  }

  /// Retorna un Stream<List<EventPay>> de todos los documentos
  /// con 'status' == true y 'eventId' == [eventId].
  Stream<List<EventPay>> getApprovedEventPaysByEventId(String eventId) {
    return _eventPayCollection
        .where('status', isEqualTo: true)
        .where('eventId', isEqualTo: eventId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => EventPay.fromJson(doc.data() as Map<String, dynamic>))
            .toList());
  }
}
