import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainButtons extends StatelessWidget {
  const MainButtons({
    super.key,
    required this.user,
  });

  final User? user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    // Ajustar el tamaño de la fuente según el ancho de la pantalla
    double fontSize = 16;
    if (screenWidth > 600) {
      fontSize = 18;
    }
    if (screenWidth > 900) {
      fontSize = 20;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
          // Botón "Registrar Clase"
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton(
                onPressed: () => GoRouter.of(context).push('/register'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black,
                  side: const BorderSide(color: Colors.white),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize:
                        MainAxisSize.min, // Ocupa solo el espacio necesario
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.qr_code_scanner,
                        size: 24,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Registrar Clase',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontSize: fontSize,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow
                            .visible, // Permite que el texto se ajuste
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Botón "Comprar Pack"
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton(
                onPressed: () => GoRouter.of(context).push('/buypack'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize:
                        MainAxisSize.min, // Ocupa solo el espacio necesario
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.shopping_cart,
                        size: 24,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Comprar Pack',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontSize: fontSize,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow
                            .visible, // Permite que el texto se ajuste
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
