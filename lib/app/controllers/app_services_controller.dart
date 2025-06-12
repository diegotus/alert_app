import 'dart:io';

import 'package:alert_app/app/core/utils/storage_box.dart';
import 'package:alert_app/app/data/app_services_provider.dart'
    show AppServicesProvider;
import 'package:alert_app/app/routes/app_pages.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:eraser/eraser.dart';
import 'package:flutter/services.dart' show SystemChannels;
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:vibration/vibration.dart';

import '../core/utils/app_utility.dart' show TypeMessage, showMsg;
import '../data/models/site_model.dart' show SiteModel, listSiteModel;

class AppServicesController extends FullLifeCycleController
    with FullLifeCycleMixin {
  late final AppServicesProvider provider;
  String get id => StorageBox.id.val;
  String get name => StorageBox.name.val;
  String get phone => StorageBox.phone.val;
  String get site => StorageBox.site.val;
  late final RxString errorMsg;
  Worker? errorWorker;
  final AudioPlayer _audioPlayer = AudioPlayer();
  PlayerState get audioPlayerState => _audioPlayer.state;
  @override
  void onResumed() {
    Eraser.clearAllAppNotifications();
  }

  @override
  void onInactive() {
    stopAlert();
  }

  @override
  void onDetached() {
    stopAlert();
  }

  @override
  void onInit() {
    errorMsg = RxString("");
    errorWorker = ever(errorMsg, (msg) {
      showMsg(msg, type: TypeMessage.error);
    }, condition: () => errorMsg.isNotEmpty);
    provider = Get.put(AppServicesProvider(), permanent: true);
    super.onInit();
  }

  onClosed() {
    stopAlert();
    errorWorker?.dispose();
    super.onClose();
  }

  Future<List<SiteModel>> callListSitesAPI() async {
    print("the on Data ");
    final response = await provider.listSitesAPI();

    if (response?.isSuccess == true) {
      return listSiteModel(response!.data);
    } else {
      return Future.error(response?.getMessage() ?? '');
    }
  }

  Future<void> startAlert([bool clear = false]) async {
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(
      AssetSource('sounds/notification_sound.mp3'),
      volume: 10000,
      mode: PlayerMode.mediaPlayer,
    );
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(pattern: [500, 1000, 500, 1000], repeat: 0);
    }
    if (clear) {
      // await Eraser.clearAllAppNotifications();
    }
  }

  Future<void> stopAlert([bool isIntent = false]) async {
    if (_audioPlayer.state == PlayerState.playing) {
      await _audioPlayer.stop();
      await Vibration.cancel();
      if (isIntent) {
        Platform.isIOS
            ? exit(0)
            : await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      } else if (Get.context != null && Navigator.canPop(Get.context!)) {
        Get.back();
      } else {
        Get.offAndToNamed(Routes.HOME);
      }
    }
  }

  @override
  void onHidden() {
    // TODO: implement onHidden
  }

  @override
  void onPaused() {
    // TODO: implement onPaused
  }

  Future<void> clear() async {
    await StorageBox.clearData();
  }
}
