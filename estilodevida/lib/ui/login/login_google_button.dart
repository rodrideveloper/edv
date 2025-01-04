import 'package:estilodevida/ui/common_button.dart';
import 'package:estilodevida/services/auth_service/auth_service.dart';
import 'package:estilodevida/ui/constants.dart';
import 'package:flutter/material.dart';
import 'package:estilodevida/models/auth_result.dart';

class GoogleLoginButton extends StatefulWidget {
  const GoogleLoginButton({super.key});

  @override
  State<GoogleLoginButton> createState() => _GoogleLoginButtonState();
}

class _GoogleLoginButtonState extends State<GoogleLoginButton> {
  final AuthService _authService = AuthService();

  bool loadingAuth = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CommonButton(
        color: purple,
        hasBorder: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: loadingAuth
              ? [
                  const CircularProgressIndicator(
                    color: Colors.white,
                  )
                ]
              : [
                  Text(
                    'Ingresar con Google',
                    style: theme.textTheme.titleSmall
                        ?.copyWith(color: Colors.white),
                  ),
                  IconButton(
                    icon: Image.asset("assets/images/gmail_logo.png"),
                    iconSize: 20,
                    onPressed: null,
                  ),
                ],
        ),
        onPress: () => _login());
  }

  void _login() async {
    setState(() {
      loadingAuth = true;
    });
    AuthResult result = await _authService.signInWithGoogle();

    if (result is AuthResultSuccess) {
      //GoRouter.of(context).go('/');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Error en el registro',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
    if (mounted) {
      setState(() {
        loadingAuth = false;
      });
    }
  }
}
