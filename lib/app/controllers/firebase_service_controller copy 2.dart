import 'package:alert_app/app/core/utils/storage_box.dart';
import 'package:alert_app/app/routes/app_pages.dart';
import 'package:alert_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_notifications_handler/firebase_notifications_handler.dart';
import 'package:get/get.dart';
import 'notification_controller_test.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'default', // id
  'default', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.high,
  playSound: true,
);

class FirebaseServices extends GetxService {
  FirebaseServices._onInit({this.token});
  String? token;

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

  void onMessageOpened(RemoteMessage message) {
    if (message.notification != null) {
      Get.toNamed(Routes.ALERT, arguments: message.notification?.body);
    }
  }

  void onMessage(String? message) {
    if (message != null) {
      Get.toNamed(Routes.ALERT, arguments: message);
    }
  }

  static Future<FirebaseServices> initFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseMessaging.instance.requestPermission();
    var token = await FirebaseMessaging.instance.getToken();

    return FirebaseServices._onInit(token: token);
  }

  static Future<void> _createChanel() async {
    var channels =
        await FirebaseNotificationsHandler.getAndroidNotificationChannels();
    if (channels == null || channels.isEmpty) {
      await FirebaseNotificationsHandler.createAndroidNotificationChannels(
        const [
          AndroidNotificationChannel(
            'default',
            'Default',
            importance: Importance.high,
          ),
          AndroidNotificationChannel(
            'alert',
            'alert',
            importance: Importance.high,
          ),
        ],
      );
    }
  }

  @override
  void onInit() {
    // StorageBox.fmcToken.val = token ?? '';
    print("the token $token");
    FirebaseMessaging.instance.onTokenRefresh.listen(onFcmTokenUpdate);
    FirebaseMessaging.onMessageOpenedApp.listen(onMessageOpened);
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

  // --- Local Notifications Initialization ---
  Future<void> _initializeLocalNotifications() async {
    // Create Android Notification Channel defined above
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    // Initialization settings for Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
          '@mipmap/ic_launcher',
        ); // Use default app icon

    // Initialization settings for iOS
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: false, // Permissions requested via Firebase
          requestBadgePermission: false,
          requestSoundPermission: false,
        );

    // Overall Initialization settings
    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    // Initialize the plugin
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      // Handle notification taps when the app is in the foreground/background
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
      // Handle background notification taps (rarely needed if using Firebase handlers)
      // onDidReceiveBackgroundNotificationResponse: _onDidReceiveBackgroundNotificationResponse,
    );
  }

  // --- Message Handling Setup ---
  void _setupMessageHandlers() {
    // 1. Handle messages received while the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground Message data: ${message.data}');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      // If `onMessage` is triggered with a notification payload, display it using flutter_local_notifications
      if (notification != null && android != null) {
        print('Message also contained a notification: ${notification.title}');
        flutterLocalNotificationsPlugin.show(
          notification.hashCode, // Use a unique ID for the notification
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id, // Use the channel ID created earlier
              channel.name,
              channelDescription: channel.description,
              icon: '@mipmap/ic_launcher', // Use default app icon
              importance: Importance.high,
              priority: Priority.high,
              playSound: true,
            ),
            iOS: const DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
          // Use data payload for navigation route, fallback to body
          payload: message.data['route'] as String? ?? notification.body,
        );
      } else if (message.data.isNotEmpty) {
        // Handle foreground data-only messages if needed (e.g., show a custom local notification)
        print("Foreground Data-only message received: ${message.data}");
        // Example: _showLocalNotificationFromData(message.data);
      }
    });

    // 2. Handle notification taps when the app is opened from the background state
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationTap(message);
    });

    // 3. Handle notification taps when the app is opened from the terminated state
    FirebaseMessaging.instance.getInitialMessage().then((
      RemoteMessage? message,
    ) {
      if (message != null) {
        print('Message opened from terminated: ${message.notification?.title}');
        // Schedule navigation after the first frame to ensure GetX is ready
        Future.delayed(Duration.zero, () => _handleNotificationTap(message));
      }
    });

    // Listen for token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen(onFcmTokenUpdate);
  }

  // --- Notification Interaction Handling ---

  // Handles taps originating from Firebase background/terminated notifications
  void _handleNotificationTap(RemoteMessage message) {
    // Extract navigation data or relevant info. Prioritize 'data' payload.
    String? navigationArgument = message.notification?.body;

    if (navigationArgument != null) {
      // Use GetX navigation. Check if GetX is ready before navigating.
      if (Get.isPrepared<dynamic>()) {
        Get.toNamed(Routes.ALERT, arguments: navigationArgument);
      } else {
        // If GetX isn't ready (might happen from getInitialMessage), wait briefly.
        Future.delayed(const Duration(milliseconds: 500), () {
          Get.toNamed(Routes.ALERT, arguments: navigationArgument);
        });
      }
    } else {
      print("No navigation argument found in notification.");
      // Optionally navigate to a default screen like HOME
      // Get.toNamed(Routes.HOME);
    }
  }

  // Handles taps on local notifications shown by flutter_local_notifications (usually foreground)
  void _onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse,
  ) {
    final String? payload = notificationResponse.payload;
    if (payload != null && payload.isNotEmpty) {
      Get.toNamed(Routes.ALERT, arguments: payload);
    } else {
      print("Local notification payload is null or empty.");
      // Optionally navigate to a default screen
      // Get.toNamed(Routes.HOME);
    }
  }
}
