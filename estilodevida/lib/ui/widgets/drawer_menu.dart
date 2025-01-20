import 'package:estilodevida/services/app_info/app_info.dart';
import 'package:estilodevida/services/auth_service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4F86CD), Color(0xFFAC41BE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: <Widget>[
            DrawerHeader(
              child: Column(
                children: [
                  Expanded(
                    child: Image.asset(
                      color: Colors.white,
                      'assets/images/logo_edv.png',
                      height: 80,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Academia de baile',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.qr_code, color: Colors.white),
              title: Text('Registrar Clase',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: Colors.white)),
              onTap: () => GoRouter.of(context).push('/register'),
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart, color: Colors.white),
              title: Text(
                'Comprar Pack',
                style:
                    theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
              ),
              onTap: () => GoRouter.of(context).push('/buypack'),
            ),
            ListTile(
              leading: const Icon(Icons.list, color: Colors.white),
              title: Text(
                'Mis Packs',
                style:
                    theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
              ),
              onTap: () => GoRouter.of(context).push('/userpacks'),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today, color: Colors.white),
              title: Text('Eventos',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: Colors.white)),
              onTap: () => GoRouter.of(context).push('/events'),
            ),
            const Spacer(),
            ListTile(
              title: Text(AppInfo().getAppVersion(),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: Colors.white)),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.white),
              title: Text('Salir',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: Colors.white)),
              onTap: () {
                AuthService().signOut();
                GoRouter.of(context).go('/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}
