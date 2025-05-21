import 'package:alert_app/app/core/utils/storage_box.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/parse_route.dart';

import '../../controllers/app_services_controller.dart';
import '../../routes/app_pages.dart';

class CheckAuthentificated extends GetMiddleware {
  @override
  int get priority => 0;
  AppServicesController get appService => Get.find<AppServicesController>();

  @override
  RouteSettings? redirect(String? route) {
    //NEVER navigate to auth screen, when user is already authed
    if (StorageBox.id.val.isEmpty) {
      return RouteSettings(name: Routes.REGISTRATION);

      //OR redirect user to another screen
      //return RouteDecoder.fromRoute(Routes.PROFILE);
    }
    return null;
  }
}

class CheckNotAuthentificated extends GetMiddleware {
  @override
  int get priority => 0;
  AppServicesController get appService => Get.find<AppServicesController>();

  @override
  RouteSettings? redirect(String? route) {
    //NEVER navigate to auth screen, when user is already authed
    if (StorageBox.id.val.isNotEmpty) {
      return RouteSettings(name: Routes.HOME);
    }
    return null;
  }
}
