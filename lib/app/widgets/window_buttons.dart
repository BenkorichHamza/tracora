import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';

class WindowButtons extends StatelessWidget {
  final HomeController homeController;
  WindowButtons({Key? key, required this.homeController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonColors = WindowButtonColors(
      iconNormal: homeController.isDark ? Colors.white : Colors.black,
      mouseOver: homeController.isDark ? Colors.grey[700]! : Colors.grey[300]!,
      mouseDown: homeController.isDark ? Colors.grey[600]! : Colors.grey[400]!,
      iconMouseOver: homeController.isDark ? Colors.white : Colors.black,
      iconMouseDown: homeController.isDark ? Colors.white : Colors.black,
    );

    final closeButtonColors = WindowButtonColors(
      mouseOver: Colors.red.shade700,
      mouseDown: Colors.red.shade900,
      iconNormal: homeController.isDark ? Colors.white : Colors.black,
      iconMouseOver: Colors.white,
    );
    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        MaximizeWindowButton(colors: buttonColors),
        CloseWindowButton(colors: closeButtonColors),
      ],
    );
  }
}
