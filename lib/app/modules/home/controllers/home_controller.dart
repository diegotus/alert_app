import 'package:alert_app/app/core/utils/storage_box.dart' show StorageBox;
import 'package:alert_app/app/data/models/notification_model.dart'
    show NotificationModel;
import 'package:get/get.dart';

class HomeController extends GetxController {
  final listNotification = RxList<NotificationModel>([]);
  @override
  void onInit() {
    var listNotif =
        StorageBox.notifactions.val
            .map((el) => NotificationModel.fromJson(el))
            .toList();
    listNotif.sortIt();
    listNotification.addAll(listNotif);
    StorageBox.boxKeys().listenKey("notifications", (value) {
      var listNotif =
          (value as List).map((el) => NotificationModel.fromJson(el)).toList();
      listNotif.sortIt();
      listNotification.assignAll(listNotif);
    });

    super.onInit();
  }
}

extension NotificationModelSort on List<NotificationModel> {
  void sortIt() {
    sort(
      (a, b) => b.date.microsecondsSinceEpoch.compareTo(
        a.date.microsecondsSinceEpoch,
      ),
    );
  }
}
