// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;

class Url {
  static final String _url =
      !kDebugMode
          ? ((kIsWeb || Platform.isAndroid)
              ? "http://localhost:3000/"
              : "http://10.0.2.2:3000/")
          : kIsWeb
          ? "${Uri.base.origin}/"
          : "https://alertes.ehaiti.ht/";
  static final String BASE_URL = _url;
  static final String SOCKET_URL = "${BASE_URL}chat_socket";
}
