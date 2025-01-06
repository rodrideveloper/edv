// file: lib/ui/pack_admin_screen.dart
import 'package:estilodevida_adm/model/pack/pack_model.dart';
import 'package:estilodevida_adm/service/pack_service.dart';
import 'package:estilodevida_adm/ui/utils.dart';
import 'package:flutter/material.dart';

class PackAdminScreen extends StatefulWidget {
  const PackAdminScreen({super.key});

  @override
  State<PackAdminScreen> createState() => _PackAdminScreenState();
}

class _PackAdminScreenState extends State<PackAdminScreen> {
  final PackService _packService = PackService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrar Packs'),
        backgroundColor: purple,
      ),
      body: StreamBuilder<List<PackModel>>(
        stream: _packService.getAllPacks(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Ocurrió un error al cargar los packs.',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: blue),
            );
          }

          final packs = snapshot.data!;
          if (packs.isEmpty) {
            return const Center(
              child: Text(
                'No hay packs disponibles. ¡Crea uno nuevo!',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            );
          }
          packs.sort((a, b) => b.lessons.compareTo(a.lessons));
          return ListView.builder(
            itemCount: packs.length,
            itemBuilder: (context, index) {
              final pack = packs[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 5,
                shadowColor: purple.withOpacity(0.3),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título y Botón de Opciones
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            pack.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: purple,
                            ),
                          ),
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert, color: blue),
                            onSelected: (value) {
                              if (value == 'edit') {
                                _showPackDialog(editPack: pack);
                              } else if (value == 'delete') {
                                _deletePack(pack);
                              }
                            },
                            itemBuilder: (BuildContext context) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Text('Editar'),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Eliminar'),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Información del Pack
                      Row(
                        children: [
                          Icon(Icons.book, color: blue, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Clases: ${pack.lessons}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, color: blue, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Vence en: ${pack.dueDays} día${pack.dueDays != 1 ? 's' : ''}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.attach_money, color: blue, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Precio unitario: \$${pack.unitPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: purple,
        onPressed: () => _showPackDialog(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  /// Muestra un [AlertDialog] para Crear o Editar un Pack.
  /// [editPack] indica si estamos en modo edición.
  void _showPackDialog({PackModel? editPack}) {
    final isEditMode = editPack != null;

    // Controladores para los campos de texto
    final titleController =
        TextEditingController(text: isEditMode ? editPack.title : '');
    final lessonsController = TextEditingController(
      text: isEditMode ? editPack.lessons.toString() : '',
    );
    final unitPriceController = TextEditingController(
      text: isEditMode ? editPack.unitPrice.toString() : '',
    );
    final dueDaysController = TextEditingController(
      text: isEditMode ? editPack.dueDays.toString() : '',
    );

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            isEditMode ? 'Editar Pack' : 'Nuevo Pack',
            style: TextStyle(
              color: purple,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Campo: Título
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Título del Pack',
                      hintText: 'Ej. "Pack 5 Clases"',
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Campo: Lecciones
                  TextField(
                    controller: lessonsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Número de Clases',
                      hintText: 'Ej. 5',
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Campo: Precio
                  TextField(
                    controller: unitPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Precio (\$)',
                      hintText: 'Ej. 10.0',
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Campo: Días de vencimiento
                  TextField(
                    controller: dueDaysController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Días de Vencimiento',
                      hintText: 'Ej. 30',
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                'Cancelar',
                style: TextStyle(color: blue),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: purple),
              onPressed: () async {
                final title = titleController.text.trim();
                final lessons =
                    int.tryParse(lessonsController.text.trim()) ?? 0;
                final price =
                    double.tryParse(unitPriceController.text.trim()) ?? 0.0;
                final days = int.tryParse(dueDaysController.text.trim()) ?? 0;

                if (title.isEmpty ||
                    lessons <= 0 ||
                    price <= 0.0 ||
                    days <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Por favor, completa todos los campos correctamente.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                final newPack = PackModel(
                  id: isEditMode
                      ? editPack.id
                      : '', // Temporarily empty, handled in service
                  title: title,
                  lessons: lessons,
                  unitPrice: price,
                  dueDays: days,
                );

                if (isEditMode) {
                  await _updatePack(editPack.id, newPack);
                } else {
                  await _addPack(newPack);
                }
                if (mounted) Navigator.of(ctx).pop();
              },
              child: Text(isEditMode ? 'Guardar Cambios' : 'Crear'),
            ),
          ],
        );
      },
    );
  }

  /// Agregar un nuevo pack en Firestore a través del servicio
  Future<void> _addPack(PackModel newPack) async {
    try {
      await _packService.addPack(newPack);
      // Mostrar un SnackBar para confirmar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pack creado exitosamente.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al crear el pack: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Actualizar un pack existente en la colección "packs".
  Future<void> _updatePack(String id, PackModel updatedPack) async {
    try {
      await _packService.updatePack(id, updatedPack);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pack actualizado exitosamente.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al actualizar el pack: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Eliminar un pack de la colección "packs" en Firestore.
  void _deletePack(PackModel pack) {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 16,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Ícono de Advertencia
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.redAccent,
                  size: 60,
                ),
                const SizedBox(height: 20),
                // Título
                Text(
                  'Eliminar Pack',
                  style: TextStyle(
                    color: purple,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                // Contenido
                Text(
                  '¿Estás seguro de que deseas eliminar este pack? Esta acción no se puede deshacer.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),
                // Botones
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Botón Cancelar
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(
                          color: blue,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Botón Eliminar
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: purple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        Navigator.of(ctx)
                            .pop(); // Cierra el diálogo de confirmación
                        try {
                          await _packService.deletePack(pack.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Pack eliminado exitosamente.'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error al eliminar el pack: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'Eliminar',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
