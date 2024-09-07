import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/services/text_input.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/icon_data.dart';
import 'package:flutter_view_controller/interfaces/notification_interface.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/v_non_view_object.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:provider/provider.dart';

part 'notifications.g.dart';

@reflector
@JsonSerializable(explicitToJson: true)
class NotificationsClinet extends VObject<NotificationsClinet>
    implements NotificationHandlerInterface {
  String? json;
  String? tokens;
  String? date;
  NotificationsClinet();

  factory NotificationsClinet.fromJson(Map<String, dynamic> data) =>
      _$NotificationsClinetFromJson(data);

  @override
  Map<String, dynamic> toJson() => _$NotificationsClinetToJson(this);

  @override
  NotificationsClinet fromJsonViewAbstract(Map<String, dynamic> json) {
    return NotificationsClinet.fromJson(json);
  }

  @override
  NotificationsClinet getSelfNewInstance() => NotificationsClinet();
  @override
  Map<String, dynamic> toJsonViewAbstract() {
    return toJson();
  }

  @override
  ViewAbstract getObject(BuildContext context) {
    // debugPrint("notifciation token: $tokens");
    final jsonD = jsonDecode(json!);

    // debugPrint("notification tableName is ${jsonD['message']['type']}");
    // debugPrint("notification object is ${jsonD['message']['object']}");
    ViewAbstract? v = context
        .read<AuthProvider<AuthUser>>()
        .getNewInstance(jsonD['type'] as String);
    v = v!.fromJsonViewAbstract(jsonDecode(jsonD['object']));

    debugPrint("notification ViewAbstract is $v");
    return v!;
  }

  @override
  String? getTableNameApi() => "notifications";
}
