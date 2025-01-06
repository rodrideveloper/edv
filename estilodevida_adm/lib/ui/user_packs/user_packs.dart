// file: user_pack_admin_screen.dart
import 'package:estilodevida_adm/model/pack/pack_model.dart';
import 'package:estilodevida_adm/model/user_pack/user_pack.dart';
import 'package:estilodevida_adm/service/user_packs_service.dart';
import 'package:flutter/material.dart';

class UserPackAdminScreen extends StatefulWidget {
  final String userId;
  final String? userName;

  const UserPackAdminScreen({
    super.key,
    required this.userId,
    this.userName,
  });

  @override
  State<UserPackAdminScreen> createState() => _UserPackAdminScreenState();
}

class _UserPackAdminScreenState extends State<UserPackAdminScreen> {
  final UserPackService _service = UserPackService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Packs de ${widget.userName ?? 'Usuario'}'),
      ),
      body: StreamBuilder<List<UserPackModel>>(
        stream: _service.getUserPacks(widget.userId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
                child: Text('Ocurrió un error al cargar los packs.'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final userPacks = snapshot.data!;
          if (userPacks.isEmpty) {
            return const Center(
                child: Text('Este usuario no tiene packs asignados.'));
          }

          return ListView.builder(
            itemCount: userPacks.length,
            itemBuilder: (context, index) {
              final userPack = userPacks[index];
              final remaining = userPack.remainingLessons;
              final isActive = userPack.isActive;

              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('Pack: ${userPack.packId}'),
                  subtitle: Text(
                    'Lecciones totales: ${userPack.totalLessons} '
                    '- Restantes: $remaining\n'
                    'Expira: ${userPack.dueDate.toLocal()} '
                    '(${isActive ? "Activo" : "Expirado"})',
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _editUserPack(userPack);
                      } else if (value == 'delete') {
                        _deleteUserPack(userPack.id);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'edit', child: Text('Editar')),
                      const PopupMenuItem(
                          value: 'delete', child: Text('Borrar')),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewPack,
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Mostrar diálogo con la lista de packs globales para añadir uno al usuario
  Future<void> _addNewPack() async {
    final packsStream = _service.getAllPacks();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Seleccionar Pack'),
          content: StreamBuilder<List<PackModel>>(
            stream: packsStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Error al cargar los packs.');
              }
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }

              final packs = snapshot.data!;
              if (packs.isEmpty) {
                return const Text('No hay packs disponibles.');
              }

              return SizedBox(
                width: 300,
                height: 300,
                child: ListView.builder(
                  itemCount: packs.length,
                  itemBuilder: (context, index) {
                    final pack = packs[index];
                    return ListTile(
                      title:
                          Text('${pack.title} - (${pack.lessons} lecciones)'),
                      subtitle: Text(
                          'Vence en ${pack.dueDays} días - Precio: \$${pack.price}'),
                      onTap: () {
                        _service.addUserPack(
                          userId: widget.userId,
                          pack: pack,
                          userName: widget.userName,
                        );
                        Navigator.of(ctx).pop(); // Cerrar el AlertDialog
                      },
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// Editar un UserPack existente (fecha de vencimiento y lecciones usadas)
  Future<void> _editUserPack(UserPackModel userPack) async {
    final dueDateController = TextEditingController(
      text: userPack.dueDate.toLocal().toString().split(' ')[0],
    );
    final usedLessonsController = TextEditingController(
      text: (userPack.usedLessons ?? 0).toString(),
    );

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Editar Pack'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: dueDateController,
                decoration: const InputDecoration(
                  labelText: 'Fecha de Vencimiento (YYYY-MM-DD)',
                ),
              ),
              TextField(
                controller: usedLessonsController,
                decoration:
                    const InputDecoration(labelText: 'Lecciones Usadas'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final parsedDate =
                    DateTime.tryParse(dueDateController.text.trim());
                final parsedUsed =
                    int.tryParse(usedLessonsController.text.trim());

                if (parsedDate == null || parsedUsed == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Datos inválidos.')),
                  );
                  return;
                }

                final updatedPack = UserPackModel(
                  id: userPack.id,
                  userName: userPack.userName,
                  packId: userPack.packId,
                  buyDate: userPack.buyDate,
                  dueDate: parsedDate,
                  totalLessons: userPack.totalLessons,
                  usedLessons: parsedUsed,
                );

                await _service.updateUserPack(
                  userId: widget.userId,
                  userPack: updatedPack,
                );
                if (!mounted) return;
                Navigator.of(ctx).pop();
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  /// Eliminar un UserPack de la subcolección
  Future<void> _deleteUserPack(String docId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content:
              const Text('¿Seguro que deseas eliminar este pack del usuario?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await _service.deleteUserPack(
        userId: widget.userId,
        packDocId: docId,
      );
    }
  }
}
