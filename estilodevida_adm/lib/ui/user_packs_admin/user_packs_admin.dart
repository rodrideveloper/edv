import 'package:estilodevida_adm/model/pack/pack_model.dart';
import 'package:estilodevida_adm/model/user_pack/user_pack.dart';
import 'package:estilodevida_adm/service/http_service.dart';
import 'package:estilodevida_adm/service/pack_service.dart';
import 'package:estilodevida_adm/service/user_packs_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Definición de colores
const purple = Color(0xFF81327D);
const blue = Color(0xFF3155A1);
const red = Colors.red;
const grey = Colors.grey;

const baseUrl = 'https://estilodevidamdp.com.ar';
const createPreferenceEndPoint = '/create_preference';
const registerLessonEndPoint = '/registerLesson';

class UserPackAdminScreen extends StatefulWidget {
  final String userId;
  final String userName;
  final String userPhoto;

  const UserPackAdminScreen({
    super.key,
    required this.userId,
    required this.userName,
    required this.userPhoto,
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
        title: Text('Packs de ${widget.userName}'),
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
                                switch (value) {
                                  case 'edit':
                                    _editUserPack(userPack);
                                    break;
                                  case 'delete':
                                    _deleteUserPack(userPack.id);
                                    break;
                                  case 'register':
                                    _registerLesson(userPack);
                                    break;
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                    value: 'edit', child: Text('Editar')),
                                const PopupMenuItem(
                                    value: 'delete', child: Text('Borrar')),
                                const PopupMenuItem(
                                    value: 'register',
                                    child: Text('Registrar Clase')),
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
    final packsStream = PackService().getAllPacks();

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
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: _buildDialogContent(
              ctx, dueDateController, usedLessonsController, userPack),
        );
      },
    );
  }

  Widget _buildDialogContent(
      BuildContext ctx,
      TextEditingController dueDateController,
      TextEditingController usedLessonsController,
      UserPackModel userPack) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Título del Dialog
          const Text(
            'Editar Pack',
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w600,
              color: purple,
            ),
          ),
          const SizedBox(height: 20.0),
          // Campo de Fecha de Vencimiento
          TextField(
            controller: dueDateController,
            decoration: InputDecoration(
              labelText: 'Fecha de Vencimiento (YYYY-MM-DD)',
              labelStyle: const TextStyle(color: purple),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: blue),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: purple),
              ),
            ),
            keyboardType: TextInputType.datetime,
          ),
          const SizedBox(height: 15.0),
          // Campo de Lecciones Usadas
          TextField(
            controller: usedLessonsController,
            decoration: InputDecoration(
              labelText: 'Lecciones Usadas',
              labelStyle: const TextStyle(color: purple),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: blue),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: purple),
              ),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 25.0),
          // Botones de Acción
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Botón Cancelar
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: blue, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 10),
              // Botón Guardar
              ElevatedButton(
                onPressed: () async {
                  final parsedDate =
                      DateTime.tryParse(dueDateController.text.trim());
                  final parsedUsed =
                      int.tryParse(usedLessonsController.text.trim());

                  if (parsedDate == null || parsedUsed == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Datos inválidos.'),
                        backgroundColor: Colors.red,
                      ),
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
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Guardar',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
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

  Future<void> _registerLesson(UserPackModel userPack) async {
    try {
      String? selectedLesson = await _showSingleSelectionDialog();

      await HttpService(baseUrl: baseUrl).post(registerLessonEndPoint, {
        'userId': widget.userId,
        'userName': userPack.userName,
        'userPhoto': widget.userPhoto,
        'lesson': selectedLesson,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Clase registrada correctamente',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Error al registrar la clase',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<String?> _showSingleSelectionDialog() async {
    return showDialog<String>(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          LessonsAvaliblesEnum? selectedLesson;
          String? errorMessage;

          return StatefulBuilder(builder: (context, setDialogState) {
            void validateSelectionAndContinue() {
              if (selectedLesson == null) {
                setDialogState(() {
                  errorMessage = 'Selecciona una clase antes de continuar.';
                });
                return;
              }
              Navigator.of(context).pop(selectedLesson?.name ?? 'N/N');
            }

            return AlertDialog(
              scrollable: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Colors.white, width: 0),
              ),
              title: const Text(
                'Seleccionar clase',
                textAlign: TextAlign.center,
              ),
              insetPadding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              actionsAlignment: MainAxisAlignment.spaceEvenly,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // SegmentedButton en vertical y rectangular
                  SegmentedButton<LessonsAvaliblesEnum>(
                    // Disposición vertical
                    direction: Axis.vertical,

                    // Tus opciones
                    segments: const [
                      ButtonSegment(
                        value: LessonsAvaliblesEnum.salsa1,
                        label: Text('Salsa on 1'),
                      ),
                      ButtonSegment(
                        value: LessonsAvaliblesEnum.salsa2,
                        label: Text('Salsa on 2'),
                      ),
                      ButtonSegment(
                        value: LessonsAvaliblesEnum.bachata,
                        label: Text('Bachata'),
                      ),
                    ],

                    // Permitir empezar sin selección
                    // (si prefieres que nunca puedan deseleccionar todo, pon 'false')
                    emptySelectionAllowed: true,

                    // Configura el estilo para quitar esquinas redondeadas, etc.
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      ),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),

                    // Si no hay nada seleccionado => set vacío, de lo contrario set con la selección actual
                    selected: selectedLesson == null
                        ? <LessonsAvaliblesEnum>{}
                        : <LessonsAvaliblesEnum>{selectedLesson!},
                    onSelectionChanged:
                        (Set<LessonsAvaliblesEnum> newSelection) {
                      setDialogState(() {
                        if (newSelection.isEmpty) {
                          selectedLesson = null;
                        } else {
                          selectedLesson = newSelection.first;
                        }
                        // Limpiamos el mensaje de error cuando seleccionan algo
                        errorMessage = null;
                      });
                    },
                    multiSelectionEnabled: false,
                  ),

                  const SizedBox(height: 12),

                  // Mostrar mensaje de error si hace falta
                  if (errorMessage != null)
                    Text(
                      errorMessage!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
              actions: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.close, color: Colors.white),
                  label: const Text(
                    'Cancelar',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.check, color: Colors.white),
                  label: const Text(
                    'Continuar',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: validateSelectionAndContinue,
                ),
              ],
            );
          });
        });
  }
}

enum LessonsAvaliblesEnum { salsa1, salsa2, bachata }
