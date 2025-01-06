import 'package:estilodevida/models/user_pack/user_pack.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const purple = Color(0xFF81327D);
const blue = Color(0xFF3155A1);

const red = Colors.red; // Puedes definir un rojo personalizado si lo prefieres
const grey = Colors.grey;

class UserPackCard extends StatelessWidget {
  final UserPackModel pack;
  final bool isActivePack;

  const UserPackCard({
    super.key,
    required this.pack,
    required this.isActivePack,
  });

  @override
  Widget build(BuildContext context) {
    final usedLessons = pack.usedLessons ?? 0;
    final remainingLessons = pack.totalLessons - usedLessons;
    final progress = remainingLessons / pack.totalLessons;
    final now = DateTime.now();
    final isExpired = pack.dueDate.isBefore(now);
    final isExhausted = remainingLessons <= 0;

    String? packStatus;
    if (isExpired) {
      packStatus = 'VENCIDO';
    } else if (isExhausted) {
      packStatus = 'AGOTADO';
    } else if (isActivePack) {
      packStatus = 'ACTIVO';
    } else {
      packStatus = null;
    }

    // Colores basados en el estado
    Color cardColor = Colors.white;
    Color textColor = Colors.black;
    Color progressColor = blue; // Por defecto, blue para packs no activos
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
          elevation: isActivePack ? 8 : 4,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: borderColor, width: isActivePack ? 2 : 0),
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
                final dueDate = pack.dueDate;
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
                          : isActivePack
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
                          'Pack de ${pack.totalLessons} clases',
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
                            valueColor:
                                AlwaysStoppedAnimation<Color>(progressColor),
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
                          'Vence: ${DateFormat('dd/MM/yyyy').format(pack.dueDate)}',
                          style: TextStyle(
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
  }
}
