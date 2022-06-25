import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_auth.g.dart';

@JsonSerializable()
class AuthUser<T> extends ViewAbstract<AuthUser> {
  bool? login;
  bool? permission;
  int? response;
  String? phone;
  String? password;

  AuthUser({bool? setPassword}) : super() {
    if (setPassword ?? false) {
      setRandomPassword();
    }
  }
  @override
  String? getCustomAction() {
    return "login";
  }

  void set(String key, dynamic v) {
    gets()[key] = v;
  }

  Map<String, dynamic> gets() {
    return {"login": login};
  }

  void setRandomPassword() {
    const alphabet =
        "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890";
    Random r = Random();
    password = String.fromCharCodes(Iterable.generate(alphabet.length,
        (_) => alphabet.codeUnitAt(r.nextInt(alphabet.length))));
  }

  factory AuthUser.fromJson(Map<String, dynamic> data) =>
      _$AuthUserFromJson(data);

  Map<String, dynamic> toJson() => _$AuthUserToJson(this);

  @override
  AuthUser fromJsonViewAbstract(Map<String, dynamic> json) {
    return AuthUser.fromJson(json);
  }

  @override
  IconData getFieldIconData(String label) {
    // TODO: implement getFieldIconData
    throw UnimplementedError();
  }

  @override
  String getFieldLabel(String label, BuildContext context) {
    return "";
  }

  @override
  List<String> getFields() {
    return ["login", "permissions", "response"];
  }

  @override
  IconData getIconData() {
    return Icons.nat;
  }

  @override
  String? getTableNameApi() {
    return "";
  }

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    return toJson();
  }
}
