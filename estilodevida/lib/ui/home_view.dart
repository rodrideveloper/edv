import 'package:estilodevida/ui/widgets/background_waves.dart';
import 'package:estilodevida/ui/widgets/footer_image_bk.dart';
import 'package:estilodevida/ui/widgets/lessons_remains.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String name = user.displayName?.split(' ')[0] ?? '';
    return Stack(
      children: [
        DancingWavesBackground(),
        const FooterImageBackground(),
        LessonRemains(user: user),
        Padding(
          padding: const EdgeInsets.only(top: 120),
          child: Align(
            alignment: Alignment.topCenter,
            child: Text(
              ' Hola $name!',
              style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
            ),
          ),
        ),
        // ProfileImage(user: user),
      ],
    );
  }
}
