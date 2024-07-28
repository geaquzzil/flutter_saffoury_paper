import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_stand_alone.dart';
import 'package:flutter_view_controller/providers/filterables/filterable_provider.dart';
import 'package:provider/provider.dart';

enum DrawerMenuControllerProviderAction {
  none,
  list_to_details,
  custom,
  dashboard,
  list,
  print,
  view,
  edit
}

class DrawerMenuControllerProvider with ChangeNotifier {
  final GlobalKey<ScaffoldState> _startDrawerKey = GlobalKey<ScaffoldState>();
  dynamic _object;
  bool _sideMenuOpen = false;
  int _idx = 0;

  int _navigationIndex = 2;
  bool _navigationRailIsOpen = false;
  Map<String, GlobalKey<ScaffoldState>> _startDrawerKeyWeb = {};

  DrawerMenuControllerProviderAction _action =
      DrawerMenuControllerProviderAction.none;

  DrawerMenuControllerProvider({required ViewAbstract initViewAbstract})
      : _object = initViewAbstract;

  DrawerMenuControllerProviderAction get getAction => _action;

  set action(DrawerMenuControllerProviderAction value) => _action = value;
  int get getIndex => _idx;
  bool get getSideMenuIsOpen => _sideMenuOpen;
  bool get getSideMenuIsClosed => !_sideMenuOpen;
  ViewAbstract get getObjectCastViewAbstract => _object;
  ViewAbstract get getObjectCastDashboard => _object;
  dynamic get getObject=>_object;
  ViewAbstractStandAloneCustomViewApi get getObjectCastViewStandAlone =>
      _object;

  GlobalKey<ScaffoldState> get getStartDrawableKey => _startDrawerKey;
  GlobalKey<ScaffoldState> getStartDrawableKeyWeb(String key) {
    debugPrint("getStartDrawableKey $key");
    if (_startDrawerKeyWeb.containsKey(key)) {
      return _startDrawerKeyWeb[key]!;
    }
    _startDrawerKeyWeb[key] = GlobalKey<ScaffoldState>(debugLabel: key);
    return _startDrawerKeyWeb[key]!;
  }

  int get getNavigationIndex => _navigationIndex;
  bool get getNavigationRailIsOpen => _navigationRailIsOpen;

  String get getObjectID => getObjectCastViewAbstract.getIDString();

  String get getObjectTableName =>
      getObjectCastViewAbstract.getTableNameApi() ?? "-";

  set setNavigationIndex(int index) {
    _navigationIndex = index;
    notifyListeners();
  }

  void setNavigationRailIsOpen({bool? isOpen}) {
    if (isOpen == null) {
      _navigationRailIsOpen = !_navigationRailIsOpen;
    } else {
      _navigationRailIsOpen = isOpen;
    }
    notifyListeners();
  }

  String getTitle(BuildContext context) =>
      _object.getMainHeaderLabelTextOnly(context).toLowerCase();

  void change(BuildContext context, dynamic object,
      DrawerMenuControllerProviderAction action,
      {bool changeWithFilterable = false}) {
    _action = action;
    _object = changeWithFilterable ? object.getCopyInstance() : object;
    notifyListeners();
    if (action == DrawerMenuControllerProviderAction.list) {
      context.read<FilterableProvider>().init(context, object);
    }
  }

  void changeDrawerIndex(int idx) {
    _idx = idx;
    notifyListeners();
  }

  void toggleIsOpen() {
    _sideMenuOpen = !_sideMenuOpen;
    debugPrint("Toggling isOpen");
    notifyListeners();
  }

  void setSideMenuIsClosed({int? byIdx}) {
    _sideMenuOpen = false;
    if (byIdx != null) {
      _idx = byIdx;
    }
    notifyListeners();
  }

  void setSideMenuIsOpen() {
    _sideMenuOpen = true;
    notifyListeners();
  }

  void controlStartDrawerMenu() {
    _controlStartDrawerMenu(_startDrawerKey);

    if (_startDrawerKeyWeb.isNotEmpty) {
      _startDrawerKeyWeb.forEach((key, value) {
        _controlStartDrawerMenu(value);
      });
    }
  }

  void _controlStartDrawerMenu(GlobalKey<ScaffoldState> key) {
    if (key.currentState == null) return;
    if (!key.currentState!.isDrawerOpen) {
      key.currentState?.openDrawer();
    } else {
      key.currentState?.closeDrawer();
    }
  }

  void controlEndDrawerMenu() {
    _controlEndDrawerMenu(_startDrawerKey);
    if (_startDrawerKeyWeb.isNotEmpty) {
      _startDrawerKeyWeb.forEach((key, value) {
        _controlEndDrawerMenu(value);
      });
    }
  }

  void _controlEndDrawerMenu(GlobalKey<ScaffoldState> key) {
    if (key.currentState == null) return;

    if (key.currentState!.isEndDrawerOpen) {
      key.currentState?.closeEndDrawer();
    } else {
      key.currentState?.openEndDrawer();
    }
  }
}
