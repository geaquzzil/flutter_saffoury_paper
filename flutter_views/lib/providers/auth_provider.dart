// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/configrations.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/interfaces/dashable_interface.dart';
import 'package:flutter_view_controller/interfaces/notification_interface.dart';
import 'package:flutter_view_controller/interfaces/posable_interface.dart';
import 'package:flutter_view_controller/interfaces/web/category_gridable_interface.dart';
import 'package:flutter_view_controller/models/permissions/permission_level_abstract.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:go_router/go_router.dart';
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
  AuthProvider(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }
  static bool isLoggedIn(BuildContext context) {
    return context.read<AuthProvider<AuthUser>>().getUser?.isLoggedIn() ??
        false;
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  late final StreamSubscription<dynamic> _subscription;
  late List<ViewAbstract> _drawerItems;
  late Map<String?, List<ViewAbstract>> __drawerItemsGrouped;
  final List<ViewAbstract> _drawerItemsPermissions = [];
  T? _currentUser;
  late T _initUser;
  late ViewAbstract _orderSimple;

  NotificationHandlerInterface? _notificationHandler;
  late NotificationHandlerInterface _notificationHandlerSimple;

  List<RouteableInterface>? _getGoRoutesAddOns;
  Status _status = Status.Initialization;
  bool _isInitialized = false;
  bool get isInitialized => this._isInitialized;

  set isInitialized(bool value) => this._isInitialized = value;
  bool _hasFinishedUpSettingUp = false;
  bool hasSavedUser = false;
  late PermissionLevelAbstract _permissions;
  Status get getStatus => _status;
  T? get getUser => _currentUser;
  T get getSimpleUser => (_currentUser.getSelfNewInstance() as T)
    ..iD = _currentUser.iD
    ..phone = _currentUser.phone
    ..password = _currentUser.password
    ..setFieldValue("name", getUserName);
  Dealers? get getDealers => _currentUser.dealers;
  ViewAbstract get getOrderSimple => _orderSimple.getSelfNewInstance();
  String get getUserName => _currentUser.getFieldValue("name") ?? "_UNKONW";
  String get getUserPermission => _currentUser.userlevels?.userlevelname ?? "";
  String get getUserImageUrl {
    // return "";
    //todo for some reason we canot add profile image
    return "https://play-lh.googleusercontent.com/i1qvljmS0nE43vtDhNKeGYtNlujcFxq72WAsyD2htUHOac57Z9Oiew0FrpGKlEehOvo=w240-h480-rw";
  }

  Future<void> onAppStart(BuildContext context) async {
    await init();
    await initDrawerItems(context);
    // This is just to demonstrate the splash screen is working.
    // In real-life applications, it is not recommended to interrupt the user experience by doing such things.
    await Future.delayed(const Duration(milliseconds: 100));

    // _initialized = true;
    notifyListeners();
  }

  bool hasFinished() {
    return _hasFinishedUpSettingUp;
  }

  bool hasNotificationWidget() {
    return _notificationHandler != null;
  }

  NotificationHandlerInterface getNotificationHandler() {
    return _notificationHandler!;
  }

  PermissionLevelAbstract get getPermissions => _permissions;
  List<ViewAbstract> get getDrawerItems => _drawerItems;
  List<ViewAbstract> get getDrawerItemsPermissions => _drawerItemsPermissions;

  ///each of this has seperate pages
  bool isPOS(BuildContext context) => _permissions.isPOS(context);
  bool isPalletCutter(BuildContext context) =>
      _permissions.isPalletCutter(context);
  bool isReelCutter(BuildContext context) => _permissions.isReelCutter(context);

  bool isGoodsInventory(BuildContext context) =>
      _permissions.isGoodsInventoryWorker(context);

  bool isAdmin(BuildContext context) => _permissions.isAdmin(context);

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

  List<GoRoute?>? getGoRoutesAddOns(BuildContext context) {
    return _getGoRoutesAddOns
        ?.map((toElement) => toElement.getGoRouteAddOn(context))
        .toList()
        .cast();
  }

  AuthProvider.initialize(T initUser, List<ViewAbstract> drawerItems,
      ViewAbstract orderSimple, List<RouteableInterface>? getGoRoutesAddOns,
      {required NotificationHandlerInterface notificationHandlerSimple}) {
    _drawerItems = drawerItems;
    _initUser = initUser;
    _orderSimple = orderSimple;
    _currentUser = _initUser;
    _getGoRoutesAddOns = getGoRoutesAddOns;
    _notificationHandlerSimple = notificationHandlerSimple;
    _subscription = _initUser.authStateChanges().asBroadcastStream().listen(
      (dynamic _) {
        debugPrint("initUser.authStateChanges() $_");
        notifyListeners();
      },
    );
    // initFakeData();
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

  Future init() async {
    _currentUser = (await Configurations.get<T>(_initUser));
    _status = _currentUser != null ? Status.Authenticated : Status.Guest;
    notifyListeners();
  }

  Future initDrawerItems(BuildContext context) async {
    await Future.forEach(_drawerItems, (item) async {
      bool? hasPermssion =
          _currentUser?.hasPermissionList(context, viewAbstract: item);
      if (hasPermssion ?? false) {
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

  Future<bool> signIn(
      {required BuildContext context,
      required AuthUser user,
      OnResponseCallback? onResponeCallback,
      Function(Status s)? currentStatus}) async {
    notifyListeners();
    currentStatus?.call(Status.Authenticating);
    _currentUser = await _initUser.viewCall(
        context: context,
        onResponse: OnResponseCallback(
          onBlocked: () {
            //TODO BLOCK ACTION
            debugPrint("SignIn==========> is blocked");
            currentStatus?.call(Status.Blocked);
            onResponeCallback?.onBlocked?.call();
          },
          onEmailOrPassword: () {
            debugPrint("onEmailOrPassword==========> is not valid");
            currentStatus?.call(Status.Unauthenticated);

            onResponeCallback?.onEmailOrPassword?.call();
          },
          onClientFailure: (o) {
            currentStatus?.call(Status.Faild);
            onResponeCallback?.onClientFailure?.call(o);
          },
        )) as T?;

    if (_currentUser != null) {
      currentStatus?.call(Status.Authenticated);
      Configurations.saveViewAbstract(_currentUser!);
      _permissions = _currentUser!.userlevels!;

      return true;
    } else {
      currentStatus?.call(Status.Unauthenticated);
      return false;
    }
  }

  Future signOut() async {
    // auth.signOut();
    _status = Status.Unauthenticated;
    //TODO remove saved user;

    Configurations.removeViewAbstract(_init);
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
    if (_currentUser.setting == null) return value.toCurrencyFormat();
    return _currentUser.setting!.getPriceAndCurrency(context, value);
  }

  double getPriceFromSettingDouble(BuildContext context, double value) {
    if (_currentUser.setting == null) return value.roundDouble();
    return _currentUser.setting!.getPriceFromSetting(value);
  }

  double getPriceFromSettingDoubleFindSYPEquality(
      BuildContext context, double value) {
    if (_currentUser.setting == null) return -1;
    return _currentUser.setting!.getPriceSYPEquality(value);
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
