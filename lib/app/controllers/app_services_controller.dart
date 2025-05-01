import 'package:alert_app/app/core/utils/storage_box.dart';
import 'package:alert_app/app/data/app_services_provider.dart'
    show AppServicesProvider;
import 'package:get/get.dart';

import '../core/utils/app_utility.dart' show TypeMessage, showMsg;
import '../data/models/site_model.dart' show SiteModel, listSiteModel;

class AppServicesController extends GetxService {
  late final AppServicesProvider provider;
  String get id => StorageBox.id.val;
  String get name => StorageBox.name.val;
  String get phone => StorageBox.phone.val;
  String get site => StorageBox.site.val;
  late final RxString errorMsg;
  Worker? errorWorker;

  @override
  void onInit() {
    errorMsg = RxString("");
    errorWorker = ever(errorMsg, (msg) {
      showMsg(msg, type: TypeMessage.error);
    }, condition: () => errorMsg.isNotEmpty);
    provider = Get.put(AppServicesProvider(), permanent: true);
    super.onInit();
  }

  Future<List<SiteModel>> callListSitesAPI() async {
    final response = await provider.listSitesAPI();

    if (response?.isSuccess == true) {
      return listSiteModel(response!.data);
    } else {
      return Future.error(response?.getMessage() ?? '');
    }
  }
}
