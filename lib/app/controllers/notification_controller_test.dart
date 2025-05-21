import 'dart:convert';
import 'dart:io';
import 'package:alert_app/app/controllers/app_services_controller.dart';
import 'package:alert_app/app/core/utils/storage_box.dart' show StorageBox;
import 'package:alert_app/app/data/models/notification_model.dart'
    show NotificationModel;
import 'package:alert_app/app/routes/app_pages.dart';
import 'package:eraser/eraser.dart' show Eraser;
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_notifications_handler/firebase_notifications_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_screen_intent/flutter_full_screen_intent.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/num_extensions.dart';
import 'package:get_storage/get_storage.dart' show GetStorage;

import '../modules/alert/controllers/alert_controller.dart'
    show AlertController;
// Using Get for navigation

// --- Global Variables ---
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Define the channel for high-priority/full-screen notifications
const AndroidNotificationChannel fullScreenChannel = AndroidNotificationChannel(
  'fullIntent', // id
  'Full Intent', // titleq
  description:
      'Channel for critical alerts requiring immediate attention.', // description
  importance: Importance.max, // MUST be high or max for full-screen
  playSound: true,
  // Add sound file if needed:
  // sound: RawResourceAndroidNotificationSound('your_alert_sound'), // e.g., res/raw/your_alert_sound.mp3
  enableVibration: true,
);

// Background message handler (needs to be a top-level function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
  NotificationInfo message,
) async {
  // If you need to initialize Firebase again here (usually needed)
  await Firebase.initializeApp();
  await showFullScreenNotification(
    message.firebaseMessage,
  ); // Show notification from background
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler2(RemoteMessage message) async {
  // If you need to initialize Firebase again here (usually needed)
  await Firebase.initializeApp();
  await showFullScreenNotification(
    message,
  ); // Show notification from background
}

// --- Notification Display Logic ---
Future<void> showFullScreenNotification(RemoteMessage message) async {
  // Extract data (customize based on your payload)
  final String? title = message.notification?.title;
  final String? body = message.notification?.body;
  // Pass relevant data for when the notification is tapped
  if (title != null && body != null) {
    final Map<String, dynamic> payloadData = message.data;
    var isInited = await GetStorage.init("userData");
    if (isInited) {
      int startRage = 0;
      if (StorageBox.notifactions.val.length >= 100) {
        startRage = 1;
      }
      StorageBox.notifactions.val = [
        ...StorageBox.notifactions.val.getRange(
          startRage,
          StorageBox.notifactions.val.length,
        ),
        NotificationModel(
          title: title,
          body: body,
          message: payloadData['message'],
        ).toJson(),
      ];
    }
    if (Platform.isAndroid) {
      await FlutterFullScreenIntent().openFullScreenWidget(
        "${Routes.ALERT}?title=$title&body=$body&payload=${jsonEncode(payloadData)}&isIntent=true",
      );
    } else {
      print("its testing");
      Get.isRegistered<AlertController>()
          ? Get.find<AlertController>().triggerAlert()
          : Get.put<AlertController>(AlertController()).triggerAlert();
    }
  }
}

// --- Main Application Setup ---
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // --- Initialize flutter_local_notifications ---
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher'); // Use your app icon

  // iOS Initialization (optional but recommended)
  // final DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
  //   requestAlertPermission: true,
  //   requestBadgePermission: true,
  //   requestSoundPermission: true,
  // );

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    // iOS: initializationSettingsIOS,
  );

  // Callback when notification is tapped (foreground or background)
  Future<void> onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse,
  ) async {
    if (notificationResponse.payload != null &&
        notificationResponse.payload!.isNotEmpty) {
      try {
        final Map<String, dynamic> data = jsonDecode(
          notificationResponse.payload!,
        );
        // Navigate using GetX (or your preferred method)
        // Get.to(() => FullScreenAlertPage(payload: data));
      } catch (e) {
        print('Error decoding payload or navigating: $e');
      }
    }
  }

  // Callback for background notification taps (newer API)
  Future<void> onDidReceiveBackgroundNotificationResponse(
    NotificationResponse notificationResponse,
  ) async {
    print(
      'Background Notification Tapped: Payload: ${notificationResponse.payload}',
    );
    if (notificationResponse.payload != null &&
        notificationResponse.payload!.isNotEmpty) {
      try {
        final Map<String, dynamic> data = jsonDecode(
          notificationResponse.payload!,
        );
        // You might want to store this data and handle navigation once the app resumes
        // Or attempt navigation if possible (might be limited from background)
        // For simplicity, we'll just print here, but ideally handle navigation robustly.
        print("Need to navigate to FullScreenAlertPage with data: $data");
        // If GetX is set up correctly, this *might* work from background in some cases
        // Get.to(() => FullScreenAlertPage(payload: data));
      } catch (e) {
        print('Error decoding payload in background: $e');
      }
    }
  }

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    onDidReceiveBackgroundNotificationResponse:
        onDidReceiveBackgroundNotificationResponse,
  );

  // Create the high-priority channel
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(fullScreenChannel);

  // --- Initialize firebase_notifications_handler ---
  // Request permissions (iOS and Android 13+)
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false, // Set to true only if you have Apple's entitlement
    provisional: false,
    sound: true,
  );
}
