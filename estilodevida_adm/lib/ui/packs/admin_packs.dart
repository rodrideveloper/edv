import 'package:estilodevida_adm/service/user_pack_service.dart';
import 'package:estilodevida_adm/ui/packs/user_pack_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserPackAdminPage extends StatelessWidget {
  final String userId;

  const UserPackAdminPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserPackService>(
      create: (_) => UserPackService(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Administración de Paquetes'),
        ),
        body: UserPackList(userId: userId),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     showDialog(
        //       context: context,
        //       builder: (_) => UserPackDialog(
        //         userId: userId,
        //         onSave: (pack) async {
        //           await Provider.of<UserPackService>(context, listen: false)
        //               .createUserPack(userId, pack);
        //         },
        //       ),
        //     );
        //   },
        //   child: const Icon(Icons.add),
        //   tooltip: 'Agregar Paquete',
        // ),
      ),
    );
  }
}
