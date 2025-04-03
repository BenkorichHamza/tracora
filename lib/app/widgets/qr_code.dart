import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';

class QrCode extends StatelessWidget {
  const QrCode(this.data, {super.key, this.size});
  final String data;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return QrImageView(
      data: data,
      version: QrVersions.auto,
      size: size ?? Get.width * 0.7,
      eyeStyle: QrEyeStyle(color: Colors.green, eyeShape: QrEyeShape.square),
      dataModuleStyle: QrDataModuleStyle(
        color: Get.find<HomeController>().theme.colorScheme.onSurface,
        dataModuleShape: QrDataModuleShape.square,
      ),
      embeddedImageStyle: QrEmbeddedImageStyle(
        color: Get.theme.colorScheme.onSurface,
      ),
    );
  }
}
