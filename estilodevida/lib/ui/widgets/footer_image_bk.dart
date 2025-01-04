import 'package:flutter/material.dart';

class FooterImageBackground extends StatelessWidget {
  const FooterImageBackground({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Transform.translate(
        offset: const Offset(20.0, 50.0),
        child: Transform.scale(
          scale: 1.2,
          child: Opacity(
            opacity: 0.1,
            child: Image.asset('assets/images/2.png'),
          ),
        ),
      ),
    );
  }
}
