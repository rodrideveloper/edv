import 'package:estilodevida/models/user/user_model.dart';
import 'package:estilodevida/ui/widgets/footer_image_bk.dart';
import 'package:estilodevida/ui/widgets/lessons_remains.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({
    super.key,
    required this.user,
  });

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String name = user.name?.split(' ')[0] ?? '';
    return Stack(
      children: [
        const FooterImageBackground(),
        LessonRemains(user: user),
        Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Align(
            alignment: Alignment.topCenter,
            child: Text(
              ' Hola $name!',
              style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
