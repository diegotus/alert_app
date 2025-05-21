import 'dart:io' show Platform;

import 'package:alert_app/app/controllers/app_services_controller.dart';
import 'package:alert_app/app/core/utils/app_utility.dart';
import 'package:alert_app/app/core/utils/device_id.dart';
import 'package:alert_app/app/core/utils/storage_box.dart';
import 'package:alert_app/app/data/app_services_provider.dart';
import 'package:alert_app/app/routes/app_pages.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../data/models/site_model.dart';

class RegistrationController extends GetxController {
  final formKey = GlobalKey<FormState>();
  late final AppServicesProvider provider;
  Future<List<SiteModel>> Function() get callListApi =>
      Get.find<AppServicesController>().callListSitesAPI;
  final count = 0.obs;

  String id = '';
  String name = '';
  String phone = '';
  String site = '';
  String? fcmToken;

  @override
  void onInit() {
    provider = Get.find<AppServicesProvider>();
    super.onInit();
  }

  Future<void> registerUser() async {
    final platform =
        kIsWeb
            ? "Web"
            : Platform.isAndroid
            ? 'android'
            : 'ios';
    if (StorageBox.id.val.isEmpty) {
      id = await DeviceID.deviceUUID();
    }
    final response = await provider.registerDevice(
      params: {
        'id': id,
        'name': name,
        'phone': phone,
        'token': StorageBox.fmcToken.val,
        'platform': platform,
        'site': site,
      },
    );

    if (response?.isSuccess == true) {
      await _saveProfileToStorage();
      showMsg(
        "Utilisateur enregistré avec succès !",
        type: TypeMessage.success,
      ).future;

      Get.offAllNamed(Routes.HOME);
    } else {
      // showMsg('Registration failed.', type: TypeMessage.error);
    }
  }

  Future<void> _saveProfileToStorage() async {
    StorageBox.id.val = id;
    StorageBox.name.val = name;
    StorageBox.phone.val = phone;
    StorageBox.site.val = site;
  }
}
