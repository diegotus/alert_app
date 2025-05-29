import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/alert_controller.dart';

class AlertView extends GetView<AlertController> {
  const AlertView({super.key});
  Map<String, dynamic>? get message => Get.arguments ?? Get.parameters;
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
              Image.asset("assets/icons/app_icon.png", height: 80),
              // const Icon(Icons.warning, size: 80, color: Colors.red),
              const SizedBox(height: 20),
              Text(
                message?['title'] ?? 'Unknown Emergency Alert',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                message?['body'] ?? 'Emergency Alert',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: controller.stopAlert,
                child: const Text('Accuser Réception'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
