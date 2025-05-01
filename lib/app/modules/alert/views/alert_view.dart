import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/alert_controller.dart';

class AlertView extends GetView<AlertController> {
  const AlertView({super.key});
  String? get message => Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.warning, size: 80, color: Colors.red),
              const SizedBox(height: 20),
              Text(
                message ?? 'Emergency Alert',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: controller.stopAlert,
                child: const Text('Acknowledge'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
