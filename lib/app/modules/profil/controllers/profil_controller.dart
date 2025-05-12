import 'dart:io';

import 'package:alert_app/app/core/utils/formater.dart';
import 'package:alert_app/app/routes/app_pages.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' show FormState, GlobalKey;
import 'package:get/get.dart';

import '../../../core/utils/app_utility.dart' show TypeMessage, showMsg;
import "../../../data/app_services_provider.dart";
import '../../../controllers/app_services_controller.dart';
import '../../../core/utils/storage_box.dart';
import '../../../data/models/site_model.dart';
import '../../../data/models/user_model.dart';

class ProfilController extends GetxController {
  late final AppServicesController appService;
  late final Rx<UserModel> user;
  final formKey = GlobalKey<FormState>();
  List<SiteModel> get listSite =>
      StorageBox.sites.val.map((el) => SiteModel.fromJson(el)).toList();
  Future<List<SiteModel>> Function() get callListApi =>
      appService.callListSitesAPI;

  AppServicesProvider get provider =>
      Get.find<AppServicesController>().provider;

  @override
  void onInit() {
    appService = Get.find<AppServicesController>();
    user = Rx(
      UserModel(
        id: appService.id,
        name: appService.name,
        phone: appService.phone,
        site: appService.site,
        token: StorageBox.fmcToken.val,
      ),
    );

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void resetUser() {
    var phone = user.value.phone;
    user.update((user) {
      user?.id = appService.id;
      user?.name = appService.name;
      user?.phone = appService.phone;
      user?.site = appService.site;
      user?.token = StorageBox.fmcToken.val;
    });
    formKey.currentState?.reset();
    // phoneFormatter.clear();
    phoneFormatter.formatEditUpdate(
      TextEditingValue.empty,
      TextEditingValue(text: appService.phone.replaceAll("+509", "")),
    );
  }

  bool hasChanges() {
    return user.value !=
        user.value.copyWith(
          id: StorageBox.id.val,
          name: StorageBox.name.val,
          phone: StorageBox.phone.val,
          site: StorageBox.site.val,
        );
  }

  Future<void> updateUser() async {
    if (formKey.currentState?.validate() == true) {
      final platform = Platform.isAndroid ? 'android' : 'ios';
      final response = await provider.registerDevice(
        params: {
          'id': user.value.id!,
          'name': user.value.name,
          'phone': user.value.phone,
          'token': StorageBox.fmcToken.val,
          'platform': platform,
          'site': user.value.site,
        },
      );

      if (response?.isSuccess == true) {
        user.value.saveToBox();
        user.refresh();
        update(['form_Widget']);
        await showMsg(
          'User Updated Successfully!\nN.B: The App will automatically close.',
          type: TypeMessage.success,
        ).future;
        if (!kDebugMode) {
          await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        }
      }
    }
  }
}
