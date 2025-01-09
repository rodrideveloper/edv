import 'package:estilodevida/error_handler.dart';
import 'package:estilodevida/services/http_service/http_service.dart';
import 'package:estilodevida/ui/constants.dart';
import 'package:estilodevida/ui/register_lesson/qr_scanner.dart';
import 'package:estilodevida/ui/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterLessons extends StatefulWidget {
  const RegisterLessons({super.key});

  @override
  State<RegisterLessons> createState() => _RegisterLessonsState();
}

class _RegisterLessonsState extends State<RegisterLessons> {
  User? user;
  @override
  void didChangeDependencies() {
    user = context.watch<User>();
    super.didChangeDependencies();
  }

  void onToken(String token) async {
    if (user == null) {
      errorHandler(
        err: 'Error User Null',
        stack: StackTrace.current,
        reason:
            'Uario null en funcion onToke al querer llamar a registerLesson(User) ',
        information: [],
      );
    }
    if (token == tokenQR) {
      registerLesson(user!);
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.crisis_alert_outlined,
                color: Colors.white,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                'Código QR no válido',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: purple,
          duration: Duration(seconds: 3),
        ),
      );
      Navigator.pop(context);
    }
  }

  Future<void> registerLesson(User user) async {
    var response;
    try {
      response =
          await HttpService(baseUrl: baseUrl).post(registerLessonEndPoint, {
        'userId': user.uid,
        'userName': user.displayName,
        'userPhoto': user.photoURL,
      });

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.white,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                'Gracias por registrar tu clase',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: blue,
          duration: Duration(seconds: 5),
        ),
      );

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (err, stack) {
      errorHandler(
        err: 'Error al registrar lección',
        stack: stack,
        reason: '',
        information: [response],
      );
    }
  }

  void showMessage() => showCustomSnackBar(context, 'Clase Registrada');

  @override
  Widget build(BuildContext context) {
    return QrScanner(
      onToken: onToken,
      popWidget: true,
      title: 'Buscando QR...',
    );
  }
}
