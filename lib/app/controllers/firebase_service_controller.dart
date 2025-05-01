import 'package:alert_app/app/core/utils/storage_box.dart';
import 'package:alert_app/app/routes/app_pages.dart';
import 'package:alert_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_notifications_handler/firebase_notifications_handler.dart';
import 'package:get/get.dart';

class FirebaseServices extends GetxService {
  FirebaseServices._onInit({this.token});
  String? token;
  // String get currentSubscriveTopic => StorageBox.currentSubscriveTopic.val;
  void onFcmTokenInitialize(String? value) {
    StorageBox.fmcToken.val = value ?? '';
    token = value ?? '';
  }

  void onFcmTokenUpdate(String value) {
    print("the token $value");
    // StorageBox.fmcToken.val = value;
    token = value;
  }

  static RemoteMessage messageModifier(RemoteMessage message) {
    return message;
  }

  bool shouldHandleNotification(RemoteMessage message) {
    return true;
  }

  void onOpenNotificationArrive(NotificationInfo notif, {bool taped = false}) {
    print("notif is opend");
    switch (notif.appState) {
      case AppState.terminated:
      case AppState.background:
        continue openNotif;
      openNotif:
      case AppState.open:
        onMessage(notif.firebaseMessage.notification?.body);
        break;
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
    return FirebaseServices._onInit(token: '');
  }

  static Future<void> permissionGetter(FirebaseMessaging fcMsg) async {
    var fcmStatus = await fcMsg.getNotificationSettings();
    if (fcmStatus.authorizationStatus == AuthorizationStatus.notDetermined) {
      fcmStatus = await fcMsg.requestPermission();
    }
    _createChanel();
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
            'transfer',
            'transfer',
            importance: Importance.high,
          ),
          AndroidNotificationChannel(
            'lotoPlay',
            'lotoPlay',
            importance: Importance.low,
          ),
          AndroidNotificationChannel(
            'lotoWin',
            'lotoWin',
            importance: Importance.high,
          ),
          AndroidNotificationChannel(
            'cash',
            'cash',
            importance: Importance.high,
          ),
          AndroidNotificationChannel(
            'payment',
            'payment',
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
