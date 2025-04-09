import 'package:flutter/material.dart';

class ToastManager {
  static final ToastManager _instance = ToastManager._internal();
  factory ToastManager() => _instance;
  ToastManager._internal();

  OverlayEntry? _currentToast;

  void showToast({
    required BuildContext context,
    required Widget content,
    Duration duration = const Duration(seconds: 3),
    Alignment alignment = Alignment.bottomRight,
    EdgeInsets margin = const EdgeInsets.all(20),
  }) {
    _currentToast?.remove();

    final overlay = Overlay.of(context);
    _currentToast = OverlayEntry(
      builder:
          (context) => Positioned(
            top: alignment == Alignment.topRight ? margin.top : null,
            bottom: alignment == Alignment.bottomRight ? margin.bottom : null,
            right: margin.right,
            child: Material(
              color: Colors.white,
              child: AnimatedSlide(
                offset: const Offset(1, 0),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                child: _ToastContainer(child: content),
              ),
            ),
          ),
    );

    overlay.insert(_currentToast!);

    Future.delayed(duration, () {
      _currentToast?.remove();
      _currentToast = null;
    });
  }
}

class _ToastContainer extends StatelessWidget {
  final Widget child;

  const _ToastContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.black.withOpacity(0.85),
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }
}
