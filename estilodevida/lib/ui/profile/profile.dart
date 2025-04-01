import 'package:estilodevida/error_handler.dart';
import 'package:estilodevida/models/user/user_model.dart';
import 'package:estilodevida/services/user_service.dart/user_service.dart';
import 'package:estilodevida/ui/common_button.dart';
import 'package:estilodevida/ui/constants.dart';
import 'package:estilodevida/ui/widgets/common_appbar.dart';
import 'package:estilodevida/ui/widgets/common_container.dart';
import 'package:estilodevida/ui/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();

  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = context.read<UserModel?>();
    if (_name.text != user?.name) {
      _name.text = user?.name ?? '';
    }
    if (_email.text != user?.email) {
      _email.text = user?.email ?? '';
    }
    if (_phone.text != user?.phone) {
      _phone.text = user?.phone ?? '';
    }
  }

  @override
  void dispose() {
    _phone.dispose();
    _name.dispose();
    _email.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserModel?>();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CommonAppBar(title: 'Mi Perfil '),
      body: CommonBackgroundContainer(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: user == null
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: EdgeInsets.only(top: size.height * 0.15),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        TextFormField(
                          controller: _name,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            iconColor: Colors.white,
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            errorStyle: TextStyle(color: Colors.white),
                            labelText: 'Nombre',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _email,
                          decoration: const InputDecoration(
                            filled: true,
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            fillColor: Colors.white,
                            iconColor: Colors.white,
                            errorStyle: TextStyle(color: Colors.white),
                            labelText: 'Correo',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _phone,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            iconColor: Colors.white,
                            labelStyle: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            errorStyle: const TextStyle(color: Colors.white),
                            labelText: 'Telefono',
                            hintText: user.phone,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const Spacer(),
                        _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Padding(
                                padding: const EdgeInsets.all(16),
                                child: CommonButton(
                                  color: purple,
                                  onPress: () async {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    FocusScope.of(context).unfocus();

                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      _formKey.currentState?.save();
                                      try {
                                        await UserService().saveUser(
                                            id: user.id,
                                            email: _email.text,
                                            phone: _phone.text,
                                            name: _name.text);
                                      } catch (err, stack) {
                                        errorHandler(
                                            err: err,
                                            stack: stack,
                                            reason: 'Update User error',
                                            information: [user.toString()]);

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    'Hubo un error al actualizar su usuario')));
                                      }
                                      setState(() {
                                        _isLoading = false;
                                      });

                                      _showMessage();
                                    }
                                  },
                                  hasBorder: true,
                                  title: Text(
                                    'Guardar',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  void _showMessage() =>
      showCustomSnackBar(context, 'Cuenta actualizada correctamente');
}
