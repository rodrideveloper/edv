import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estilodevida_adm/model/user_pack/user_pack.dart';
import 'package:flutter/material.dart';

class UserPackService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método existente para obtener paquetes
  Stream<List<UserPackModel>> getUserPacksStream(String userId) {
    final packsRef = _firestore
        .collection('register_lessons')
        .doc(userId)
        .collection('packs');

    return packsRef.snapshots().map((snapshot) {
      List<UserPackModel> packs = snapshot.docs.map((doc) {
        final data = doc.data();

        // Agregar el 'id' al mapa de datos
        data['id'] = doc.id;

        return UserPackModel.fromJson(data);
      }).toList();

      return sortPacks(packs);
    });
  }

  // Método para ordenar los paquetes
  List<UserPackModel> sortPacks(List<UserPackModel> packs) {
    packs.sort((a, b) {
      if (a.isActive && !b.isActive) return -1;
      if (!a.isActive && b.isActive) return 1;
      return a.dueDate.compareTo(b.dueDate);
    });
    return packs;
  }

  // Método existente para obtener total de lecciones disponibles
  Stream<int> getTotalAvailableLessonsStream(String userId) {
    final packsRef =
        _firestore.collection('users').doc(userId).collection('packs');

    return packsRef.snapshots().map((snapshot) {
      int totalAvailableLessons = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data();
        data['id'] = doc.id;
        final pack = UserPackModel.fromJson(data);

        if (pack.isActive) {
          int usedLessons = pack.usedLessons ?? 0;
          totalAvailableLessons += pack.totalLessons - usedLessons;
        }
      }

      return totalAvailableLessons;
    });
  }

  // **Nuevo: Método para crear un paquete de usuario**
  Future<void> createUserPack(String userId, UserPackModel pack) async {
    final packsRef =
        _firestore.collection('users').doc(userId).collection('packs');

    await packsRef.add(pack.toJson());
  }

  // **Nuevo: Método para actualizar un paquete de usuario**
  Future<void> updateUserPack(String userId, UserPackModel pack) async {
    final packRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('packs')
        .doc(pack.id);

    await packRef.update(pack.toJson());
  }

  // **Nuevo: Método para eliminar un paquete de usuario**
  Future<void> deleteUserPack(String userId, String packId) async {
    final packRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('packs')
        .doc(packId);

    await packRef.delete();
  }
}
