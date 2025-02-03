import 'package:estilodevida/error_handler.dart';
import 'package:estilodevida/services/http_service/http_service.dart';
import 'package:estilodevida/ui/constants.dart';
import 'package:estilodevida/ui/lessons_avalibles.dart';
import 'package:estilodevida/ui/register_lesson/qr_scanner.dart';
import 'package:estilodevida/ui/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RegisterLessons extends StatefulWidget {
  const RegisterLessons({super.key, required this.lessson});

  final LessonsAvaliblesEnum lessson;

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
      GoRouter.of(context).pop();
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
        'lesson': widget.lessson.name,
      });

      if (mounted) {
        GoRouter.of(context).pop();
        GoRouter.of(context).push('/check-animation');
      }

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      showMessage();
    } catch (err, stack) {
      errorHandler(
        err: err,
        stack: stack,
        reason: '',
        information: [response.toString()],
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
