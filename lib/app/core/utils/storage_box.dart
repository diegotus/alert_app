import 'package:get_storage/get_storage.dart';

mixin StorageBox {
  static GetStorage boxKeys() => GetStorage('userData');
  static final id = ''.val("id", getBox: boxKeys);
  static final name = ''.val("name", getBox: boxKeys);
  static final phone = ''.val("phone", getBox: boxKeys);
  static final site = ''.val("site", getBox: boxKeys);
  static final fmcToken = ''.val("fmcToken", getBox: boxKeys);
  static final sites = [].val("sites", getBox: boxKeys);
  static final notifactions = [].val("notifications", getBox: boxKeys);

  static Future<void> removeToken() async {
    await boxKeys().remove('token');
  }

  static Future<void> clearData() async {
    await boxKeys().remove('id');
    await boxKeys().remove('name');
    await boxKeys().remove('phone');
    await boxKeys().remove('site');
    await boxKeys().remove('notifications');
  }

  static saveData(String key, data) async {
    await boxKeys().write(key, data);
  }
}
