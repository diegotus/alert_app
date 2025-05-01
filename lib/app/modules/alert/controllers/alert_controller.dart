import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:vibration/vibration.dart' show Vibration;

class AlertController extends GetxController {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  onInit() {
    _triggerAlert();
    super.onInit();
  }

  Future<void> _triggerAlert() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(
      AssetSource('sounds/EmergencyAlertSystem.mp3'),
      volume: 10000,
      mode: PlayerMode.mediaPlayer,
    );
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(pattern: [500, 1000, 500, 1000], repeat: 0);
    }
  }

  Future<void> stopAlert() async {
    await _audioPlayer.stop();
    await Vibration.cancel();
    Get.back();
  }

  @override
  void onClose() async {
    await stopAlert();
    super.onClose();
  }
}
