import 'package:alert_app/app/controllers/firebase_service_controller.dart';
import 'package:alert_app/app/controllers/notification_controller_test.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart' show GetStorage;

import 'app/controllers/app_services_controller.dart'
    show AppServicesController;
import 'app/routes/app_pages.dart';
import 'package:firebase_notifications_handler/firebase_notifications_handler.dart';
import 'package:alert_app/app/modules/alert/controllers/alert_controller.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackground(RemoteMessage message) async {
  // If you need to initialize Firebase again here (usually needed)
  print("Handling a background message: ${message.messageId}");
  if (Get.isRegistered<AlertController>()) {
    Get.find<AlertController>().triggerAlert;
  } else {
    Get.put<AlertController>(AlertController());
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackground);

  await _onInit();
  runApp(MyApp());
}

Future<void> _onInit() async {
  await GetStorage.init("userData");

  await Get.putAsync<FirebaseServices>(
    () async => await FirebaseServices.initFirebase(),
  );
  Get.put<AppServicesController>(AppServicesController());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseServices = Get.find<FirebaseServices>();
    return GetMaterialApp(
      title: "Application",
      theme: ThemeData(primarySwatch: Colors.red),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
    // return FirebaseNotificationsHandler(
    //   handleInitialMessage: true,
    //   messageModifier: FirebaseServices.messageModifier,
    //   onFcmTokenUpdate: firebaseServices.onFcmTokenUpdate,
    //   onFcmTokenInitialize: firebaseServices.onFcmTokenInitialize,
    //   shouldHandleNotification: firebaseServices.shouldHandleNotification,
    //   onOpenNotificationArrive: (message) {
    //     print("on message receoved");
    //     firebaseServices.onOpenNotificationArrive(message);
    //   },
    //   permissionGetter: FirebaseServices.permissionGetter,
    //   requestPermissionsOnInitialize: true,
    //   onTap: FirebaseServices.ontapeNotif,
    //   child: GetMaterialApp(
    //     title: "Application",
    //     theme: ThemeData(primarySwatch: Colors.red),
    //     initialRoute: AppPages.INITIAL,
    //     getPages: AppPages.routes,
    //   ),
    // );
  }
}
