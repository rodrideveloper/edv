import 'package:estilodevida/ui/user_pack/user_pack_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

class EventPaymentPendingScreen extends StatelessWidget {
  const EventPaymentPendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const buttonColor = Color(0xFF81327D);

    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            // Contenido centrado
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.pending,
                      color: blue,
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

                    Text(
                      'Ya falta poco!',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    Column(
                      children: [
                        Text(
                          'Pronto se te acreditará tu entrada.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.black54,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Estamos validando tu pago.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.black54,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            // Botón en la parte inferior
            Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
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
            ),
          ],
        ),
      ),
    );
  }
}
