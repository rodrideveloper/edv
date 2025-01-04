import 'package:estilodevida/error_handler.dart';
import 'package:estilodevida/services/http_service/http_service.dart';
import 'package:estilodevida/ui/constants.dart';
import 'package:estilodevida/ui/packs/packs.dart';
import 'package:estilodevida/ui/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BuyButton extends StatefulWidget {
  const BuyButton({
    super.key,
    required this.pack,
    required this.uid,
  });

  final PackOption pack;
  final String uid;

  @override
  State<BuyButton> createState() => _BuyButtonState();
}

class _BuyButtonState extends State<BuyButton> {
  bool loading = false;
  Future<void> _buyPack(
    BuildContext context,
    PackOption pack,
    String uid,
  ) async {
    try {
      await _launchURL(context, pack);
    } catch (err, stack) {
      FirebaseCrashlytics.instance.recordError(
        err,
        stack,
        fatal: true,
        reason: 'Error en launchUrl',
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
          information: []);
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
      onPressed: () async {
        setState(() {
          loading = true;
        });
        await _buyPack(context, widget.pack, widget.uid);
        setState(() {
          loading = false;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: purple,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      ),
      child: !loading
          ? Text(
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
