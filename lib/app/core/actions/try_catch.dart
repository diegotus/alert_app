import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';

import '../../controllers/app_services_controller.dart'
    show AppServicesController;
import '../utils/api_helper/app_exception.dart'
    show BadRequestException, FetchDataException, UnauthorisedException;
import '../utils/app_utility.dart' show showMsg;

FutureOr<T?> tryCatch<T>(FutureOr<T> Function() doaction) async {
  final appService = Get.find<AppServicesController>();
  try {
    appService.errorMsg.value = '';
    await Future.delayed(const Duration(seconds: 1));
    var response = await doaction();
    return response;
  } on FetchDataException catch (e) {
    appService.errorMsg.value = e.getMessage();
    // showMsg(e.getMessage(), color: Colors.red);
    // print("the response 2 ${e.getMessage()}");
    // throw e;
  } on BadRequestException catch (e) {
    appService.errorMsg.value = e.getMessage();
  } on UnauthorisedException catch (e) {
    appService.errorMsg.value = e.getMessage();
  } catch (e) {
    e.printError();
    Get.log("its an error $e", isError: true);
    appService.errorMsg.value = "Erreur inconnue : $e";

    showMsg("Erreur inconnue : $e", color: Colors.red);

    // throw e;
  }
  return null;
}
