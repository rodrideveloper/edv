import 'package:estilodevida/error_handler.dart';
import 'package:estilodevida/services/http_service/http_service.dart';
import 'package:estilodevida/services/user_pack_service.dart/user_pack_service.dart';
import 'package:estilodevida/ui/constants.dart';
import 'package:estilodevida/ui/packs/packs.dart';
import 'package:estilodevida/ui/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

enum Method { efectivo, transferencia }

class BuyButtonPack extends StatefulWidget {
  const BuyButtonPack({
    super.key,
    required this.pack,
    required this.uid,
  });

  final PackOption pack;
  final String uid;

  @override
  State<BuyButtonPack> createState() => _BuyButtonPackState();
}

class _BuyButtonPackState extends State<BuyButtonPack> {
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
    final user = context.read<User>();
    try {
      await UserPackService().addManualPay(
        widget.pack,
        user,
        method,
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

      errorHandler(err: err, stack: stack, reason: 'Pago manual', information: [
        {
          'user': user.uid,
          'pack': widget.pack.id,
        }
      ]);
    }
  }

  Future<void> _buyPack(
    BuildContext context,
    PackOption pack,
    String uid,
  ) async {
    try {
      await _showPaymentDialog(context);
    } catch (err, stack) {
      FirebaseCrashlytics.instance.recordError(
        err,
        stack,
        fatal: true,
        reason: 'Error en _buyPack',
      );
    }
  }

  Future<void> _launchURL(
    BuildContext context,
    PackOption pack,
  ) async {
    try {
      final user = context.read<User?>();
      final theme = Theme.of(context);

      final result =
          await HttpService(baseUrl: baseUrl).post(createPreferenceEndPoint, {
        'itemId': pack.id,
        'unitPrice': pack.unitPrice,
        'title': pack.title,
        'packId': pack.id,
        'lessons': pack.lessons,
        'dueDays': pack.dueDays,
        'userId': user?.uid,
      });

      final url = result['init_point'];

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
        reason: 'Error en Buy Button',
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

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: loading
          ? null
          : () async {
              setState(() => loading = true);
              await _buyPack(context, widget.pack, widget.uid);
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
              textAlign: TextAlign.center,
              'Comprar ahora',
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
