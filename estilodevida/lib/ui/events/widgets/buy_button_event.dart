import 'package:estilodevida/error_handler.dart';
import 'package:estilodevida/models/events/event_model.dart';
import 'package:estilodevida/models/user/user_model.dart';
import 'package:estilodevida/services/event_service/event_service.dart';
import 'package:estilodevida/services/http_service/http_service.dart';
import 'package:estilodevida/ui/constants.dart';
import 'package:estilodevida/ui/packs/widgets/buy_button.dart';
import 'package:estilodevida/ui/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BuyButtonEvent extends StatefulWidget {
  const BuyButtonEvent({
    super.key,
    required this.event,
    required this.uid,
  });

  final EventModel event;

  final String uid;

  @override
  State<BuyButtonEvent> createState() => _BuyButtonEventState();
}

class _BuyButtonEventState extends State<BuyButtonEvent> {
  bool loading = false;

  Future<void> _showPaymentDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Colors.white, width: 0),
          ),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          title: Text(
            'Elige tu método de pago',
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Text(
                'Selecciona una opción de pago para continuar.',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
          actions: [
            Align(
              alignment: Alignment.center,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(
                  Icons.monetization_on_outlined,
                  color: Colors.white,
                ),
                label: Text(
                  'Transferencia',
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  manualPay(Method.transferencia);
                },
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(
                  Icons.monetization_on_outlined,
                  color: Colors.white,
                ),
                label: Text(
                  'Efectivo',
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  manualPay(Method.efectivo);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> manualPay(
    Method method,
  ) async {
    final user = context.read<UserModel?>();
    if (user == null) return;

    if (!_checkUserData(user)) {
      return;
    }

    try {
      await EventService().addManualPay(
        event: widget.event,
        user: user,
        method: method,
      );

      GoRouter.of(context).push('/pending');
    } catch (err, stack) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Error al registrar pago manual.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: purple,
          duration: Duration(seconds: 3),
        ),
      );

      errorHandler(
        err: err,
        stack: stack,
        reason: 'Pago manual evento',
        information: [
          {
            'user': user.id,
            'eventId': widget.event.id,
          }
        ],
      );
    }
  }

  Future<void> _buyEvent(BuildContext context) async {
    try {
      await _showPaymentDialog(context);
    } catch (err, stack) {
      FirebaseCrashlytics.instance.recordError(
        err,
        stack,
        fatal: true,
        reason: 'Error en _buyEvent',
      );
    }
  }

  Future<void> _launchURL(BuildContext context) async {
    try {
      final user = context.read<User?>();
      final theme = Theme.of(context);
      if (user == null) return;

      // Supongamos que en tu backend sólo necesitas (id, title, price) para generar el link
      final result = await HttpService(baseUrl: baseUrl).post(
        createPreferenceEndPoint,
        {
          'eventId': widget.event.id,
          'title': widget.event.title,
          'price': widget.event.price,
          'userId': user.uid,
        },
      );

      final url = result['init_point'] as String;

      await launchUrl(
        Uri.parse(url),
        customTabsOptions: CustomTabsOptions(
          colorSchemes: CustomTabsColorSchemes.defaults(
            toolbarColor: theme.colorScheme.surface,
          ),
          shareState: CustomTabsShareState.on,
          urlBarHidingEnabled: true,
          showTitle: true,
          closeButton: CustomTabsCloseButton(
            icon: CustomTabsCloseButtonIcons.back,
          ),
        ),
        safariVCOptions: SafariViewControllerOptions(
          preferredBarTintColor: theme.colorScheme.surface,
          preferredControlTintColor: theme.colorScheme.onSurface,
          barCollapsingEnabled: true,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        ),
      );
    } catch (err, stack) {
      errorHandler(
        err: err,
        stack: stack,
        reason: 'Error lanzando URL de pago',
        information: [],
      );
      if (mounted) {
        showMessage();
      }
    }
  }

  void showMessage() => showCustomSnackBar(
        context,
        'Ups, tuvimos un error. Contacta al soporte.',
      );

  bool _checkUserData(
    UserModel user,
  ) {
    String result = '';
    if (user.phone == null || user.phone!.isEmpty) {
      result = 'Telefono';
    }

    if (user.email == null || user.email!.isEmpty) {
      result = 'Correo';
    }

    if (user.name == null || user.name!.isEmpty) {
      result = 'Nombre';
    }

    if (result.isNotEmpty) {
      showCustomSnackBar(
        context,
        'Antes de adquirir su entrada por favor complete su $result en su perfil.',
      );
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: loading
          ? null
          : () async {
              setState(() => loading = true);
              await _buyEvent(context);
              setState(() => loading = false);
            },
      style: ElevatedButton.styleFrom(
        backgroundColor: purple,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: !loading
          ? Text(
              'Comprar ahora',
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            )
          : const CircularProgressIndicator(
              color: Colors.white,
            ),
    );
  }
}
