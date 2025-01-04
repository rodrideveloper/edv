import 'package:flutter/material.dart';

class LogoBackground extends StatelessWidget {
  const LogoBackground({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(-20.0, 0.0),
      child: Transform.scale(
        scale: 0.8,
        child: Opacity(
          opacity: 0.1,
          child: Image.asset('assets/images/logo_edv.png'),
        ),
      ),
    );
  }
}
