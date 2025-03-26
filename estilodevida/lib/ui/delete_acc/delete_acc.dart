import 'package:estilodevida/services/message_service.dart';
import 'package:estilodevida/ui/constants.dart';
import 'package:estilodevida/ui/widgets/common_appbar.dart';
import 'package:estilodevida/ui/widgets/common_container.dart';
import 'package:flutter/material.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({Key? key}) : super(key: key);

  @override
  _DeleteAccountScreenState createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _confirmController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _confirmController.dispose();
    super.dispose();
  }

  // Validación: el usuario debe escribir "CONFIRMAR" para proceder
  String? _validateConfirmation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    if (value.trim() != 'CONFIRMAR') {
      return 'Debes escribir "CONFIRMAR" para eliminar la cuenta';
    }
    return null;
  }

  Future<void> _deleteAccount() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        //   await AuthService().deleteAcc();
        // Notificar al usuario y redirigir (según tu lógica de la app)
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cuenta eliminada correctamente')));
        // Ejemplo: volver a la pantalla de inicio o login
        Navigator.of(context).pop();
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al eliminar la cuenta: $error')));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CommonAppBar(title: 'Eliminar Cuenta'),
      body: CommonBackgroundContainer(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                      'Atención: Al confirmar la eliminación, tu cuenta se programará para ser eliminada en las próximas 72 horas. Durante este periodo, podrás comunicarte con nuestro soporte si deseas cancelar la solicitud. Una vez transcurrido el plazo, la acción será irreversible.',
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                  const Text(
                    'Para eliminar tu cuenta, escribe "CONFIRMAR" en el siguiente campo:',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _confirmController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      iconColor: Colors.white,
                      labelText: 'Confirmar eliminación',
                      border: OutlineInputBorder(),
                    ),
                    validator: _validateConfirmation,
                  ),
                  const SizedBox(height: 20),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: purple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              _formKey.currentState?.save();
                              GlobalMessageService().showMessage(
                                context,
                                'Su solicitud fue recibida, gracias',
                              );
                            }
                          },
                          child: const Text(
                            'Eliminar Cuenta',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
