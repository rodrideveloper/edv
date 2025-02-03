import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Un widget reutilizable que muestra un alias con opciones para copiar y un mensaje instructivo.
class AliasCard extends StatelessWidget {
  /// El alias que se mostrará (por ejemplo, 'Estilodevida.ok').
  final String alias;

  /// El número de teléfono al que se debe enviar el comprobante.
  final String phoneNumber;

  /// Constructor del AliasCard.
  const AliasCard({
    super.key,
    required this.alias,
    required this.phoneNumber,
  });

  /// Método para copiar el alias al portapapeles y mostrar una notificación.
  void _copyAlias(BuildContext context) {
    Clipboard.setData(ClipboardData(text: alias));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Alias copiado al portapapeles'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Alias:'),
            Icon(
              Icons.wallet,
              size: 48,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 16),

            // Texto del alias

            Text(
              alias,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Botón para copiar el alias
            ElevatedButton.icon(
              onPressed: () => _copyAlias(context),
              icon: const Icon(Icons.copy, color: Colors.white),
              label: const Text(
                'Copiar Alias',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Mensaje instructivo
            Text(
              'Después de hacer la transferencia, envía el comprobante al: $phoneNumber',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[700],
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
