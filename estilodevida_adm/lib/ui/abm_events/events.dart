// file: lib/ui/event_admin_screen.dart

import 'package:estilodevida_adm/model/events/event_model.dart';
import 'package:estilodevida_adm/service/event_service.dart';
import 'package:flutter/material.dart';

import '../utils.dart';

class EventAdminScreen extends StatefulWidget {
  const EventAdminScreen({super.key});

  @override
  State<EventAdminScreen> createState() => _EventAdminScreenState();
}

class _EventAdminScreenState extends State<EventAdminScreen> {
  final EventService _eventService = EventService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrar Eventos'),
        backgroundColor: purple, // asumiendo que 'purple' viene de utils.dart
      ),
      body: StreamBuilder<List<EventModel>>(
        stream: _eventService.getAllEvents(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Ocurrió un error al cargar los eventos.',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            );
          }

          final events = snapshot.data!;
          if (events.isEmpty) {
            return const Center(
              child: Text(
                'No hay eventos disponibles. ¡Crea uno nuevo!',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            );
          }

          events.sort((a, b) => a.title.compareTo(b.title));

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
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
                            event.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: purple,
                            ),
                          ),
                          PopupMenuButton<String>(
                            icon:
                                const Icon(Icons.more_vert, color: Colors.blue),
                            onSelected: (value) {
                              if (value == 'edit') {
                                _showEventDialog(editEvent: event);
                              } else if (value == 'delete') {
                                _deleteEvent(event);
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
                      // Subtítulo del evento
                      Row(
                        children: [
                          const Icon(Icons.description,
                              color: Colors.blue, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              event.subTitle,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Precio del evento
                      Row(
                        children: [
                          const Icon(Icons.attach_money,
                              color: Colors.blue, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Precio: \$${event.price.toStringAsFixed(2)}',
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
        onPressed: () => _showEventDialog(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  /// Muestra un [AlertDialog] para Crear o Editar un Evento.
  /// [editEvent] indica si estamos en modo edición.
  void _showEventDialog({EventModel? editEvent}) {
    final isEditMode = editEvent != null;

    // Controladores para los campos de texto
    final titleController = TextEditingController(
      text: isEditMode ? editEvent!.title : '',
    );
    final subTitleController = TextEditingController(
      text: isEditMode ? editEvent!.subTitle : '',
    );
    final priceController = TextEditingController(
      text: isEditMode ? editEvent!.price.toString() : '',
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
            isEditMode ? 'Editar Evento' : 'Nuevo Evento',
            style: const TextStyle(
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
                      labelText: 'Título del Evento',
                      hintText: 'Ej. "Concierto de Rock"',
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Campo: Subtítulo
                  TextField(
                    controller: subTitleController,
                    decoration: const InputDecoration(
                      labelText: 'Subtítulo / Descripción',
                      hintText: 'Ej. "Banda XYZ en vivo"',
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Campo: Precio
                  TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Precio (\$)',
                      hintText: 'Ej. 50.0',
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: purple),
              onPressed: () async {
                final title = titleController.text.trim();
                final subTitle = subTitleController.text.trim();
                final price =
                    double.tryParse(priceController.text.trim()) ?? 0.0;

                if (title.isEmpty || subTitle.isEmpty || price <= 0.0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Por favor, completa todos los campos correctamente.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                final newEvent = EventModel(
                  id: isEditMode ? editEvent!.id : '',
                  title: title,
                  subTitle: subTitle,
                  price: price,
                );

                if (isEditMode) {
                  await _updateEvent(editEvent!.id, newEvent);
                } else {
                  await _addEvent(newEvent);
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

  /// Agregar un nuevo evento en Firestore a través del servicio
  Future<void> _addEvent(EventModel newEvent) async {
    try {
      await _eventService.addEvent(newEvent);
      // Mostrar un SnackBar para confirmar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Evento creado exitosamente.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al crear el evento: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Actualizar un evento existente
  Future<void> _updateEvent(String id, EventModel updatedEvent) async {
    try {
      await _eventService.updateEvent(id, updatedEvent);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Evento actualizado exitosamente.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al actualizar el evento: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _deleteEvent(EventModel event) {
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
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.redAccent,
                  size: 60,
                ),
                const SizedBox(height: 20),
                // Título
                const Text(
                  'Eliminar Evento',
                  style: TextStyle(
                    color: purple,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                // Contenido
                const Text(
                  '¿Estás seguro de que deseas eliminar este evento? '
                  'Esta acción no se puede deshacer.',
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
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                          color: Colors.blue,
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
                        Navigator.of(ctx).pop(); // Cierra el diálogo
                        try {
                          await _eventService.deleteEvent(event.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Evento eliminado exitosamente.'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error al eliminar el evento: $e'),
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
