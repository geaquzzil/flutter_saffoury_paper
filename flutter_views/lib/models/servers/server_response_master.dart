import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import'package:flutter_gen/gen_l10n/app_localization.dart';

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
  String getFailureMessage(BuildContext context) {
    debugPrint("getFailureMessage ===> ${toJson()}");
    bool isLogin = serverResponse.login ?? false;
    bool isBlocked = serverResponse.activated == 0;
    bool notHasPermission = serverResponse.permission ?? false;
    bool error = serverResponse.error ?? false;
    if (isBlocked) {
      return AppLocalizations.of(context)!.blockDes;
    
      ///
      return "Your account has been blocked, please contact support";
    } else if (!isLogin) {
          return AppLocalizations.of(context)!.youAreNotLog;
      return "You are not logged in";
    } else if (!notHasPermission) {
         return AppLocalizations.of(context)!.youDontHavePermission;
    
      ///
      return "You do not have permission to perform this action";
    } else if (error) {
        return"${AppLocalizations.of(context)!.errorOccured} => ${serverResponse.message}";
  
      return "An error occurred while trying to perform this action => ${serverResponse.message}";
    }
           return AppLocalizations.of(context)!.errorUnknown;
    
    return "An unknown error occurred";
  }
}
