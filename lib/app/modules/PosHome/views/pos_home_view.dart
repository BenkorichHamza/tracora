import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/pos_home_controller.dart';

class PosHomeView extends GetView<PosHomeController> {
  const PosHomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PosHomeView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PosHomeView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
