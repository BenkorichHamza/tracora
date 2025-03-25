import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  late MobileScannerController controller;
  var c = "";
  @override
  void initState() {
    super.initState();
    controller = MobileScannerController(
      autoStart: true,
      formats: [],
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scanner'),
        actions: [
          IconButton(
              onPressed: () async {
                await controller.toggleTorch();
                setState(() {});
              },
              icon: controller.torchEnabled
                  ? Icon(Icons.flash_off)
                  : Icon(Icons.flash_on))
        ],
      ),
      body: SafeArea(
          child: AspectRatio(
        aspectRatio: 1,
        child: MobileScanner(
          controller: controller,
          scanWindow: Rect.fromLTWH(0, 0, 10000, 10000),
          onDetect: (v) {
            if (v.barcodes.isEmpty) return;
            if (v.barcodes.first.displayValue == null) return;
            if (c.isEmpty) {
              c = v.barcodes.first.displayValue ?? '';
              Get.back(result: v.barcodes.first.displayValue);
            }
          },
        ),
      )),
    );
  }
}
