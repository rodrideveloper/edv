import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const buttonColor = Color(0xFF81327D);
    const greenCheckColor = Colors.green;

    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ícono de check animado (sin 'const')
              Icon(
                Icons.check_circle,
                color: greenCheckColor,
                size: 100,
              )
                  .animate() // Inicia la cadena de animaciones
                  .scale(
                    begin: Offset(15, 15),
                    end: Offset(1, 1),
                    duration: 1200.ms,
                    curve: Curves.bounceOut,
                  ) // Animación de escala
                  .fadeIn(
                    duration: 800.ms,
                    curve: Curves.easeIn,
                  ), // Animación de desvanecimiento

              const SizedBox(height: 30),

              // Título principal
              Text(
                '¡Gracias por tu compra!',
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              // Mensaje de agradecimiento
              Text(
                'Tu pedido ha sido realizado con éxito.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Botón para continuar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => GoRouter.of(context).go('/'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Continuar',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
