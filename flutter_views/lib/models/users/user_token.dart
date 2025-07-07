import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/models/request_options.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract_api.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class UserToken extends ViewAbstractApi<UserToken> {
  @JsonKey(includeFromJson: false, includeToJson: false)
  AuthUser? auth;

  String? token;
  UserToken() : super();

  @override
  String? getCustomAction() {
    return "${auth!.getTableNameApi()}/token";
  }

  @override
  Map<String, IconData> getFieldIconDataMap() => {};

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {};

  @override
  String? getMainDrawerGroupName(BuildContext context) => "";

  @override
  List<String> getMainFields({BuildContext? context}) => ["token"];

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) => "";

  @override
  String getMainHeaderTextOnly(BuildContext context) => "";

  @override
  IconData getMainIconData() => Icons.abc;

  @override
  getSelfNewInstance() => this;

  @override
  String? getTableNameApi() => null;

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'token': token});

    return result;
  }

  factory UserToken.fromMap(Map<String, dynamic> map) {
    return UserToken(
    );
  }

  String toJson() => json.encode(toMap());

  factory UserToken.fromJson(String source) =>
      UserToken.fromMap(json.decode(source));

  @override
  UserToken fromJsonViewAbstract(Map<String, dynamic> json) =>
      UserToken.fromMap(json);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toMap();

  @override
  RequestOptions? getRequestOption({required ServerActions action}) {
    return null;
  }

  @override
  List<String>? getRequestedForginListOnCall({required ServerActions action}) {
    return null;
  }
}
