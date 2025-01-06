// file: pack_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estilodevida_adm/model/pack/pack_model.dart';

class PackService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Obtiene la lista de todos los [PackModel] de la colección "packs"
  Stream<List<PackModel>> getAllPacks() {
    return _db.collection('packs').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        // Incluimos el doc.id en el JSON para obtener la 'id'
        return PackModel.fromJson({
          ...data,
          'id': doc.id,
        });
      }).toList();
    });
  }

  /// Crea un nuevo [PackModel] en la colección "packs"
  Future<void> addPack(PackModel pack) async {
    final docRef = _db.collection('packs').doc();
    // Guardamos los datos en Firestore
    await docRef.set(pack.toJson());
  }

  /// Actualiza un [PackModel] existente en la colección "packs"
  Future<void> updatePack(String id, PackModel pack) async {
    final docRef = _db.collection('packs').doc(id);
    await docRef.update(pack.toJson());
  }

  /// Elimina un [PackModel] de la colección "packs"
  Future<void> deletePack(String id) async {
    final docRef = _db.collection('packs').doc(id);
    await docRef.delete();
  }

  /// Obtiene un solo [PackModel] de la colección "packs" según su [packId].
  /// Retorna [null] si el documento no existe.
  Future<PackModel?> getPackById(String packId) async {
    try {
      final docRef = _db.collection('packs').doc(packId);
      final docSnap = await docRef.get();

      if (!docSnap.exists) {
        return null;
      }

      final data = docSnap.data()!;
      // Construimos el PackModel incluyendo el doc.id
      return PackModel.fromJson({
        ...data,
        'id': docSnap.id,
      });
    } catch (e) {
      // Manejo de errores o logging según tus necesidades
      rethrow;
    }
  }
}
