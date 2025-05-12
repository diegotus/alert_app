import 'package:alert_app/app/core/utils/storage_box.dart';
import 'package:alert_app/app/routes/app_pages.dart';
import 'package:alert_app/firebase_options.dart';
import 'package:audioplayers/audioplayers.dart'
    show AssetSource, AudioPlayer, ReleaseMode;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_notifications_handler/firebase_notifications_handler.dart';
import 'package:get/get.dart';
import 'package:vibration/vibration.dart';

import 'notification_controller_test.dart'
    show
        firebaseMessagingBackgroundHandler2,
        firebaseMessagingBackgroundHandler,
        flutterLocalNotificationsPlugin;

typedef OnTapGetter = void Function(String? details);

class FirebaseServices extends GetxService {
  FirebaseServices._onInit({this.token});
  String? token;
  // String get currentSubscriveTopic => StorageBox.currentSubscriveTopic.val;
  void onFcmTokenInitialize(String? token) {
    StorageBox.fmcToken.val = token ?? '';
    this.token = token ?? '';
  }

  void onFcmTokenUpdate(String token) {
    print("the token $token");

    StorageBox.fmcToken.val = token;
    this.token = token;
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler2);
  }

  static RemoteMessage messageadModifier(RemoteMessage message) {
    return message;
  }

  bool shouldHandleNotification(RemoteMessage message) {
    // if(message)
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
        onMessage!.call(notif.firebaseMessage.notification?.body);
        break;
    }
  }

  static RemoteMessage messageModifier(RemoteMessage message) {
    return message;
  }

  static OnTapGetter? onMessage;

  static Future<FirebaseServices> initFirebase() async {
    onMessage = (String? message) {
      if (message != null) {
        Get.toNamed(Routes.ALERT, arguments: message);
        // _playSoundInfinitely();
      }
    };
    var app = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    return FirebaseServices._onInit(token: '');
  }

  static Future<void> permissionGetter(FirebaseMessaging fcMsg) async {
    var fcmStatus = await fcMsg.getNotificationSettings();
    fcmStatus = await fcMsg.requestPermission(
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    _createChanel();
    // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler2);
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
            importance: Importance.max,
            description: "default channel",
            // sound: RawResourceAndroidNotificationSound(''),
          ),
        ],
      );
    }
  }

  @override
  void onInit() {
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

  bool _isPlayingSound = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  Future<void> _playSoundInfinitely() async {
    if (!_isPlayingSound) {
      _isPlayingSound = true;
      await _audioPlayer.setSource(
        AssetSource('sounds/notification_sound.mp3'),
      ); // Adjust path
      _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.play(AssetSource('sounds/notification_sound.mp3'));
    }
  }

  Future<void> stopSound() async {
    if (_isPlayingSound) {
      _isPlayingSound = false;
      await _audioPlayer.stop();
      await Vibration.cancel(); // Cancel vibration
    }
    // currentNotificationId = null; // Clear the current notification ID
  }
}
