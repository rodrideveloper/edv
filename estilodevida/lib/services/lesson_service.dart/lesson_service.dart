import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estilodevida/models/lessons/lessons.dart';

class LessonService {
  CollectionReference _lessonsCollection(
    String userId,
  ) =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('lessons')
          .withConverter<LessonsModel>(
            fromFirestore: (snapshot, _) {
              return LessonsModel.fromJson(snapshot.data()!);
            },
            toFirestore: (model, _) => model.toJson(),
          );

  DocumentReference _lessonsDoc(
    String userId,
  ) =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('lessons')
          .doc('summary');

  Stream<List<LessonsModel>> getLessons(
    String userId,
  ) =>
      _lessonsCollection(userId).snapshots().map(
            (snap) => snap.docs
                .map((doc) => doc.data())
                .whereType<LessonsModel>()
                .toList(),
          );

  Future<void> registerLesson(String userId) async {
    final docRef = _lessonsDoc(userId);

    await docRef.update({
      'amount': FieldValue.increment(-1),
    });
  }
}
