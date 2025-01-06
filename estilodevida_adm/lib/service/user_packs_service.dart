import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart'; // Opcional, por si se requiere agrupar
import 'package:estilodevida_adm/model/pack/pack_model.dart';
import 'package:estilodevida_adm/model/user_pack/user_pack.dart';

class UserPackService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Obtiene la lista de todos los [PackModel] de la colección "packs"
  Stream<List<PackModel>> getAllPacks() {
    return _db.collection('packs').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return PackModel.fromJson(doc.data());
      }).toList();
    });
  }

  /// Obtiene la lista de [UserPackModel] para un usuario de la colección "users/{userId}/packs"
  Stream<List<UserPackModel>> getUserPacks(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('packs')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return UserPackModel.fromJson({
          ...data,
          'id': doc.id, // Asignar doc.id como "id"
        });
      }).toList();
    });
  }

  /// Agrega un [UserPackModel] basado en un [PackModel] seleccionado
  Future<void> addUserPack({
    required String userId,
    required PackModel pack,
    required String? userName,
  }) async {
    // Crear la instancia de [UserPackModel] con los datos necesarios
    final newDoc =
        _db.collection('users').doc(userId).collection('packs').doc();
    final userPack = UserPackModel(
      id: newDoc.id, // Generamos el id del doc
      userName: userName,
      packId: pack.title, // o algún identificador único de pack (si existiera)
      buyDate: DateTime.now(),
      dueDate: DateTime.now().add(Duration(days: pack.dueDays)),
      totalLessons: pack.lessons,
      usedLessons: 0,
    );

    // Almacenar en Firestore
    return newDoc.set(userPack.toJson());
  }

  /// Actualiza un [UserPackModel] en "users/{userId}/packs"
  Future<void> updateUserPack({
    required String userId,
    required UserPackModel userPack,
  }) async {
    final docRef = _db
        .collection('users')
        .doc(userId)
        .collection('packs')
        .doc(userPack.id);

    await docRef.update(userPack.toJson());
  }

  /// Elimina un [UserPackModel] de "users/{userId}/packs"
  Future<void> deleteUserPack({
    required String userId,
    required String packDocId,
  }) async {
    final docRef =
        _db.collection('users').doc(userId).collection('packs').doc(packDocId);

    await docRef.delete();
  }
}
