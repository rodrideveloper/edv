import 'package:estilodevida_adm/ui/register_lesson/register_lesson.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: RegisterLessonListScreen(),
      );
}
