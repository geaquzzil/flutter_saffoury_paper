// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/configrations.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/interfaces/dashable_interface.dart';
import 'package:flutter_view_controller/interfaces/web/category_gridable_interface.dart';
import 'package:flutter_view_controller/models/permissions/permission_level_abstract.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/test_var.dart';
import 'package:http/src/response.dart';
import 'package:provider/provider.dart';
import 'package:supercharged/supercharged.dart';

import '../models/dealers/dealer.dart';

enum Status {
  Initialization,
  Authenticated,
  Authenticating,
  Unauthenticated,
  Faild,
  Blocked,
  Guest
}

class AuthProvider<T extends AuthUser> with ChangeNotifier {
  late List<ViewAbstract> _drawerItems;
  late Map<String?, List<ViewAbstract>> __drawerItemsGrouped;
  final List<ViewAbstract> _drawerItemsPermissions = [];
  late T _user;
  late T _initUser;
  late ViewAbstract _orderSimple;
  Status _status = Status.Initialization;
  bool _hasFinishedUpSettingUp = false;
  bool hasSavedUser = false;
  late PermissionLevelAbstract _permissions;
  Status get getStatus => _status;
  T get getUser => _user;
  T get getSimpleUser => (_user.getSelfNewInstance() as T)
    ..iD = _user.iD
    ..phone = _user.phone
    ..password = _user.password
    ..setFieldValue("name", getUserName);
  Dealers? get getDealers => _user.dealers;
  ViewAbstract get getOrderSimple => _orderSimple.getSelfNewInstance();
  String get getUserName => _user.getFieldValue("name") ?? "_UNKONW";
  String get getUserPermission => _user.userlevels?.userlevelname ?? "";
  String get getUserImageUrl {
    // return "";
    //todo for some reason we canot add profile image
    return "https://play-lh.googleusercontent.com/i1qvljmS0nE43vtDhNKeGYtNlujcFxq72WAsyD2htUHOac57Z9Oiew0FrpGKlEehOvo=w240-h480-rw";
  }

  bool hasFinished() {
    return _hasFinishedUpSettingUp;
  }

  static bool isLoggedIn(BuildContext context) {
    return context.read<AuthProvider<AuthUser>>().getUser.login == true;
  }

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
  List<ViewAbstract> getWebCategories() {
    return getDrawerItems
        .whereType<WebCategoryGridableInterface>()
        .toList()
        .cast();
  }

  AuthProvider.initialize(
      T initUser, List<ViewAbstract> drawerItems, ViewAbstract orderSimple) {
    _drawerItems = drawerItems;
    _initUser = initUser;
    _orderSimple = orderSimple;
    initFakeData();
  }
  DashableInterface getDashableInterface() {
    return _drawerItems.whereType<DashableInterface>().first;
  }

  List<DashableInterface> getListableOfDashablesInterface() {
    final s = _drawerItems.whereType<DashableInterface>().toList();
    debugPrint("getListableOfDashablesInterface ${s.length}");
    for (var element in s) {
      debugPrint("getListableOfDashablesInterface ${element.runtimeType}");
    }
    return s;
  }

  ViewAbstract? getNewInstance(String tableName) {
    return _drawerItems.firstWhereOrNull(
      (p0) => p0.getTableNameApi() == tableName,
    );
  }

  void initFakeData() async {
    // await Future.delayed(const Duration(seconds: 2));
    try {
      _user = _initUser.fromJsonViewAbstract(jsonDecode(jsonEncode(loginJson)))
          as T;
      _user.login = false;
      _status = Status.Authenticated;
      _permissions = _user.userlevels ?? PermissionLevelAbstract();
      hasSavedUser = true;
      notifyListeners();
    } catch (ex) {
      debugPrint("Error initial $ex");
    }
  }

  //Todo on publish use this method
  void init() async {
    hasSavedUser = await Configurations.hasSavedValue(_initUser);
    final Response? responseUser;
    if (hasSavedUser == false) {
      _user = _initUser;

      _user.password = "";
      _user.phone = "";
      _user.login = true;
      _status = Status.Guest;
    } else {
      _user = (await Configurations.get<T>(_initUser))!;
    }
    responseUser =
        await _initUser.getRespones(serverActions: ServerActions.add);
    if (responseUser == null) {
      _status = Status.Faild;
    } else if (responseUser.statusCode == 401) {
      _status = Status.Faild;
    } else {
      _user =
          _initUser.fromJsonViewAbstract(jsonDecode(responseUser.body)) as T;
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
      // debugPrint("checing permission for $item ");
      bool hasPermssion = _user.hasPermissionList(context, viewAbstract: item);
      // debugPrint("checing permission for $item value is $hasPermssion ");
      if (hasPermssion) {
        _drawerItemsPermissions.add(item);
      }
    });
    // debugPrint(
    //     "initDrawerItems genrated list is ${_drawerItemsPermissions.toString()}");

    __drawerItemsGrouped = _drawerItemsPermissions.groupBy(
        (item) => item.getMainDrawerGroupName(context),
        valueTransform: (v) => v);
    _hasFinishedUpSettingUp = true;
    // debugPrint(
    //     "initDrawerItems _drawerItemsPermissions Grouped list is ${__drawerItemsGrouped.toString()}");

    //  List<List<GrowthRate>> g=[];
    //  g.groupBy<DateTime,GrowthRate>((element) => element.map((e) => e.total).toList() )
  }

  Future<bool> signIn({AuthUser? user}) async {
    try {
      debugPrint(
          "AuthProvider auth user =>phone: ${user?.phone} password: ${user?.password}");
      hasSavedUser = await Configurations.hasSavedValue(_initUser);
      final Response? responseUser;
      if (user != null) {
        _user = user as T;
        _user.password = user.password ?? "";
        _user.phone = user.phone ?? "";
        _user.login = false;
        _status = Status.Guest;
        Configurations.save("", _user);
      } else if (hasSavedUser == false) {
        _user = _initUser;
        _user.password = "";
        _user.phone = "";
        _user.login = false;
        _status = Status.Guest;
      } else {
        _user = (await Configurations.get<T>(_initUser))!;
      }
      _status = Status.Authenticating;
      notifyListeners();
      responseUser = await _user.getRespones(serverActions: ServerActions.add);
      if (responseUser == null) {
        _status = Status.Faild;
      } else if (responseUser.statusCode == 401) {
        _status = Status.Faild;
      } else {
        _user =
            _initUser.fromJsonViewAbstract(jsonDecode(responseUser.body)) as T;
        bool isLogin = _user.login ?? false;
        bool hasPermission = _user.permission ?? false;
        _status = isLogin ? Status.Authenticated : Status.Unauthenticated;
        if (isLogin) {
          Configurations.save("", _user);
        }
        // }
        _permissions = _user.userlevels ?? PermissionLevelAbstract();
        debugPrint("Authenticated $_status");
        // notifyListeners();
      }
      // _status = Status.Authenticating;
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

  String getPriceFromSetting(BuildContext context, double value) {
    if (_user.setting == null) return value.toCurrencyFormat();
    return _user.setting!.getPriceAndCurrency(context, value);
  }

  double getPriceFromSettingDouble(BuildContext context, double value) {
    if (_user.setting == null) return value.roundDouble();
    return _user.setting!.getPriceFromSetting(value);
  }

  double getPriceFromSettingDoubleFindSYPEquality(
      BuildContext context, double value) {
    if (_user.setting == null) return -1;
    return _user.setting!.getPriceSYPEquality(value);
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
