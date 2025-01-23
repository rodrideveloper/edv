import 'package:estilodevida_adm/model/event_pay/event_pay.dart';
import 'package:estilodevida_adm/service/event_manual_pay_service.dart';
import 'package:estilodevida_adm/ui/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventPayAdminScreen extends StatefulWidget {
  const EventPayAdminScreen({super.key});

  @override
  State<EventPayAdminScreen> createState() => _EventPayAdminScreenState();
}

class _EventPayAdminScreenState extends State<EventPayAdminScreen> {
  final EventPayService _eventPayService = EventPayService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entradas de Eventos Pendientes'),
        // backgroundColor: purple, // si manejas tu color principal
      ),
      body: StreamBuilder<List<EventPay>>(
        stream: _eventPayService.getPendingEventPays(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final pendingList = snapshot.data!;
          if (pendingList.isEmpty) {
            return const Center(
              child: Text(
                'No hay entradas pendientes de aprobación.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            );
          }

          return ListView.builder(
            itemCount: pendingList.length,
            itemBuilder: (context, index) {
              final eventPay = pendingList[index];
              // Formatear fecha usando intl
              final dateFormatted =
                  DateFormat('dd/MM/yyyy HH:mm').format(eventPay.date);

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // Ajusta el color del borde y sombra a tu gusto
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    title: Text(
                      eventPay.eventName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          'Usuario: ${eventPay.userName}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          'Fecha Solicitud: $dateFormatted',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Botón para aprobar (setear status=true)
                        ElevatedButton(
                          onPressed: () => _approveEventPay(eventPay),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                          child: const Icon(
                            Icons.check_circle,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Botón para eliminar (rechazar)
                        ElevatedButton(
                          onPressed: () =>
                              _eventPayService.deleteEventPay(eventPay.id),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: purple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// Aprueba la entrada (pone status=true). Puedes añadir lógica extra si lo deseas.
  Future<void> _approveEventPay(EventPay eventPay) async {
    try {
      // // Si necesitas el EventModel completo, obténlo desde tu EventService.
      // // Aquí un ejemplo genérico (debes implementar getEventById en tu EventService).
      // EventModel? event = await _fetchEventById(eventPay.eventId);

      // if (event == null) {
      //   throw 'No se encontró el evento con ID: ${eventPay.eventId}';
      // }

      await _eventPayService.allowNow(
        eventPayId: eventPay.id,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Entrada de ${eventPay.userName} para "${eventPay.eventName}" aprobada.'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al aprobar la entrada: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  // /// Método auxiliar para obtener el evento por ID (si necesitas datos adicionales).
  // /// Ajusta el servicio según tu implementación real.
  // Future<EventModel?> _fetchEventById(String eventId) async {
  //   // Ejemplo ficticio. Implementa la lógica real en tu EventService.
  //   final eventService = EventService();
  //   // Por ejemplo, si tienes un método getEventById, harías:
  //   return await eventService.getEventById(eventId);
  // }
}
