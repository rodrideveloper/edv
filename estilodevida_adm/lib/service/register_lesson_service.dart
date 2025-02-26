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

  Future<void> deleteRegisterLesson(
    String registerLessonId,
  ) async {
    try {
      await _firestore
          .collection('register_lessons')
          .doc(registerLessonId)
          .delete();
    } catch (e) {
      throw Exception(
          'Error al eliminar manual_pay con id $registerLessonId: $e');
    }
  }

  Future<void> addRegisterLesson({
    required int totalLessons,
    required String register,
    required String userName,
    required DateTime date,
    required String packId,
    required String? userPhoto,
  }) async {
    try {
      DocumentReference docRef =
          _firestore.collection('register_lessons').doc();

      RegisterLessonModel registerLessonModel = RegisterLessonModel(
        totalLessons,
        register: register,
        id: docRef.id,
        date: DateTime.now(),
        packId: packId,
        userName: userName,
        userPhoto: null,
      );

      final data = registerLessonModel.toJson();

      await docRef.set(data);
    } catch (e) {
      throw Exception('Error al agregar el registro: $e');
    }
  }
}
