import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estilodevida/models/user_pack/user_pack.dart';

class UserPackService {
  Stream<List<UserPackModel>> getUserPacksStream(String userId) {
    final packsRef = FirebaseFirestore.instance
        .collection('users')
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

  // Nuevo método para obtener solo los packs activos
  Stream<List<UserPackModel>> getActiveUserPacksStream(String userId) {
    return getUserPacksStream(userId).map((packs) {
      return packs.where((pack) => pack.isActive).toList();
    });
  }

  List<UserPackModel> sortPacks(List<UserPackModel> packs) {
    packs.sort((a, b) {
      if (a.isActive && !b.isActive) return -1;
      if (!a.isActive && b.isActive) return 1;
      return a.dueDate.compareTo(b.dueDate);
    });
    return packs;
  }

  Stream<UserPackModel?> getActivePackStream(String userId) {
    return getUserPacksStream(userId).map((packs) {
      UserPackModel? activePack;
      final now = DateTime.now();
      final availablePacks = packs.where((pack) {
        final isNotExpired = pack.dueDate.isAfter(now);
        final remainingLessons = pack.totalLessons - (pack.usedLessons ?? 0);
        final hasAvailableClasses = remainingLessons > 0;
        return isNotExpired && hasAvailableClasses;
      }).toList();

      if (availablePacks.isNotEmpty) {
        // Sort available packs by buy date
        availablePacks.sort((a, b) => a.buyDate.compareTo(b.buyDate));
        activePack = availablePacks.first;
      }

      return activePack;
    });
  }
}
