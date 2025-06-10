import 'package:alert_app/app/core/utils/app_utility.dart'
    show TypeMessage, showMsg;
import 'package:get/get.dart';

import '../core/actions/try_catch.dart' show tryCatch;
import '../core/utils/api_helper/core_service.dart' show CoreService;
import 'models/server_response_model.dart' show ServerResponseModel;

class AppServicesProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = 'https://alerte-couronne.ehaiti.ht/api';
    httpClient.timeout = const Duration(seconds: 15);
    httpClient.defaultDecoder = (body) {
      return ServerResponseModel.fromMap(body ?? {"statusCode": 404});
    };
  }

  Future<ServerResponseModel?> registerDevice({
    required Map<String, String> params,
  }) async {
    var response = await tryCatch(() async {
      var response = await post("/register-device", params);
      return CoreService.returnResponse(response);
    });
    return response;
  }

  Future<ServerResponseModel?> listSitesAPI() async {
    var response = await tryCatch(() async {
      var response = await get("/public/sites");
      return CoreService.returnResponse(response);
    });
    return response;
  }

  Future<ServerResponseModel?> deleteAccount(String id) async {
    var response = await tryCatch(() async {
      var response = await delete("/public/devices/$id");
      return CoreService.returnResponse(response);
    });
    return response;
  }
}
