// file: user_selection_screen.dart
import 'package:estilodevida_adm/service/user_service.dart';
import 'package:estilodevida_adm/ui/user_packs/user_packs.dart';
import 'package:flutter/material.dart';

class UserSelectionScreen extends StatefulWidget {
  const UserSelectionScreen({super.key});

  @override
  State<UserSelectionScreen> createState() => _UserSelectionScreenState();
}

class _UserSelectionScreenState extends State<UserSelectionScreen> {
  final UserService _userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Usuario'),
      ),
      body: StreamBuilder<List<UserWithDocId>>(
        stream: _userService.getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar los usuarios'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final userList = snapshot.data!;
          if (userList.isEmpty) {
            return const Center(child: Text('No hay usuarios registrados'));
          }

          return ListView.builder(
            itemCount: userList.length,
            itemBuilder: (context, index) {
              final userDoc = userList[index];
              final docId = userDoc.docId;
              final user = userDoc.user;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.photoURL),
                  ),
                  title: Text(user.name),
                  subtitle: Text(user.email),
                  onTap: () {
                    // Navegamos a la pantalla de ABM de packs, pasando userId y userName
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserPackAdminScreen(
                          userId: docId,
                          userName: user.name,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
