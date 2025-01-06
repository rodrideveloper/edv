import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estilodevida_adm/model/register_lesson/register_lesson_model.dart';

class RegisterLessonService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Obtiene un stream de RegisterLessonModel filtrado por [startDate] y [endDate].
  /// No filtra por [userName] directamente.
  Stream<List<RegisterLessonModel>> getRegisterLessons({
    DateTime? startDate,
    DateTime? endDate,
  }) {
    Query query = _firestore.collection('register_lessons');

    if (startDate != null) {
      // Filtrar por fecha mayor o igual a startDate
      query = query.where('date',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startDate));
    }

    if (endDate != null) {
      // Filtrar por fecha menor o igual a endDate
      query =
          query.where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate));
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        return RegisterLessonModel.fromJson({
          'id': doc.id, // Incluir el ID del documento
          ...data,
        });
      }).toList();
    });
  }
}
