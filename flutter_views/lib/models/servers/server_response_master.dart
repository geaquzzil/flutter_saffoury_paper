import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract_api.dart';
import 'package:json_annotation/json_annotation.dart';

import 'server_response.dart';

part 'server_response_master.g.dart';

@JsonSerializable(explicitToJson: true)
class ServerResponseMaster {
  ServerResponse serverResponse;
  ServerResponseMaster(this.serverResponse);

  factory ServerResponseMaster.fromJson(Map<String, dynamic> data) =>
      _$ServerResponseMasterFromJson(data);

  Map<String, dynamic> toJson() => _$ServerResponseMasterToJson(this);

  ///this is th
  String getFailureMessage() {
    debugPrint("getFailureMessage ===> ${toJson()}");
    bool isLogin = serverResponse.login ?? false;
    bool isBlocked = serverResponse.activated == 0;
    bool notHasPermission = serverResponse.permission ?? false;
    bool error = serverResponse.error ?? false;
    if (isBlocked) {
      ///todo translate
      return "Your account has been blocked, please contact support";
    } else if (!isLogin) {
      ///todo translate
      return "You are not logged in";
    } else if (!notHasPermission) {
      ///todo translate
      return "You do not have permission to perform this action";
    } else if (error) {
      //TODO translate
      return "An error occurred while trying to perform this action => ${serverResponse.message}";
    }
    return "An unknown error occurred";
  }
}
