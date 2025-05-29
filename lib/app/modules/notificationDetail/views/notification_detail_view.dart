import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:smart_text_flutter/smart_text_flutter.dart';

import '../../../data/models/notification_model.dart' show NotificationModel;
import '../controllers/notification_detail_controller.dart';

class NotificationDetailView extends GetView<NotificationDetailController> {
  const NotificationDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    var item = Get.arguments as NotificationModel;
    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
        centerTitle: true,
        foregroundColor: Theme.of(context).primaryColor,
      ),
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              "assets/icons/app_splash.png",
              height: 200,
              opacity: const AlwaysStoppedAnimation(.1),
            ),
          ),
          Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.body,
                style: Get.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              Divider(height: 30),
              Expanded(
                child:
                    (item.description ?? '').isNotEmpty
                        ? SmartText(item.description!)
                        : Center(child: Text("Aucun Message")),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
