import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/permissions/permission_level_abstract.dart';
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

  PermissionLevelAbstract? userlevels;

  AuthUser({bool? setPassword}) : super() {
    if (setPassword ?? false) {
      setRandomPassword();
    }
  }
  @override
  String? getCustomAction() {
    return "login_flutter";
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
  List<String> getMainFields() {
    return ["login", "permissions", "response"];
  }

  @override
  IconData getMainIconData() {
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

  @override
  Map<String, IconData> getFieldIconDataMap() {
    // TODO: implement getFieldIconDataMap
    throw UnimplementedError();
  }

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) {
    // TODO: implement getFieldLabelMap
    throw UnimplementedError();
  }

  @override
  String getMainHeaderTextOnly(BuildContext context) {
    // TODO: implement getMainHeaderTextOnly
    throw UnimplementedError();
  }

  @override
  String getMainLabelSubtitleTextOnly(BuildContext context) {
    // TODO: implement getMainLabelSubtitleTextOnly
    throw UnimplementedError();
  }

  @override
  Map<String, String> getTextInputHintMap(BuildContext context) {
    // TODO: implement getTextInputHintMap
    throw UnimplementedError();
  }

  @override
  Map<String, IconData> getTextInputIconMap() {
    // TODO: implement getTextInputIconMap
    throw UnimplementedError();
  }

  @override
  Map<String, bool> getTextInputIsAutoCompleteMap() {
    // TODO: implement getTextInputIsAutoCompleteMap
    throw UnimplementedError();
  }

  @override
  Map<String, bool> getTextInputIsAutoCompleteViewAbstractMap() {
    // TODO: implement getTextInputIsAutoCompleteViewAbstractMap
    throw UnimplementedError();
  }

  @override
  Map<String, String> getTextInputLabelMap(BuildContext context) {
    // TODO: implement getTextInputLabelMap
    throw UnimplementedError();
  }

  @override
  Map<String, int> getTextInputMaxLengthMap() {
    // TODO: implement getTextInputMaxLengthMap
    throw UnimplementedError();
  }

  @override
  Map<String, double> getTextInputMaxValidateMap() {
    // TODO: implement getTextInputMaxValidateMap
    throw UnimplementedError();
  }

  @override
  Map<String, double> getTextInputMinValidateMap() {
    // TODO: implement getTextInputMinValidateMap
    throw UnimplementedError();
  }

  @override
  Map<String, TextInputType?> getTextInputTypeMap() {
    // TODO: implement getTextInputTypeMap
    throw UnimplementedError();
  }

  @override
  Map<String, bool> isFieldCanBeNullableMap() {
    // TODO: implement isFieldCanBeNullableMap
    throw UnimplementedError();
  }

  @override
  Map<String, bool> isFieldRequiredMap() {
    // TODO: implement isFieldRequiredMap
    throw UnimplementedError();
  }
  
  @override
  String getMainHeaderLabelTextOnly(BuildContext context) {
    // TODO: implement getMainHeaderLabelTextOnly
    throw UnimplementedError();
  }
}
