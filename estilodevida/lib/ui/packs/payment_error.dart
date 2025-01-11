import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_animate/flutter_animate.dart';

class PaymentErrorScreen extends StatelessWidget {
  const PaymentErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const buttonColor = Color(0xFF81327D); // Color personalizado para el botón
    const redErrorColor = Colors.red; // Color rojo para el ícono de error

    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ícono de error con animación
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: redErrorColor,
                        size: 100,
                      )
                          .animate()
                          .shake(
                              duration: 600.ms, hz: 4) // Animación de sacudida
                          .fadeIn(duration: 600.ms), // Animación de aparición
                      const SizedBox(height: 30),

                      // Título principal
                      Text(
                        '¡Algo salió mal!',
                        style: theme.textTheme.headlineLarge?.copyWith(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),

                      // Mensaje de error
                      Text(
                        'No pudimos procesar tu pedido. Por favor intenta nuevamente.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),

              // Botón para intentar nuevamente
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => GoRouter.of(context).push('/'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Intentar Nuevamente',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
