// import 'package:estilodevida_adm/model/user_pack/user_pack.dart';
// import 'package:estilodevida_adm/service/user_pack_service.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class UserPackList extends StatelessWidget {
//   final String userId;

//   const UserPackList({super.key, required this.userId});

//   @override
//   Widget build(BuildContext context) {
//     final service = Provider.of<UserPackService>(context, listen: false);

//     return StreamBuilder<List<UserPackModel>>(
//       stream: service.getUserPacksStream(userId),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return const Center(child: Text('Error al cargar paquetes'));
//         }
//         if (!snapshot.hasData) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         final packs = snapshot.data!;

//         return ListView.builder(
//           itemCount: packs.length,
//           itemBuilder: (context, index) {
//             final pack = packs[index];
//             return ListTile(
//               title: Text('Paquete: ${pack.userName}'),
//               subtitle: Text(
//                   'Comprado: ${pack.buyDate.toLocal()} - Vence: ${pack.dueDate.toLocal()}'),
//               trailing: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // IconButton(
//                   //   icon: const Icon(Icons.edit),

//                   //   onPressed: () {
//                   //     showDialog(
//                   //       context: context,
//                   //       builder: (_) => UserPackDialog(
//                   //         userId: userId,
//                   //         existingPack: pack,
//                   //         onSave: (updatedPack) async {
//                   //           await service.updateUserPack(userId, updatedPack);
//                   //         },
//                   //       ),
//                   //     );
//                   //   },
//                   // ),
//                   IconButton(
//                     icon: const Icon(Icons.delete),
//                     onPressed: () async {
//                       bool confirm = await showDialog(
//                         context: context,
//                         builder: (_) => AlertDialog(
//                           title: const Text('Confirmar Eliminación'),
//                           content: const Text(
//                               '¿Estás seguro de que deseas eliminar este paquete?'),
//                           actions: [
//                             TextButton(
//                               onPressed: () => Navigator.pop(context, false),
//                               child: const Text('Cancelar'),
//                             ),
//                             TextButton(
//                               onPressed: () => Navigator.pop(context, true),
//                               child: const Text('Eliminar'),
//                             ),
//                           ],
//                         ),
//                       );
//                       if (confirm) {
//                         await service.deleteUserPack(userId, pack.id);
//                       }
//                     },
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
