import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estilodevida/models/event_pay/event_pay.dart';
import 'package:estilodevida/models/events/event_model.dart';
import 'package:estilodevida/ui/packs/widgets/buy_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EventService {
  final CollectionReference _eventsRef =
      FirebaseFirestore.instance.collection('event_pay');

  Future<void> addManualPay({
    required EventModel event,
    required User user,
    required Method method,
  }) async {
    final docRef = _eventsRef.doc();

    final data = {
      'id': docRef.id,
      'date': Timestamp.fromDate(DateTime.now()),
      'eventName': event.title,
      'eventId': event.id,
      'userName': user.displayName,
      'userId': user.uid,
      'status': false,
      'metodo': method.name,
    };

    final manualPay = EventPay.fromJson(data);

    return await docRef.set(manualPay.toJson());
  }

  Stream<List<EventPay>> getUserEvents() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Stream.empty();
    }

    return _eventsRef
        .where('userId', isEqualTo: user.uid)
        .where('status', isEqualTo: true)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return EventPay.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}
