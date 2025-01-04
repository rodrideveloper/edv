// // lib/services/register_lesson_service.dart

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:estilodevida_adm/model/register_lesson/register_lesson_model.dart';

// class RegisterLessonService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   /// Obtiene un stream de RegisterLessonModel filtrado por [userName],
//   /// [startDate] y [endDate]. Todos los parámetros son opcionales.
//   Stream<List<RegisterLessonModel>> getRegisterLessons({
//     String? userName,
//     DateTime? startDate,
//     DateTime? endDate,
//   }) {
//     Query query = _firestore.collection('register_lessons');

//     if (userName != null && userName.isNotEmpty) {
//       // Filtrar por nombre de usuario (suponiendo que el campo es 'userName')
//       query = query.where('userName', isEqualTo: userName);
//     }

//     if (startDate != null) {
//       // Filtrar por fecha mayor o igual a startDate
//       query = query.where('date',
//           isGreaterThanOrEqualTo: Timestamp.fromDate(startDate));
//     }

//     if (endDate != null) {
//       // Filtrar por fecha menor o igual a endDate
//       query =
//           query.where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate));
//     }

//     return query.snapshots().map((snapshot) {
//       return snapshot.docs.map((doc) {
//         final data = doc.data()
//             as Map<String, dynamic>; // Castear a Map<String, dynamic>

//         return RegisterLessonModel.fromJson({
//           'id': doc.id, // Incluir el ID del documento
//           ...data,
//         });
//       }).toList();
//     });
//   }
// }

// lib/services/register_lesson_service.dart

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
