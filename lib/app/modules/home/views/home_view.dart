import 'package:alert_app/app/routes/app_pages.dart' show Routes;
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acceuil'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(25),
              onTap: () => Get.toNamed(Routes.PROFIL),
              child: Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(25),
                ),

                child: Center(
                  child: Icon(Icons.manage_accounts_rounded, size: 30),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              "assets/icons/app_splash.png",
              height: 200,
              opacity: const AlwaysStoppedAnimation(.1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Obx(() {
              var items = controller.listNotification;
              return ListView.separated(
                itemCount: items.length,
                separatorBuilder: (context, index) {
                  return Divider(endIndent: 20, indent: 20);
                },
                itemBuilder: (context, index) {
                  var item = items[index];
                  return Card(
                    child: ListTile(
                      onTap:
                          () => Get.toNamed(
                            Routes.NOTIFICATION_DETAIL,
                            arguments: item,
                          ),
                      title: Text(item.title),
                      subtitle: Text(item.body),
                      trailing: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${item.date.day.toString().padLeft(2, '0')}/${item.date.month.toString().padLeft(2, '0')}/${item.date.year}",
                          ),
                          Text(
                            "${item.date.hour.toString().padLeft(2, '0')}:${item.date.minute.toString().padLeft(2, '0')}",
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
