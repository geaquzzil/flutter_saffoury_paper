import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract_api.dart';

class UserToken extends ViewAbstractApi<UserToken> {
  String token;
  UserToken({required this.token}) : super();

  @override
  Map<String, String> get getCustomMap => {"token": token};
  @override
  String? getCustomAction() {
    return "token";
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
      token: map['token'] ?? '',
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
}
