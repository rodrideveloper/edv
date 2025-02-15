import 'package:estilodevida/models/auth_result.dart';
import 'package:estilodevida/services/auth_service/auth_service.dart';
import 'package:estilodevida/ui/common_button.dart';
import 'package:estilodevida/ui/user_pack/user_pack_card.dart';
import 'package:flutter/material.dart';

class AppleLoginButton extends StatefulWidget {
  const AppleLoginButton({super.key});

  @override
  State<AppleLoginButton> createState() => AppleLoginButtonState();
}

class AppleLoginButtonState extends State<AppleLoginButton> {
  final AuthService _authService = AuthService();

  bool loadingAuth = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CommonButton(
        color: blue,
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
                    'Ingresar con Apple',
                    style: theme.textTheme.titleSmall
                        ?.copyWith(color: Colors.white),
                  ),
                  IconButton(
                    onPressed: null,
                    icon: CircleAvatar(
                      backgroundColor: Colors.black,
                      child: ClipOval(
                        child: Image.asset(
                          "assets/images/apple_login.jpg",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
        ),
        onPress: () => _login());
  }

  void _login() async {
    setState(() {
      loadingAuth = true;
    });

    AuthResult result = await _authService.signInWithApple();

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
