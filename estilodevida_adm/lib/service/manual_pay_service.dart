// file: lib/services/manual_pay_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estilodevida_adm/model/manual_pay/manual_pay.dart';
import 'package:estilodevida_adm/model/pack/pack_model.dart';
import 'package:estilodevida_adm/model/user_pack/user_pack.dart';

class ManualPayService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Obtiene todos los pagos manuales con status == false, ordenados por fecha descendente
  Stream<List<ManualPayModel>> getPendingManualPays() {
    return _db
        .collection('manual_pay')
        .where('status', isEqualTo: false)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return ManualPayModel(
          id: doc.id,
          date: (data['date'] as Timestamp).toDate(),
          packName: data['packName'] as String,
          packId: data['packId'] as String,
          userName: data['userName'] as String,
          userId: data['userId'] as String,
          status: data['status'] as bool,
          metodo: data['metodo'] as String,
        );
      }).toList();
    });
  }

  Future<void> allowNow({
    required String manualPayId,
    required String userId,
    required String? userName,
    required PackModel pack,
  }) async {
    try {
      final manualPayRef = _db.collection('manual_pay').doc(manualPayId);
      final userPackRef = _db
          .collection('users')
          .doc(userId)
          .collection('packs')
          .doc(); // Genera un nuevo ID para el user pack

      await _db.runTransaction((transaction) async {
        // 1. Actualizar status en manual_pay -> true
        transaction.update(manualPayRef, {'status': true});

        // 2. Crear el UserPackModel con los datos necesarios
        final userPack = UserPackModel(
          id: userPackRef.id, // ID generado para la subcolección
          userName: userName,
          packId: pack.title, // o un identificador único de pack si lo tuvieras
          buyDate: DateTime.now(),
          dueDate: DateTime.now().add(Duration(days: pack.dueDays)),
          totalLessons: pack.lessons,
          usedLessons: 0,
        );

        // 3. Guardar el UserPack en la subcolección dentro de la misma transacción
        transaction.set(userPackRef, userPack.toJson());
      });
    } catch (e) {
      throw Exception('Error en la transacción de allowNow: $e');
    }
  }

  Future<void> deleteManualPay(String manualPayId) async {
    try {
      await _db.collection('manual_pay').doc(manualPayId).delete();
    } catch (e) {
      throw Exception('Error al eliminar manual_pay con id $manualPayId: $e');
    }
  }
}
