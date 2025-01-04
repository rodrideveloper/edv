// import 'package:cloud_firestore/cloud_firestore.dart';

// class PackService {
//   CollectionReference _lessonsCollection(
//     String userId,
//   ) =>
//       FirebaseFirestore.instance
//           .collection('packs')
//           .doc(userId)
//           .collection('lessons')
//           .withConverter<LessonsModel>(
//             fromFirestore: (snapshot, _) {
//               return LessonsModel.fromJson(snapshot.data()!);
//             },
//             toFirestore: (model, _) => model.toJson(),
//           );
// }
