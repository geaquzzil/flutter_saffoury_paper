import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/configrations.dart';
import 'package:flutter_view_controller/models/permissions/permission_level_abstract.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/test_var.dart';
import 'package:http/src/response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supercharged/supercharged.dart';

enum Status {
  Initialization,
  Authenticated,
  Authenticating,
  Unauthenticated,
  Faild,
  Blocked,
  Guest
}

class AuthProvider with ChangeNotifier {
  late List<ViewAbstract> _drawerItems;
  late Map<String?, List<ViewAbstract>> __drawerItemsGrouped;
  final List<ViewAbstract> _drawerItemsPermissions = [];
  late AuthUser _user;
  Status _status = Status.Initialization;
  late PermissionLevelAbstract _permissions;

  Status get getStatus => _status;
  AuthUser get getUser => _user;
  String get getUserName => "_user.name";
  String get getUserPermission => "Admin";
  String get getUserImageUrl =>
      "https://play-lh.googleusercontent.com/i1qvljmS0nE43vtDhNKeGYtNlujcFxq72WAsyD2htUHOac57Z9Oiew0FrpGKlEehOvo=w240-h480-rw";
  PermissionLevelAbstract get getPermissions => _permissions;
  List<ViewAbstract> get getDrawerItems => _drawerItems;
  List<ViewAbstract> get getDrawerItemsPermissions => _drawerItemsPermissions;

  Map<String?, List<ViewAbstract>> get getDrawerItemsGrouped =>
      __drawerItemsGrouped;

  // public variables
  final formkey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();

  AuthProvider.initialize(List<ViewAbstract> drawerItems) {
    _drawerItems = drawerItems;
    initFakeData();
  }
  void initFakeData() async {
    await Future.delayed(const Duration(seconds: 2));
    try {
      _user = AuthUser();
      _user.password = "0933326880";
      _user.phone = "0933326882";
      _user.login = true;
      _user = _user.fromJsonViewAbstract(jsonDecode(jsonEncode(loginJson)));
      _status = Status.Authenticated;
      notifyListeners();
    } catch (ex) {
      debugPrint("Error initial $ex");
    }
  }

  //Todo on publish use this method
  void init() async {
    bool hasUser = await Configurations.hasSavedValue(AuthUser());
    final Response? responseUser;
    if (hasUser == false) {
      _user = AuthUser();
      _user.password = "0933326880";
      _user.phone = "0933326882";
      _user.login = true;
      _status = Status.Guest;
    } else {
      _user = await Configurations.get<AuthUser>(_user);
    }
    responseUser = await _user.getRespones(serverActions: ServerActions.add);
    if (responseUser == null) {
      _status = Status.Faild;
    } else if (responseUser.statusCode == 401) {
      _status = Status.Faild;
    } else {
      _user = _user.fromJsonViewAbstract(jsonDecode(responseUser.body));
      bool isLogin = _user.login ?? false;
      bool hasPermission = _user.permission ?? false;
      _status = isLogin ? Status.Authenticated : Status.Guest;
      // }
      _permissions = _user.userlevels ?? PermissionLevelAbstract();
      debugPrint("Authenticated $_status");
      notifyListeners();
    }
  }

  Future initDrawerItems(BuildContext context) async {
    await Future.forEach(_drawerItems, (item) async {
      debugPrint("checing permission for $item ");
      bool hasPermssion = await _user.hasPermissionList(context,
          viewAbstract: item as ViewAbstract);
      debugPrint("checing permission for $item value is $hasPermssion ");
      if (hasPermssion) {
        _drawerItemsPermissions.add(item);
      }
    });
    debugPrint(
        "initDrawerItems genrated list is ${_drawerItemsPermissions.toString()}");

    __drawerItemsGrouped = _drawerItemsPermissions.groupBy(
        (item) => item.getMainDrawerGroupName(context),
        valueTransform: (v) => v);

    debugPrint(
        "initDrawerItems _drawerItemsPermissions Grouped list is ${__drawerItemsGrouped.toString()}");
  }

  Future<bool> signIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      _status = Status.Authenticating;
      notifyListeners();
      // await auth
      //     .signInWithEmailAndPassword(
      //         email: email.text.trim(), password: password.text.trim())
      //     .then((value) async {
      //   await prefs.setString("id", value.getUser.uid);
      // });
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      debugPrint(e.toString());
      return false;
    }
  }

  // Future<bool> signUp() async {
  //   try {
  //     _status = Status.Authenticating;
  //     notifyListeners();
  //     await auth
  //         .createUserWithEmailAndPassword(
  //             email: email.text.trim(), password: password.text.trim())
  //         .then((result) async {
  //       SharedPreferences prefs = await SharedPreferences.getInstance();
  //       await prefs.setString("id", result.user.uid);
  //       _userServices.createAdmin(
  //         id: result.user.uid,
  //         name: name.text.trim(),
  //         email: email.text.trim(),
  //       );
  //     });
  //     return true;
  //   } catch (e) {
  //     _status = Status.Unauthenticated;
  //     notifyListeners();
  //     print(e.toString());
  //     return false;
  //   }
  // }

  Future signOut() async {
    // auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  void clearController() {
    name.text = "";
    password.text = "";
    email.text = "";
  }

  Future<void> reloadUserModel() async {
    // _user = await _user.getAdminById(getUser.uid);
    notifyListeners();
  }

  String? validateEmail(String value) {
    value = value.trim();

    if (value.isEmpty) {
      return 'Email can\'t be empty';
    } else if (!value.contains(RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
      return 'Enter a correct email address';
    }

    return null;
  }
}
