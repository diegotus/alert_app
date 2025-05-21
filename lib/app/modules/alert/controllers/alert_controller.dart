import 'package:alert_app/app/controllers/app_services_controller.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:eraser/eraser.dart';
import 'package:firebase_notifications_handler/firebase_notifications_handler.dart';
import 'package:get/get.dart';
import 'package:vibration/vibration.dart' show Vibration;

class AlertController extends GetxController {
  AlertController({this.autoStart = true});
  AppServicesController get appService => Get.find<AppServicesController>();

  final bool autoStart;
  @override
  onInit() {
    print("sound played init ${Get.currentRoute}");

    super.onInit();
  }

  @override
  onReady() {
    if (autoStart) _triggerAlert(true);
    super.onStart();
  }

  get triggerAlert => _triggerAlert();
  Future<void> _triggerAlert([bool clear = false]) async {
    appService.startAlert();
    if (clear) {
      await Eraser.clearAllAppNotifications();
    }
  }

  Future<void> stopAlert([bool clear = false]) async {
    appService.stopAlert(Get.parameters['isIntent'] == "true");
  }

  @override
  void onClose() async {
    await appService.stopAlert();
    super.onClose();
  }
}
