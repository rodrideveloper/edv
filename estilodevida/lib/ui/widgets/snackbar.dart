import 'package:estilodevida/ui/constants.dart';
import 'package:flutter/material.dart';

void showCustomSnackBar(
  BuildContext context,
  String message, {
  Duration duration = const Duration(seconds: 4),
}) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(color: Colors.white, fontSize: 15),
    ),
    duration: duration,
    backgroundColor: purple,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
