import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerErrorWidget extends StatelessWidget {
  const ScannerErrorWidget({super.key, required this.error});

  final MobileScannerException error;

  @override
  Widget build(BuildContext context) {
    String errorMessage;

    switch (error.errorCode) {
      case MobileScannerErrorCode.controllerUninitialized:
        errorMessage = "qr.error.generic";
        break;
      case MobileScannerErrorCode.permissionDenied:
        errorMessage = "qr.error.permissionDenied";
        break;
      case MobileScannerErrorCode.unsupported:
        errorMessage = "qr.error.unsupported";
        break;
      default:
        errorMessage = "qr.error.generic";
        break;
    }

    return ColoredBox(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Icon(Icons.error, color: Colors.white),
              ),
              Text(
                errorMessage,
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                error.errorDetails?.message ?? '',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
