import 'dart:async';
import 'package:estilodevida/ui/common_button.dart';
import 'package:estilodevida/ui/constants.dart';
import 'package:estilodevida/ui/widgets/common_appbar.dart';
import 'package:estilodevida/ui/widgets/qr_scanner_error.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({
    super.key,
    required this.onToken,
    required this.title,
    required this.popWidget,
  });
  final Function(String) onToken;
  final String title;
  final bool popWidget;

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> with WidgetsBindingObserver {
  String? _barcode;
  bool cameraPermission = false;

  void _handleBarcode(BarcodeCapture barcodes) {
    if (mounted) {
      if (barcodes.barcodes.firstOrNull != null && _barcode == null) {
        _barcode = barcodes.barcodes.firstOrNull!.displayValue;
        widget.onToken(_barcode!);
      }
    }
  }

  Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();

    setState(() {
      cameraPermission = status.isGranted;
    });

    return status.isGranted;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    requestCameraPermission();

    super.initState();
  }

  @override
  void dispose() async {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
      case AppLifecycleState.resumed:
        await requestCameraPermission();

      case AppLifecycleState.inactive:
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final scanWindow = Rect.fromCenter(
      center: MediaQuery.sizeOf(context).center(Offset(0, -size.height * 0.15)),
      width: 250,
      height: 250,
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CommonAppBar(title: 'Escanear QR'),
      body: cameraPermission
          ? Stack(
              children: [
                MobileScanner(
                  onDetect: _handleBarcode,
                  errorBuilder: (p0, p1, p2) => ScannerErrorWidget(
                    error: p1,
                  ),
                ),
                _buildHelpText(size, theme),
                CustomPaint(
                  painter: ScannerOverlay(scanWindow: scanWindow),
                ),
              ],
            )
          : Align(
              alignment: Alignment.topCenter,
              child: requestPermissions(theme, size),
            ),
    );
  }

  Align _buildHelpText(Size size, ThemeData theme) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(16),
        height: size.height * 0.40,
        width: size.width,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(children: [
          const Expanded(
            child: Icon(
              Icons.qr_code_2,
              color: purple,
              size: 80,
            ),
          ),
          Expanded(
            child: Text(widget.title, textAlign: TextAlign.center),
          ),
        ]),
      ),
    );
  }

  Center requestPermissions(
    ThemeData theme,
    Size size,
  ) =>
      Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Permisos',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: size.width * 0.7,
                child: CommonButton(
                  color: purple,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.build,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Pedir Permisos',
                        style: GoogleFonts.roboto(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  onPress: () => openAppSettings(),
                ),
              )
            ],
          ),
        ),
      );
}

class ScannerOverlay extends CustomPainter {
  const ScannerOverlay({required this.scanWindow, this.borderRadius = 16});

  final Rect scanWindow;
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPath = Path()..addRect(Rect.largest);

    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          scanWindow,
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius),
        ),
      );

    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final borderRect = RRect.fromRectAndCorners(
      scanWindow,
      topLeft: Radius.circular(borderRadius),
      topRight: Radius.circular(borderRadius),
      bottomLeft: Radius.circular(borderRadius),
      bottomRight: Radius.circular(borderRadius),
    );

    canvas.drawPath(backgroundWithCutout, backgroundPaint);
    canvas.drawRRect(borderRect, borderPaint);
  }

  @override
  bool shouldRepaint(ScannerOverlay oldDelegate) {
    return scanWindow != oldDelegate.scanWindow ||
        borderRadius != oldDelegate.borderRadius;
  }
}
