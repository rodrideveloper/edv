import 'package:estilodevida/error_handler.dart';
import 'package:estilodevida/services/http_service/http_service.dart';
import 'package:estilodevida/ui/constants.dart';
import 'package:estilodevida/ui/lessons_avalibles.dart';
import 'package:estilodevida/ui/register_lesson/qr_scanner.dart';
import 'package:estilodevida/ui/widgets/register_lesson_animation.dart';
import 'package:estilodevida/ui/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class RegisterLessons extends StatefulWidget {
  const RegisterLessons({super.key, required this.lessson});

  final LessonsAvaliblesEnum lessson;

  @override
  State<RegisterLessons> createState() => _RegisterLessonsState();
}

class _RegisterLessonsState extends State<RegisterLessons>
    with SingleTickerProviderStateMixin {
  User? user;
  OverlayEntry? _overlayEntry;
  late final AnimationController _animationController;
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Inicializamos el controller con el vsync para manejar la animación
    _animationController = AnimationController(vsync: this);
    // Escuchamos el cambio de estado de la animación para remover el overlay cuando termine
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _removeOverlay();
      }
    });
  }

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
    if (token != tokenQR) {
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
      _showOverlay();
      // response =
      //     await HttpService(baseUrl: baseUrl).post(registerLessonEndPoint, {
      //   'userId': user.uid,
      //   'userName': user.displayName,
      //   'userPhoto': user.photoURL,
      //   'lesson': widget.lessson.name,
      // });

      // ScaffoldMessenger.of(context).hideCurrentSnackBar();
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Row(
      //       children: [
      //         Icon(
      //           Icons.check_circle,
      //           color: Colors.white,
      //         ),
      //         SizedBox(
      //           width: 5,
      //         ),
      //         Text(
      //           'Gracias por registrar tu clase',
      //           style: TextStyle(color: Colors.white),
      //         ),
      //       ],
      //     ),
      //     backgroundColor: blue,
      //     duration: Duration(seconds: 5),
      //   ),
      // );

      if (mounted) {
        //  GoRouter.of(context).pop();
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

  void _showOverlay() {
    if (_overlayEntry != null) return;

    final overlay = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: Stack(
          children: [
            Container(
              color: Colors.black54,
            ),
            Center(
              child: SizedBox(
                width: 400,
                height: 400,
                child: Lottie.asset(controller: _animationController,
                    onLoaded: (composition) {
                  _animationController.duration = composition.duration;
                  _animationController.forward(from: 0);
                },
                    repeat: false,
                    'assets/animations/check_animation.json',
                    fit: BoxFit.contain),
              ),
            ),
          ],
        ),
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
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
