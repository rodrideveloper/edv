import 'package:estilodevida_adm/model/events/event_model.dart';
import 'package:estilodevida_adm/service/event_manual_pay_service.dart';
import 'package:estilodevida_adm/ui/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:estilodevida_adm/model/event_pay/event_pay.dart';
import 'package:estilodevida_adm/service/event_service.dart';

class EventUsersScreen extends StatefulWidget {
  const EventUsersScreen({super.key});

  @override
  State<EventUsersScreen> createState() => _EventUsersScreenState();
}

class _EventUsersScreenState extends State<EventUsersScreen> {
  final _eventService = EventService();
  final _eventPayService = EventPayService();

  // Lista de eventos obtenidos del Stream.
  List<EventModel> _events = [];

  // En lugar de EventModel, guardamos el *id* del evento seleccionado.
  String? _selectedEventId;

  // Controlador y texto de búsqueda
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios por Evento'),
      ),
      body: Column(
        children: [
          // StreamBuilder para mostrar todos los eventos en un Dropdown
          StreamBuilder<List<EventModel>>(
            stream: _eventService.getAllEvents(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error al cargar eventos: ${snapshot.error}');
              }
              if (!snapshot.hasData) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                );
              }

              _events = snapshot.data!;
              if (_events.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No hay eventos disponibles.'),
                );
              }

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text('Selecciona un evento'),
                  value: _selectedEventId,
                  items: _events.map((event) {
                    return DropdownMenuItem<String>(
                      value: event.id, // <-- Usar ID como value
                      child: Text(event.title),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedEventId = newValue;
                      _searchQuery = ''; // Reseteamos la búsqueda
                      _searchController.text = '';
                    });
                  },
                ),
              );
            },
          ),

          // Barra de búsqueda, sólo visible si ya se seleccionó un evento
          if (_selectedEventId != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Buscar usuario...',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),

          // Si no se ha seleccionado evento, mostramos un mensaje
          if (_selectedEventId == null)
            const Expanded(
              child: Center(
                child: Text('Selecciona un evento para ver los usuarios.'),
              ),
            )
          else
            // StreamBuilder para usuarios que compraron entradas de _selectedEventId
            Expanded(
              child: StreamBuilder<List<EventPay>>(
                stream: _eventPayService
                    .getApprovedEventPaysByEventId(_selectedEventId!),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                          'Error al cargar las entradas: ${snapshot.error}'),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Obtenemos la lista completa de entradas aprobadas
                  final eventPays = snapshot.data!;

                  // Filtramos la lista según el _searchQuery
                  final filteredPays = eventPays.where((pay) {
                    final name = pay.userName.toLowerCase();
                    final query = _searchQuery.toLowerCase();
                    return name.contains(query);
                  }).toList();

                  if (filteredPays.isEmpty) {
                    return const Center(
                      child: Text('No hay usuarios con entradas aprobadas.'),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredPays.length,
                    itemBuilder: (context, index) {
                      final pay = filteredPays[index];
                      return EventPayTile(
                        eventPay: pay,
                        index: index,
                      );
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class EventPayTile extends StatelessWidget {
  final EventPay eventPay;
  final int index;

  const EventPayTile({
    super.key,
    required this.eventPay,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('yyyy-MM-dd');
    final timeFormatter = DateFormat('HH:mm');

    final Color cardColor = index.isEven
        ? const Color(0xFFFFFFFF) // Blanco
        : const Color(0xFFF8F8F8); // Gris claro

    return Card(
      color: cardColor,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: const BorderSide(color: Color(0xFFDDDDDD)),
      ),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey.shade400,
          child: const Icon(
            Icons.person,
            color: Colors.white,
          ),
        ),
        title: Text(
          eventPay.userName.isNotEmpty ? eventPay.userName : 'Sin nombre',
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Row(
          children: [
            Text(dateFormatter.format(eventPay.date)),
            const Text(' - '),
            Text(timeFormatter.format(eventPay.date)),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () async {
            // Mostramos el diálogo de confirmación
            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Confirmar eliminación'),
                  content: const Text(
                      '¿Está seguro de que desea eliminar este registro?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Eliminar'),
                    ),
                  ],
                );
              },
            );

            // Si el usuario confirma, eliminamos
            if (confirm == true) {
              await EventPayService().deleteEventPay(eventPay.id);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: purple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: const Text(
            'Eliminar',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
