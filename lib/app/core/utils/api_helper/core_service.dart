// ignore_for_file: unused_catch_clause, constant_identifier_names, prefer_typing_uninitialized_variables, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/server_response_model.dart'
    show ServerResponseModel;
import 'app_exception.dart';

class CoreService {
  static ServerResponseModel returnResponse(Response response) {
    debugPrint("API Request : ${response.statusText}");
    debugPrint("API Response : ${response.body} ");
    debugPrint("API Response url: ${response.request?.url} ");
    var body = response.body;
    switch (response.statusCode) {
      case 200:
      case 201:
      case 422:
      case 403:
        if (body != null) {
          var responseJson = body;

          return responseJson!;
        }
        return ServerResponseModel(
          statusCode: response.statusCode!,
          error: response.statusText,
          message: [
            "Une erreur s'est produite lors de la communication avec le serveur",
            'StatusCode :${response.statusCode}',
          ],
        );
      case 400:
      case 404:
        throw BadRequestException((body as ServerResponseModel).getMessage());
      case 401:
        // final StorageLocalService storageLocalService = StorageLocalService();

        // storageLocalService.setAuthTokenSF(authToken: "");
        // storageLocalService.setUserIdSF(value: 0);
        // storageLocalService.setUserNameSF(name: "");

        if (body is ServerResponseModel &&
            body.getMessage() == 'Not authenticated') {
          throw UnauthorisedException.userNotLogin();
        }

        throw UnauthorisedException(body.getMessage());
      case 500:
      default:
        throw FetchDataException(
          'Une erreur s\'est produite lors de la communication avec le serveur ${response.statusCode == null ? '' : 'avec StatusCode :${response.statusCode}'}',
        );
    }
  }
}
