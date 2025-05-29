import 'package:get/get.dart';

import '../data/middleware/auth_gard.dart';
import '../modules/about/views/about_view.dart';
import '../modules/alert/bindings/alert_binding.dart';
import '../modules/alert/views/alert_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/notificationDetail/bindings/notification_detail_binding.dart';
import '../modules/notificationDetail/views/notification_detail_view.dart';
import '../modules/profil/bindings/profil_binding.dart';
import '../modules/profil/views/profil_view.dart';
import '../modules/registration/bindings/registration_binding.dart';
import '../modules/registration/views/registration_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.REGISTRATION;

  static final routes = [
    GetPage(
      name: _Paths.REGISTRATION,
      page: () => const RegistrationView(),
      binding: RegistrationBinding(),
      middlewares: [CheckNotAuthentificated()],
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      middlewares: [CheckAuthentificated()],
    ),
    GetPage(
      name: _Paths.ALERT,
      page: () => const AlertView(),
      binding: AlertBinding(),
      // middlewares: [CheckAuthentificated()],
    ),
    GetPage(
      name: _Paths.PROFIL,
      page: () => const ProfilView(),
      binding: ProfilBinding(),
      middlewares: [CheckAuthentificated()],
    ),
    GetPage(
      name: _Paths.NOTIFICATION_DETAIL,
      page: () => const NotificationDetailView(),
      binding: NotificationDetailBinding(),
      middlewares: [CheckAuthentificated()],
    ),
    GetPage(
      name: _Paths.ABOUT,
      page: () => const AboutView(),
      middlewares: [CheckAuthentificated()],
    ),
  ];
}
