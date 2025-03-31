// file: user_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estilodevida_adm/model/user/user_model.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Retorna un Stream con la lista de usuarios (docId + userModel)
  Stream<List<UserModel>> getAllUsers() {
    return _db.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        data['id'] = doc.id;
        try {
          return UserModel.fromJson(data);
        } catch (err, stack) {
          print(err);
        }

        return UserModel.fromJson(data);
      }).toList();
    });
  }
}

// Clase interna que asocia docId con UserModel
class UserWithDocId {
  final String docId;
  final UserModel user;
  UserWithDocId(this.docId, this.user);
}
