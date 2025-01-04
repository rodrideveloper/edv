import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  const CommonButton({
    super.key,
    required this.title,
    required this.onPress,
    this.color,
    this.hasBorder = false,
  });

  final Widget title;
  final VoidCallback? onPress;
  final Color? color;
  final bool hasBorder;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      decoration: hasBorder
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                width: 1,
              ),
            )
          : null,
      height: 45,
      width: size.width,
      child: ElevatedButton(
        style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(color)),
        onPressed: onPress,
        child: title,
      ),
    );
  }
}
