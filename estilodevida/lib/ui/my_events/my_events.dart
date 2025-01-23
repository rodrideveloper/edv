import 'package:estilodevida/services/event_service/event_service.dart';
import 'package:estilodevida/ui/user_pack/user_pack_card.dart';
import 'package:estilodevida/ui/widgets/common_appbar.dart';
import 'package:estilodevida/ui/widgets/common_container.dart';
import 'package:flutter/material.dart';
import 'package:estilodevida/models/event_pay/event_pay.dart';
import 'package:intl/intl.dart';

class MyEvents extends StatelessWidget {
  const MyEvents({super.key});

  @override
  Widget build(BuildContext context) {
    final eventPayService = EventService();

    return Scaffold(
      appBar: const CommonAppBar(title: 'Mis Eventos'),
      extendBodyBehindAppBar: true,
      body: CommonBackgroundContainer(
        child: StreamBuilder<List<EventPay>>(
          stream: eventPayService.getUserEvents(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Ocurrió un error: ${snapshot.error}'),
              );
            }

            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final eventPays = snapshot.data!;
            if (eventPays.isEmpty) {
              return const Center(
                child: Text('No tienes eventos registrados.',
                    style: TextStyle(color: Colors.white)),
              );
            }

            return ListView.builder(
              itemCount: eventPays.length,
              itemBuilder: (context, index) {
                final eventPay = eventPays[index];

                // Aquí podrías diseñar cada "tarjeta" o "ticket".
                // Más abajo un ejemplo de ticket básico.
                return _TicketItem(eventPay: eventPay);
              },
            );
          },
        ),
      ),
    );
  }
}

class _TicketItem extends StatelessWidget {
  final EventPay eventPay;

  const _TicketItem({Key? key, required this.eventPay}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Parte superior del ticket (header con gradiente)
            _TicketHeader(eventName: eventPay.eventName),

            // Parte central donde está la info
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRowInfo(
                    icon: Icons.credit_card,
                    label: 'Método de pago:',
                    value: eventPay.metodo,
                  ),
                  const SizedBox(height: 8),
                  _buildRowInfo(
                    icon: Icons.calendar_today_outlined,
                    label: 'Registrado el:',
                    value: _formatTimestamp(eventPay.date),
                  ),
                  // Puedes agregar más filas con la info que necesites
                ],
              ),
            ),

            // Línea punteada para simular corte
            CustomPaint(
              painter: _DottedLinePainter(
                dotRadius: 3,
                spacing: 8,
                color: Colors.grey.shade400,
              ),
              child: const SizedBox(width: double.infinity, height: 20),
            ),

            Container(
              color: Colors.grey.shade50,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.verified,
                    color: Colors.green.shade600,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    eventPay.userName,
                    style: const TextStyle(
                      color: blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Muestra el nombre del evento con un gradiente de fondo.
  Widget _TicketHeader({required String eventName}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF5A7BB2), Color(0xFF3E4E68)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Text(
        eventName,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  /// Construye una fila de información con un ícono a la izquierda.
  Widget _buildRowInfo({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.blueGrey),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: '$label ',
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
              children: [
                TextSpan(
                  text: value,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Formatea el Timestamp en formato dd/MM/yyyy
  String _formatTimestamp(DateTime? date) {
    if (date == null) return 'Desconocida';
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }
}

/// CustomPainter para dibujar la línea punteada (separadora) horizontal.
class _DottedLinePainter extends CustomPainter {
  final double dotRadius;
  final double spacing;
  final Color color;

  _DottedLinePainter({
    required this.dotRadius,
    required this.spacing,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final diameter = dotRadius * 2;

    double startX = 0;
    final centerY = size.height / 2;

    // Dibuja círculos uno junto al otro hasta llenar el ancho.
    while (startX < size.width) {
      canvas.drawCircle(Offset(startX + dotRadius, centerY), dotRadius, paint);
      startX += diameter + spacing;
    }
  }

  @override
  bool shouldRepaint(_DottedLinePainter oldDelegate) => false;
}
