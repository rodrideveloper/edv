import 'package:estilodevida_adm/ui/abm_pack/abm_pack.dart';
import 'package:estilodevida_adm/ui/manual_pay/manual_pay.dart';
import 'package:estilodevida_adm/ui/user_selection/user_selection.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Center(
              child: Image.asset('assets/images/logo_edv.png'),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.home,
              color: blue,
            ),
            title: const Text('Inicio'),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.person,
              color: blue,
            ),
            title: const Text('Usuarios'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserSelectionScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.settings,
              color: blue,
            ),
            title: const Text('A/B/M Pack'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PackAdminScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.handshake,
              color: blue,
            ),
            title: const Text('Pagos Manaules'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ManualPayAdminScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
