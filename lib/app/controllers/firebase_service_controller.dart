import 'dart:convert';
import 'dart:io';

import 'package:alert_app/app/controllers/notification_controller_test.dart'
    show
        firebaseMessagingBackgroundHandler,
        firebaseMessagingBackgroundHandler2;
import 'package:alert_app/app/core/utils/storage_box.dart';
import 'package:alert_app/app/data/models/notification_model.dart';
import 'package:alert_app/app/routes/app_pages.dart';
import 'package:alert_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_notifications_handler/firebase_notifications_handler.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../modules/alert/controllers/alert_controller.dart'
    show AlertController;

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

class FirebaseServices extends GetxService {
  FirebaseServices._onInit({this.token});
  bool allPermission = false;
  String? token;
  // String get currentSubscriveTopic => StorageBox.currentSubscriveTopic.val;
  void onFcmTokenInitialize(String? value) {
    StorageBox.fmcToken.val = value ?? '';
    token = value ?? '';
    print("the token $value");
  }

  void onFcmTokenUpdate(String value) {
    print("the token $value");
    StorageBox.fmcToken.val = value;
    token = value;
  }

  static RemoteMessage messageModifier(RemoteMessage message) {
    print("notif is opend body remote ${message.notification?.body}");
    return message;
  }

  bool shouldHandleNotification(RemoteMessage message) {
    print("notif is opend body ${message.notification?.body}");
    return true;
  }

  void onOpenNotificationArrive(NotificationInfo notif, {bool taped = false}) {
    print("the notif ${notif.firebaseMessage.data}");
    int startRage = 0;
    if (StorageBox.notifactions.val.length >= 100) {
      startRage = 1;
    }
    // StorageBox.notifactions.val.getRange(StorageBox.notifactions.val, end)//
    StorageBox.notifactions.val = [
      ...StorageBox.notifactions.val.getRange(
        startRage,
        StorageBox.notifactions.val.length,
      ),
      NotificationModel(
        title: notif.firebaseMessage.notification?.title ?? "",
        body: notif.firebaseMessage.notification?.body ?? "",
        description: notif.firebaseMessage.data['description'],
      ).toJson(),
    ];
    switch (notif.appState) {
      case AppState.terminated:
      case AppState.background:
        continue openNotif;
      openNotif:
      case AppState.open:
        if (notif.firebaseMessage.notification != null) {
          onMessage({
            "body": notif.firebaseMessage.notification?.body,
            "title": notif.firebaseMessage.notification?.title,
            "payload": jsonEncode(notif.firebaseMessage.data),
          });
        }
        break;
    }
  }

  void onMessage(Map<String, String?>? message) {
    if (message != null) {
      Get.toNamed(Routes.ALERT, arguments: message);
    }
  }

  static Future<FirebaseServices> initFirebase() async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler2);
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    return FirebaseServices._onInit(token: '');
  }

  Future<void> permissionGetter(FirebaseMessaging fcMsg) async {
    if (await Permission.notification.request().isGranted) {
      if (Platform.isAndroid) {
        allPermission = await Permission.systemAlertWindow.request().isGranted;
        _createChanel();
      } else {
        allPermission = true;
      }
    }

    // var fcmStatus = await fcMsg.getNotificationSettings();
    // if (fcmStatus.authorizationStatus != AuthorizationStatus.authorized) {
    //   fcmStatus = await fcMsg.requestPermission();
    // }
    // _createChanel();
  }

  static Future<void> _createChanel() async {
    var channels =
        await FirebaseNotificationsHandler.getAndroidNotificationChannels();
    if (channels == null || channels.length < 2) {
      await FirebaseNotificationsHandler.createAndroidNotificationChannels(
        const [
          AndroidNotificationChannel(
            'default',
            'Default',
            importance: Importance.high,
          ),
          AndroidNotificationChannel(
            'fullIntent',
            'Full Intent',
            importance: Importance.high,
          ),
        ],
      );
    }
  }

  @override
  void onInit() {
    // StorageBox.fmcToken.val = token ?? '';
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  static void _handleMessage(RemoteMessage message) {
    print("the message${message.toMap()}");
  }
}
