import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/permissions/permission_level_abstract.dart';
import 'package:flutter_view_controller/models/permissions/setting.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:rxdart/rxdart.dart';

import '../dealers/dealer.dart';
import '../servers/server_helpers.dart';

part 'user_auth.g.dart';

@reflector
class AuthUserLogin extends AuthUser<AuthUserLogin> {
  AuthUserLogin() : super(setPassword: false);
  @override
  List<String> getMainFields({BuildContext? context}) {
    return [
      "phone",
      "password",
    ];
  }

  @override
  String getFieldToReduceSize() {
    return "name";
  }

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {
        "phone": AppLocalizations.of(context)!.user_name,
        "password": AppLocalizations.of(context)!.password,
      };

  @override
  Map<String, bool> getTextInputIsAutoCompleteMap() => {};
  @override
  Map<String, int> getTextInputMaxLengthMap() => {};

  @override
  String? getCustomAction() {
    return "login_flutter";
  }

  @override
  Map<String, IconData> getFieldIconDataMap() => {
        "phone": Icons.radio_button_unchecked_sharp,
        "password": Icons.password,
      };

  @override
  String getMainHeaderTextOnly(BuildContext context) => "";

  @override
  Map<String, bool> getTextInputIsAutoCompleteViewAbstractMap() => {};

  @override
  Map<String, double> getTextInputMaxValidateMap() => {};

  @override
  Map<String, double> getTextInputMinValidateMap() => {};

  @override
  Map<String, TextInputType?> getTextInputTypeMap() => {
        "phone": TextInputType.text,
        "password": TextInputType.none,
      };

  @override
  Map<String, bool> isFieldRequiredMap() => {
        "phone": true,
        "password": true,
      };

  @override
  SortFieldValue? getSortByInitialType() =>
      SortFieldValue(field: "name", type: SortByType.ASC);

  @override
  String? getMainDrawerGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.users;

  @override
  void onBeforeGenerateView(BuildContext context, {ServerActions? action}) {
    super.onBeforeGenerateView(context);
  }

  @override
  AuthUserLogin getSelfNewInstance() {
    return AuthUserLogin();
  }

  @override
  String getForeignKeyName() {
    return "CustomerID";
  }

  @override
  IconData getMainIconData() {
    return Icons.account_circle;
  }

  @override
  String? getTableNameApi() {
    return "";
  }

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.customer;

  factory AuthUserLogin.fromJson(Map<String, dynamic> data) => AuthUserLogin();

  @override
  Map<String, dynamic> toJson() => {};

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  AuthUserLogin fromJsonViewAbstract(Map<String, dynamic> json) => this;
}

// class AuthRepository {
//   final BehaviorSubject<AuthUser?> _authState = BehaviorSubject.seeded(null);

//   AuthUser? get currentUser => _authState.value;

//   Stream<AuthUser?> authStateChanges() {
//     return _authState.stream;
//   }

//   void signIn() {
//     _authState.add(AuthUser("98e99-some-test-uid-jkh37"));
//   }

//   void signOut() {
//     _authState.add(null);
//   }
// }

// final authRepositoryProvider = Provider(create: (ref) {
//   return AuthRepository();
// });

@JsonSerializable(explicitToJson: true)
class AuthUser<T> extends ViewAbstract<AuthUser> {
  bool? login;
  bool? permission;
  int? response;
  String? phone;
  String? password;
  String? barrerToken;

  PermissionLevelAbstract? userlevels;
  Setting? setting;
  Dealers? dealers;

  AuthUser({bool? setPassword}) : super() {
    if (setPassword != null) {
      if (setPassword) {
        setRandomPassword();
      }
      return;
    }
    // if (setPassword ?? false) {
    //   setRandomPassword();
    // }
    setRandomPassword();
  }
  @JsonKey(includeFromJson: false, includeToJson: false)
  final BehaviorSubject<AuthUser?> _authState = BehaviorSubject.seeded(null);

  AuthUser? get currentUser => _authState.value;

  Stream<AuthUser?> authStateChanges() {
    return _authState.stream;
  }

  void signIn(AuthUser user) {
    _authState.add(user);
  }

  void signOut() {
    _authState.add(null);
  }

  @override
  AuthUser getSelfNewInstance() {
    return AuthUser();
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() => {
        "login": false,
        "permission": false,
        "response": 0,
        "phone": "",
        "password": "",
        "barrerToken": "",
        "userlevels": PermissionLevelAbstract(),
        "setting": Setting()
      };

  void setRandomPassword() {
    const alphabet =
        "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890";
    Random r = Random();
    password = String.fromCharCodes(Iterable.generate(
        8, (_) => alphabet.codeUnitAt(r.nextInt(alphabet.length))));
  }

  factory AuthUser.fromJson(Map<String, dynamic> data) =>
      _$AuthUserFromJson(data);

  Map<String, dynamic> toJson() => _$AuthUserToJson(this);
  @override
  String? getCustomAction() {
    return "login_flutter";
  }

  @override
  AuthUser fromJsonViewAbstract(Map<String, dynamic> json) {
    return AuthUser.fromJson(json);
  }

  @override
  List<String> getMainFields({BuildContext? context}) {
    return ["login", "permissions", "response"];
  }

  @override
  IconData getMainIconData() {
    return Icons.nat;
  }

  @override
  String? getTableNameApi() {
    return null;
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
  SortFieldValue? getSortByInitialType() =>
      SortFieldValue(field: "phone", type: SortByType.ASC);
  @override
  String? getMainDrawerGroupName(BuildContext context) {
    // TODO: implement getMainDrawerGroupName
    throw UnimplementedError();
  }

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.customer;

  @override
  String getMainHeaderTextOnly(BuildContext context) => "";

  @override
  Map<String, bool> getTextInputIsAutoCompleteMap() => {};

  @override
  Map<String, bool> getTextInputIsAutoCompleteViewAbstractMap() {
    // TODO: implement getTextInputIsAutoCompleteViewAbstractMap
    throw UnimplementedError();
  }
}
