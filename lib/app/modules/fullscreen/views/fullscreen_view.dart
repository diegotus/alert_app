import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/fullscreen_controller.dart';

class FullscreenView extends GetView<FullscreenController> {
  const FullscreenView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FullscreenView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'FullscreenView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
