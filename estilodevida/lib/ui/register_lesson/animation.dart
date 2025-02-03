import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CheckAnimationScreen extends StatefulWidget {
  const CheckAnimationScreen({super.key});

  @override
  State<CheckAnimationScreen> createState() => _CheckAnimationScreenState();
}

class _CheckAnimationScreenState extends State<CheckAnimationScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SizedBox(
          width: 400,
          height: 400,
          child: Lottie.asset(
            'assets/animations/check_animation.json',
            controller: _animationController,
            onLoaded: (composition) {
              _animationController
                ..duration = composition.duration
                ..forward(from: 0);
            },
            repeat: false,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pop();
      }
    });
  }
}
