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
      appBar: AppBar(title: Text(item.title), centerTitle: true),
      body: Center(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.body, style: Get.textTheme.titleLarge),
            Divider(height: 30),
            Expanded(
              child:
                  (item.description ?? '').isNotEmpty
                      ? SmartText(item.description!)
                      : Center(child: Text("Aucun Message")),
            ),
          ],
        ),
      ),
    );
  }
}
