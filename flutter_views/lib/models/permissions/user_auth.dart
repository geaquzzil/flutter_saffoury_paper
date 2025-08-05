import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/permissions/permission_level_abstract.dart';
import 'package:flutter_view_controller/models/permissions/setting.dart';
import 'package:flutter_view_controller/models/request_options.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../dealers/dealer.dart';
import '../servers/server_helpers.dart';

part 'user_auth.g.dart';

@reflector
class AuthUserLogin extends AuthUser<AuthUserLogin> {
  AuthUserLogin() : super(setPassword: false);
  @override
  List<String> getMainFields({BuildContext? context}) {
    return ["phone", "password"];
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
  List<String>? getCustomAction() {
    return ["login"];
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
  Map<String, bool> isFieldRequiredMap() => {"phone": true, "password": true};

  @override
  String? getMainDrawerGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.users;

  @override
  void onBeforeGenerateView(BuildContext context, {ServerActions? action}) {
    super.onBeforeGenerateView(context);
  }

  @override
  RequestOptions? getRequestOption({
    required ServerActions action,
    RequestOptions? generatedOptionFromListCall,
  }) {
    return RequestOptions().addSortBy("name", SortByType.ASC);
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
@reflector
class AuthUser<T> extends ViewAbstract<AuthUser> {
  int? phone;
  String? password;
  String? token;

  PermissionLevelAbstract? userlevels;
  Setting? setting;
  Dealers? dealers;

  bool isLoggedIn() {
    return token != null && (token?.isNotEmpty ?? false);
  }

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

  C? getSavedUser<C extends ViewAbstract>(BuildContext context) {
    dynamic authUser = context.read<AuthProvider<AuthUser>>().getUser;
    if (authUser == null) return null;
    return fromJsonViewAbstract(authUser.toJson() ?? {}) as C?;
  }

  Future<AuthUser?> loginCall({
    required BuildContext context,
    OnResponseCallback? onResponse,
  }) async {
    // AuthUser? response =
    //     await addCall(context: context, onResponse: onResponse);
    return addCall(context: context, onResponse: onResponse);
  }

  @override
  AuthUser getSelfNewInstance() {
    return AuthUser();
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() => {
    "phone": 0,
    "password": "",
    "token": "",
    "userlevels": PermissionLevelAbstract(),
    "setting": Setting(),
  };

  void setRandomPassword() {
    const alphabet =
        "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890";
    Random r = Random();
    password = String.fromCharCodes(
      Iterable.generate(
        8,
        (_) => alphabet.codeUnitAt(r.nextInt(alphabet.length)),
      ),
    );
  }

  factory AuthUser.fromJson(Map<String, dynamic> data) =>
      _$AuthUserFromJson(data);

  Map<String, dynamic> toJson() => _$AuthUserToJson(this);

  @override
  List<String>? getCustomAction() {
    return ["login"];
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

  @override
  RequestOptions? getRequestOption({
    required ServerActions action,
    RequestOptions? generatedOptionFromListCall,
  }) {
    return RequestOptions().addSortBy("phone", SortByType.ASC);
  }

  @override
  List<String>? getRequestedForginListOnCall({required ServerActions action}) {
    return null;
  }
}
