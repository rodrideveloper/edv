// // file: lib/ui/user_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estilodevida_adm/model/user/user_model.dart';
import 'package:estilodevida_adm/service/user_service.dart';
import 'package:estilodevida_adm/ui/user_packs_admin/user_packs_admin.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Importar el paquete
import 'package:intl/intl.dart'; // Para formatear fechas

// Definición de colores elegantes
const Color accentColor = Color(0xFFFF4081); // Pink Accent
const Color backgroundColor = Color(0xFFF5F5F5); // Light Grey Background
const Color cardColor = Colors.white;
const Color textColor = Colors.black87;
const Color subtitleColor = Colors.black54;
const Color purple = Color(0xFF81327D); // Define 'purple' para el AppBar

class UserSelectionScreen extends StatefulWidget {
  const UserSelectionScreen({super.key});

  @override
  State<UserSelectionScreen> createState() => _UserSelectionScreenState();
}

class _UserSelectionScreenState extends State<UserSelectionScreen> {
  final UserService _userService = UserService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Construir el campo de búsqueda en la AppBar
  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Buscar Usuarios...',
        border: InputBorder.none,
        hintStyle: const TextStyle(color: Colors.white54),
        prefixIcon: const Icon(Icons.search, color: Colors.white),
        suffixIcon: _searchQuery.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, color: Colors.white),
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _searchQuery = '';
                  });
                },
              )
            : null,
      ),
      style: const TextStyle(color: Colors.white, fontSize: 16.0),
      cursorColor: Colors.white, // Establecer el color del cursor a blanco
      cursorWidth: 3.0, // Incrementar el grosor del cursor
      onChanged: (query) {
        setState(() {
          _searchQuery = query;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor, // Fondo general de la pantalla
      appBar: AppBar(
        title: _buildSearchField(),
        backgroundColor: purple, // Color elegante para el AppBar
        elevation: 0, // Sin sombra para un look más limpio
      ),
      body: StreamBuilder<List<UserModel>>(
        stream: _userService.getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
                child: Text(
              'Error al cargar los usuarios',
              style: TextStyle(color: textColor, fontSize: 16),
            ));
          }
          if (!snapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator(
              color: purple,
            ));
          }

          List<UserModel> userList = snapshot.data!;

          if (userList.isEmpty) {
            return const Center(
                child: Text(
              'No hay usuarios registrados',
              style: TextStyle(color: textColor, fontSize: 16),
            ));
          }

          // Filtrar usuarios según la consulta de búsqueda
          if (_searchQuery.isNotEmpty) {
            userList = userList.where((user) {
              final nameLower = user.name.toLowerCase();
              final emailLower = user.email.toLowerCase();
              final queryLower = _searchQuery.toLowerCase();

              return nameLower.contains(queryLower) ||
                  emailLower.contains(queryLower);
            }).toList();
          }

          if (userList.isEmpty) {
            return const Center(
                child: Text(
              'No se encontraron usuarios.',
              style: TextStyle(color: textColor, fontSize: 16),
            ));
          }

          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                final user = userList[index];

                return Card(
                  color: cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      // Navegamos a la pantalla de ABM de packs, pasando userId y userName
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserPackAdminScreen(
                            userId: user.id,
                            userName: user.name,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          // Avatar del usuario con sombra y caché
                          Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey[200],
                              backgroundImage: user.photoURL.isNotEmpty
                                  ? CachedNetworkImageProvider(user.photoURL)
                                  : null,
                              child: user.photoURL.isEmpty
                                  ? const Icon(
                                      Icons.person,
                                      color: Colors.grey,
                                      size: 30,
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Información del usuario
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name,
                                  style: const TextStyle(
                                    color: textColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  user.email,
                                  style: const TextStyle(
                                    color: subtitleColor,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Ícono de navegación
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: blue,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
