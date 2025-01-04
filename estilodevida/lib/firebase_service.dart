// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:estilodevida/user_model.dart';

// class UserService {
//   // CollectionReference<Usuario> _usuariosCollection() =>
//   //     FirebaseFirestore.instance.collection('usuarios').withConverter<Usuario>(
//   //           fromFirestore: (snapshot, _) {
//   //             return Usuario.fromJson(snapshot.data()!);
//   //           },
//   //           toFirestore: (model, _) => model.toJson(),
//   //         );

//   Stream<Usuario?> obtenerUsuario(String dni) {
//     return FirebaseFirestore.instance
//         .collection('usuarios')
//         .where('nombre', isEqualTo: 'Pau')
//         .withConverter<Usuario>(
//           fromFirestore: (snapshot, _) => Usuario.fromJson(snapshot.data()!),
//           toFirestore: (model, _) => model.toJson(),
//         )
//         .snapshots()
//         .map((snapshot) =>
//             snapshot.docs.isNotEmpty ? snapshot.docs.first.data() : null);
//   }

// // // Get user executions that end or have ended between the last 24 hs and the next 48 hs.
// //   Stream<List<Usuario>> usuariosWithListener({
// //     required String userId,
// //   }) {
// //     return _usuariosCollection().doc(userId).snapshots().map(
// //           (snap) =>
// //               snap.docs.map((doc) => doc.data()).whereType<Usuario>().toList(),
// //         );
// //   }
// }
