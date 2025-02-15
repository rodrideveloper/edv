import 'package:estilodevida/ui/login/apple_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

import 'package:estilodevida/ui/login/login_google_button.dart';
import 'package:estilodevida/ui/constants.dart';

enum LoginType { google, apple }

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
          statusBarColor: purple, systemNavigationBarColor: purple),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                purple.withOpacity(0.05),
                blue.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Stack(
                    children: [
                      ClipPath(
                        clipper: WaveClipper(),
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                purple,
                                blue,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: CircleAvatar(
                          radius: 100,
                          backgroundColor: Colors.white,
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/logo_edv.png',
                              width: 200,
                              height: 150,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 24,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '¡Bienvenido!',
                          style: theme.textTheme.headlineLarge?.copyWith(
                            color: purple.withOpacity(0.8),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Ingresa a Estilo de Vida',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 30),
                        const GoogleLoginButton(),
                        const SizedBox(height: 10),
                        const AppleLoginButton(),
                        const SizedBox(height: 40),
                        _buildPrivacyPolicyLink(context),
                        _buildDeleteUserLink(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPrivacyPolicyLink(BuildContext context) {
    return TextButton(
      onPressed: () async {
        const url = 'https://estilodevidamdp.com.ar/privacypolicy';
        try {
          await launchUrl(Uri.parse(url));
        } catch (e) {
          debugPrint('Error al abrir URL: $e');
        }
      },
      child: Text(
        'Política de Privacidad',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: blue,
              fontSize: 12,
              decoration: TextDecoration.underline,
            ),
      ),
    );
  }
}

Widget _buildDeleteUserLink(BuildContext context) {
  return TextButton(
    onPressed: () async {
      const url = 'https://estilodevidamdp.com.ar/deleteuser.html';
      try {
        await launchUrl(Uri.parse(url));
      } catch (e) {
        debugPrint('Error al abrir URL: $e');
      }
    },
    child: Text(
      'How delete user?',
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: blue,
            fontSize: 12,
            decoration: TextDecoration.underline,
          ),
    ),
  );
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 40);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 40);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    var secondControlPoint = Offset(size.width * 3 / 4, size.height - 80);
    var secondEndPoint = Offset(size.width, size.height - 40);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) => false;
}
