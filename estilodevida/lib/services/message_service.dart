import 'package:flutter/material.dart';

class GlobalMessageService {
  static final GlobalMessageService _instance =
      GlobalMessageService._internal();
  factory GlobalMessageService() => _instance;

  GlobalMessageService._internal();

  OverlayEntry? _overlayEntry;
  bool _isShowing = false;

  void showMessage(BuildContext context, String message) {
    if (_isShowing) return;

    _isShowing = true;
    _overlayEntry = _createOverlayEntry(context, message);
    Overlay.of(context).insert(_overlayEntry!);

    Future.delayed(Duration(seconds: 2), () {
      hideMessage();
    });
  }

  void hideMessage() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      _isShowing = false;
    }
  }

  OverlayEntry _createOverlayEntry(BuildContext context, String message) {
    return OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height * 0.4,
        left: MediaQuery.of(context).size.width * 0.1,
        right: MediaQuery.of(context).size.width * 0.1,
        child: _AnimatedMessageWidget(
          message: message,
          onFinish: hideMessage,
        ),
      ),
    );
  }
}

class _AnimatedMessageWidget extends StatefulWidget {
  final String message;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;
  final VoidCallback onFinish;

  const _AnimatedMessageWidget({
    Key? key,
    required this.message,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
    required this.onFinish,
  }) : super(key: key);

  @override
  _AnimatedMessageWidgetState createState() => _AnimatedMessageWidgetState();
}

class _AnimatedMessageWidgetState extends State<_AnimatedMessageWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late ThemeData theme;

  @override
  void initState() {
    super.initState();

    // Configurar el AnimationController
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Configurar la animación de opacidad
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Iniciar la animación de aparición
    _controller.forward();

    // Programar la animación de desaparición
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _controller.reverse().then((_) {
          widget.onFinish();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // No olvidar limpiar el controlador
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    final backgroundColor =
        widget.backgroundColor ?? Color(0xFF3155A1).withOpacity(0.8);
    final textColor = widget.textColor ?? Colors.white;
    final iconColor = widget.iconColor ?? Colors.white;
    final icon = widget.icon ?? Icons.check_circle_outline;

    return Material(
      color: Colors.transparent, // Fondo transparente
      child: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            margin: const EdgeInsets.symmetric(horizontal: 40.0),
            decoration: BoxDecoration(
              color: backgroundColor, // Color con transparencia
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: iconColor,
                  size: 28,
                ),
                SizedBox(width: 12),
                Flexible(
                  child: Text(
                    widget.message,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: textColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
