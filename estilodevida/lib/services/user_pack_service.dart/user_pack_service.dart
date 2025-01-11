import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estilodevida/models/manual_pay/manual_pay.dart';
import 'package:estilodevida/models/user_pack/user_pack.dart';
import 'package:estilodevida/ui/packs/packs.dart';
import 'package:estilodevida/ui/packs/widgets/buy_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserPackService {
  Stream<List<UserPackModel>> getUserPacksStream(
    String userId,
  ) {
    final packsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('packs');

    return packsRef.snapshots().map((snapshot) {
      List<UserPackModel> packs = snapshot.docs.map((doc) {
        final data = doc.data();

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

  Stream<UserPackModel?> getActivePackStream(
    String userId,
  ) {
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

  Future<void> addManualPay(
    PackOption pack,
    User user,
    Method method,
  ) async {
    final docRef = FirebaseFirestore.instance.collection('manual_pay').doc();

    final data = {
      'id': docRef.id,
      'date': Timestamp.fromDate(DateTime.now()),
      'packName': pack.title,
      'packId': pack.id,
      'userName': user.displayName,
      'userId': user.uid,
      'status': false,
      'metodo': method.name,
    };

    final manualPay = ManualPayModel.fromJson(data);

    return await docRef.set(manualPay.toJson());
  }
}
