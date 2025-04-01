import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estilodevida/error_handler.dart';
import 'package:estilodevida/models/user/user_model.dart';
import 'package:estilodevida/services/auth_service/auth_service.dart';
import 'package:rxdart/rxdart.dart';

class UserService {
  final CollectionReference<UserModel> usersCollection =
      FirebaseFirestore.instance.collection('users').withConverter<UserModel>(
            fromFirestore: (snapshot, _) =>
                UserModel.fromJson(snapshot.data()!),
            toFirestore: (value, options) => value.toJson(),
          );

  Stream<UserModel?> get user {
    return AuthService().authStateChanges().switchMap((user) {
      if (user != null) {
        try {
          return usersCollection.doc(user.uid).snapshots().map((doc) {
            final UserModel userModel = doc.data()!;

            return userModel;
          });
        } catch (err, stack) {
          errorHandler(
              err: err,
              stack: stack,
              reason: 'get user',
              information: [user.toString()]);
          return Stream.value(null);
        }
      } else {
        return Stream.value(null);
      }
    });
  }

  Future<void> saveUser({
    String? name,
    String? email,
    String? phone,
    required String id,
  }) async =>
      await FirebaseFirestore.instance.collection('users').doc(id).set({
        'email': email,
        'name': name,
        'phone': phone,
      }, SetOptions(merge: true));
}
