import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum TypeMessage { error, success, info, other }

SnackbarController showMsg(String msg, {Color? color, TypeMessage? type}) {
  Color? background;
  switch (type) {
    case TypeMessage.error:
      background = Colors.red;
      break;
    case TypeMessage.success:
      background = Colors.green;
    case TypeMessage.info:
      background = Colors.yellow;
    default:
      background = color;
  }
  return Get.showSnackbar(
    GetSnackBar(
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: background ?? Colors.green,
      duration: const Duration(seconds: 3),
      borderRadius: 10,
      messageText: Text.rich(
        TextSpan(text: msg),
        style: TextStyle(color: Colors.white),
      ),
      margin: const EdgeInsets.fromLTRB(20, 5, 20, 20),
    ),
  );
}

hideKeyboard() {
  return FocusManager.instance.primaryFocus?.unfocus();
}
