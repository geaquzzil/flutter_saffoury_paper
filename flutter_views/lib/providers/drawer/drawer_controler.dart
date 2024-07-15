import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_stand_alone.dart';
import 'package:flutter_view_controller/providers/filterables/filterable_provider.dart';
import 'package:provider/provider.dart';

class DrawerMenuControllerProvider with ChangeNotifier {
  final GlobalKey<ScaffoldState> _startDrawerKey = GlobalKey<ScaffoldState>();
  Map<String, GlobalKey<ScaffoldState>> _startDrawerKeyWeb = {};
  ViewAbstract _object;
  ViewAbstract? _dashboard;
  ViewAbstractStandAloneCustomViewApi? _standAloneCustomViewApi;
  bool _sideMenuOpen = false;
  int _idx = 0;

  int _navigationIndex = 2;
  bool _navigationRailIsOpen = false;

  DrawerMenuControllerProvider({required ViewAbstract initViewAbstract})
      : _object = initViewAbstract;
  int get getIndex => _idx;
  bool get getSideMenuIsOpen => _sideMenuOpen;
  bool get getSideMenuIsClosed => !_sideMenuOpen;
  ViewAbstract get getObject => _object;
  ViewAbstract? get getDashboard => _dashboard;

  ViewAbstractStandAloneCustomViewApi? get getStandAloneCustomView =>
      _standAloneCustomViewApi;
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

  String get getObjectID => getObject.getIDString();

  String get getObjectTableName => getObject.getTableNameApi() ?? "-";

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

  void changeToStandAloneApi(
      BuildContext context, ViewAbstractStandAloneCustomViewApi custom) {
    _standAloneCustomViewApi = custom;

    notifyListeners();
  }

  void changeToDashboard(BuildContext context, ViewAbstract dashboard) {
    _standAloneCustomViewApi = null;
    _dashboard = dashboard;
    notifyListeners();
  }

  void change(BuildContext context, ViewAbstract object) {
    _object = object;
    _standAloneCustomViewApi = null;
    _dashboard = null;
    notifyListeners();
    context.read<FilterableProvider>().init(context, object);
  }

  void changeWithFilterable(BuildContext context, ViewAbstract object) {
    _object = object.getCopyInstance();
    _standAloneCustomViewApi = null;
    notifyListeners();
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
