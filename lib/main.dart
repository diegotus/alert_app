import 'package:alert_app/app/controllers/firebase_service_controller.dart';
import 'package:eraser/eraser.dart';
import 'package:firebase_notifications_handler/firebase_notifications_handler.dart'
    show FirebaseNotificationsHandler, LocalNotificationsConfiguration;
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart' show GetStorage;

import 'app/controllers/app_services_controller.dart'
    show AppServicesController;
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _onInit();
  runApp(MyApp());
}

Future<void> _onInit() async {
  // initializeReflectable();

  // initializeDateFormatting("fr");

  // // Initialize GetStoragePro (call this before using any GetStoragePro functionality)
  // await GetStoragePro.init();
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
    return FirebaseNotificationsHandler(
      messageModifier: FirebaseServices.messageModifier,
      onFcmTokenUpdate: firebaseServices.onFcmTokenUpdate,
      onFcmTokenInitialize: firebaseServices.onFcmTokenInitialize,
      shouldHandleNotification: firebaseServices.shouldHandleNotification,
      onOpenNotificationArrive: firebaseServices.onOpenNotificationArrive,
      permissionGetter: firebaseServices.permissionGetter,
      requestPermissionsOnInitialize: true,
      localNotificationsConfiguration: LocalNotificationsConfiguration(
        notificationIdGetter: (p0) {
          print("getting id ${p0.hashCode}");
          return p0.hashCode;
        },
      ),
      onTap:
          (val) => firebaseServices.onOpenNotificationArrive(val, taped: true),
      child: GetMaterialApp(
        title: "Application",
        theme: ThemeData(primarySwatch: Colors.red),
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (BuildContext context) {
              return Scaffold(body: Center(child: Text("uknow rooute")));
            },
          );
        },
      ),
    );
  }
}
