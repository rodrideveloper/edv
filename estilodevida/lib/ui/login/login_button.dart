import 'package:estilodevida/ui/common_button.dart';
import 'package:estilodevida/services/auth_service/auth_service.dart';
import 'package:estilodevida/ui/constants.dart';
import 'package:estilodevida/ui/login/validators.dart';
import 'package:flutter/material.dart';
import 'package:estilodevida/models/auth_result.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginButton extends StatefulWidget {
  const LoginButton({
    super.key,
    required this.email,
    required this.pw,
    required this.voidCallback,
  });

  final TextEditingController email;
  final TextEditingController pw;
  final Function(String?, String?) voidCallback;

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  final _authService = AuthService();
  bool loadingAuth = false;
  String? errorTextEmail;
  String? errorTextPassword;

  @override
  Widget build(BuildContext context) {
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
                  'Ingresar con ',
                  style: GoogleFonts.roboto(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                const IconButton(
                  icon: Icon(
                    Icons.mail,
                    color: Colors.white,
                  ),
                  iconSize: 20,
                  onPressed: null,
                  color: Colors.white,
                ),
              ],
      ),
      onPress: () => _login(widget.email.text, widget.pw.text),
    );
  }

  void _login(String email, String password) async {
    if (validateFields(email, password)) {
      setState(() {
        loadingAuth = true;
      });
      var result =
          await _authService.signInWithEmailAndPassword(email, password);
      if (result is AuthResultError) {
        _clearControllers();
        result.message != null ? _showMyDialog(result.message!) : null;
      } else {
        if (mounted) {
          GoRouter.of(context).go('/');
        }
      }
      setState(() {
        loadingAuth = false;
      });
    }
  }

  bool validateFields(email, password) {
    String? validEmail = validateEmail(email);
    String? validPassword = validatePassword(password);

    if (validEmail != null) {
      widget.voidCallback(validEmail, null);

      return false;
    }

    if (validPassword != null) {
      widget.voidCallback(null, validPassword);

      return false;
    }
    return true;
  }

  _clearControllers() {
    widget.pw.clear();
  }

  _showMyDialog(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(message),
          );
        });
  }
}
