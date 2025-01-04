import 'package:flutter/material.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppBar({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      centerTitle: true,
      foregroundColor: Colors.white,
      backgroundColor: Colors.transparent,
      title: Text(title,
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white)),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
