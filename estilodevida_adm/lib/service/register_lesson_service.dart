import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estilodevida_adm/model/register_lesson/register_lesson_model.dart';

class RegisterLessonService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Retorna la lista de RegisterLessonModel filtrada, con un Future.
  Future<List<RegisterLessonModel>> getRegisterLessonsFuture({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    Query query = _firestore.collection('register_lessons');

    if (startDate != null) {
      query = query.where(
        'date',
        isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
      );
    }

    if (endDate != null) {
      query = query.where(
        'date',
        isLessThanOrEqualTo: Timestamp.fromDate(endDate),
      );
    }

    final snapshot = await query.get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return RegisterLessonModel.fromJson({
        'id': doc.id,
        ...data,
      });
    }).toList();
  }
}
