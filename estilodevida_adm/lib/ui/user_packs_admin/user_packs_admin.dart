import 'package:estilodevida_adm/model/pack/pack_model.dart';
import 'package:estilodevida_adm/model/user_pack/user_pack.dart';
import 'package:estilodevida_adm/service/user_packs_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Definición de colores
const purple = Color(0xFF81327D);
const blue = Color(0xFF3155A1);
const red = Colors.red;
const grey = Colors.grey;

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
        backgroundColor: purple, // Color de la barra de navegación
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

          List<UserPackModel> userPacks = snapshot.data!;

          if (userPacks.isEmpty) {
            return const Center(
                child: Text('Este usuario no tiene packs asignados.'));
          }

          // --- Inicio de la lógica para determinar el pack activo ---
          UserPackModel? activePack;
          final now = DateTime.now();
          final availablePacks = userPacks.where((pack) {
            final isNotExpired = pack.dueDate.isAfter(now);
            final remainingLessons =
                pack.totalLessons - (pack.usedLessons ?? 0);
            final hasAvailableClasses = remainingLessons > 0;
            return isNotExpired && hasAvailableClasses;
          }).toList();

          if (availablePacks.isNotEmpty) {
            availablePacks.sort((a, b) => a.buyDate.compareTo(b.buyDate));
            activePack = availablePacks.first;
          }

          // Ordenar los packs: el activo primero, luego por fecha de vencimiento
          userPacks.sort((a, b) {
            if (a == activePack) return -1;
            if (b == activePack) return 1;
            if (a.dueDate.isAfter(b.dueDate)) return -1;
            if (a.dueDate.isBefore(b.dueDate)) return 1;
            return 0;
          });
          // --- Fin de la lógica para determinar el pack activo ---

          return ListView.builder(
            itemCount: userPacks.length,
            itemBuilder: (context, index) {
              final userPack = userPacks[index];
              final isActive =
                  userPack == activePack; // Determinar si es activo

              // Cálculos para determinar el estado y progreso
              final usedLessons = userPack.usedLessons ?? 0;
              final remainingLessons = userPack.totalLessons - usedLessons;
              final progress = remainingLessons / userPack.totalLessons;
              final isExpired = userPack.dueDate.isBefore(now);
              final isExhausted = remainingLessons <= 0;

              // Determinar el estado del pack
              String? packStatus;
              if (isExpired) {
                packStatus = 'VENCIDO';
              } else if (isExhausted) {
                packStatus = 'AGOTADO';
              } else if (isActive) {
                packStatus = 'ACTIVO';
              } else {
                packStatus = null; // No mostrar etiqueta
              }

              // Colores basados en el estado
              Color cardColor = Colors.white;
              Color textColor = Colors.black;
              Color progressColor =
                  blue; // Por defecto, blue para packs no activos
              Color borderColor = Colors.transparent;

              if (packStatus == 'ACTIVO') {
                progressColor = purple;
                borderColor = purple;
              } else if (packStatus == 'AGOTADO') {
                progressColor = grey;
                textColor = grey;
              } else if (packStatus == 'VENCIDO') {
                progressColor = red;
                textColor = grey;
              }

              return Stack(
                children: [
                  Card(
                    elevation: isActive ? 8 : 4,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                          color: borderColor, width: isActive ? 2 : 0),
                    ),
                    color: cardColor,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        // Acción al tocar la tarjeta
                        String message;

                        if (packStatus == 'AGOTADO') {
                          message = 'Pack Agotado';
                        } else if (packStatus == 'VENCIDO') {
                          message = 'Pack Vencido';
                        } else {
                          final dueDate = userPack.dueDate;
                          final daysLeft = dueDate.difference(now).inDays;

                          message = daysLeft >= 0
                              ? 'Quedan $daysLeft día${daysLeft != 1 ? 's' : ''} para que venza el pack.'
                              : 'El pack ya ha vencido.';
                        }

                        // Mostrar SnackBar
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              message,
                              style: const TextStyle(color: Colors.white),
                            ),
                            backgroundColor: progressColor,
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            // Icono según el estado
                            Container(
                              decoration: BoxDecoration(
                                color: progressColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Icon(
                                isExhausted || isExpired
                                    ? Icons.lock
                                    : isActive
                                        ? Icons.check_circle
                                        : Icons.auto_awesome_mosaic,
                                color: progressColor,
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Información del pack
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pack de ${userPack.totalLessons} clases',
                                    style: TextStyle(
                                      color: textColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: LinearProgressIndicator(
                                      minHeight: 8,
                                      value: progress,
                                      backgroundColor: Colors.grey[300],
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          progressColor),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Clases restantes: $remainingLessons',
                                    style: TextStyle(
                                      color: textColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Vence: ${DateFormat('dd/MM/yyyy').format(userPack.dueDate)}',
                                    style: TextStyle(
                                      color: textColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Menú de opciones
                            PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'edit') {
                                  _editUserPack(userPack);
                                } else if (value == 'delete') {
                                  _deleteUserPack(userPack.id);
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                    value: 'edit', child: Text('Editar')),
                                const PopupMenuItem(
                                    value: 'delete', child: Text('Borrar')),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Etiqueta del estado en la esquina superior derecha
                  if (packStatus != null)
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: progressColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            packStatus,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewPack,
        backgroundColor: purple, // Color del botón flotante
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _addNewPack() async {
    final packsStream = _service.getAllPacks();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white, // Fondo blanco para el diálogo
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Bordes redondeados
          ),
          title: const Text(
            'Seleccionar Pack',
            style: TextStyle(
              color: purple,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: StreamBuilder<List<PackModel>>(
            stream: packsStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text(
                  'Error al cargar los packs.',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                );
              }
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: blue,
                  ),
                );
              }

              final packs = snapshot.data!;
              if (packs.isEmpty) {
                return const Text(
                  'No hay packs disponibles.',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                );
              }

              return SizedBox(
                // Limita la altura del ListView para evitar que el diálogo se corte
                height: MediaQuery.of(context).size.height * 0.5,
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  // Evita el desplazamiento interno del ListView
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: packs.length,
                  itemBuilder: (context, index) {
                    final pack = packs[index];
                    return Card(
                      color: Colors.grey[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          _service.addUserPack(
                            userId: widget.userId,
                            pack: pack,
                            userName: widget.userName,
                          );
                          Navigator.of(ctx).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              // Icono representativo del pack
                              const Icon(
                                Icons.local_offer,
                                color: purple,
                                size: 30,
                              ),
                              const SizedBox(width: 16),
                              // Información del pack
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      pack.title,
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Vence en ${pack.dueDays} día${pack.dueDays != 1 ? 's' : ''} - Precio: \$${pack.unitPrice}',
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
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
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text(
                'Cancelar',
                style: TextStyle(
                  color: blue,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Editar un UserPack existente (fecha de vencimiento y lecciones usadas)
  Future<void> _editUserPack(UserPackModel userPack) async {
    final dueDateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(userPack.dueDate),
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
                keyboardType: TextInputType.datetime,
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
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          title: const Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.redAccent,
                size: 28,
              ),
              SizedBox(width: 10),
              Text(
                'Confirmar eliminación',
                style: TextStyle(
                  color: purple,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: const Text(
            '¿Seguro que deseas eliminar este pack del usuario?',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text(
                'Cancelar',
                style: TextStyle(
                  color: blue,
                  fontSize: 16,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text(
                'Eliminar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
