import 'package:cached_network_image/cached_network_image.dart';
import 'package:estilodevida_adm/model/register_lesson/register_lesson_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegisterLessonTile extends StatelessWidget {
  final RegisterLessonModel lesson;
  final int index;

  const RegisterLessonTile({
    super.key,
    required this.lesson,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
    final DateFormat timeFormatter = DateFormat('HH:mm');
    final photoUrl = lesson.userPhoto;

    // Determinar el color de la tarjeta basado en el índice
    final Color cardColor = index.isEven
        ? const Color(0xFFFFFFFF) // Blanco puro
        : const Color(0xFFF8F8F8); // Gris claro

    return Card(
      color: cardColor, // Asignar el color determinado
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: const BorderSide(color: Color(0xFFDDDDDD)), // Borde gris claro
      ),
      elevation: 2, // Sombra ligera para darle un toque de profundidad
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey,
          child: ClipOval(
            child: (photoUrl != null && photoUrl.isNotEmpty)
                ? CachedNetworkImage(
                    imageUrl: photoUrl,
                    width: 40.0,
                    height: 40.0,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(
                      strokeWidth: 2.0,
                      color: Colors.grey,
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.person_2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(
                    Icons.person_2,
                    color: Colors.grey,
                  ),
          ),
        ),
        title: Text(
          lesson.userName ?? 'N/N',
          style: TextStyle(
            color: index.isEven ? Colors.black : Colors.grey[800],
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          'Fecha: ${dateFormatter.format(lesson.date)}',
          style: TextStyle(
            color: index.isEven ? Colors.black54 : Colors.grey[600],
          ),
        ),
        trailing: Text(
          'Hora\n${timeFormatter.format(lesson.date)}',
          style: TextStyle(
            color: index.isEven ? Colors.black : Colors.grey[800],
            fontWeight: FontWeight.bold,
            fontSize: 14.0,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
