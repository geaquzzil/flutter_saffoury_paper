import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/permissions/permission_action_abstract.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/home/list_to_details_widget_new.dart';

class ActionViewAbstractProvider with ChangeNotifier {
  ViewAbstract? _object;
  ServerActions? serverActions;
  List<ListToDetailsSecoundPaneHelper?> _stack = [];
  ActionViewAbstractProvider();
  Widget? _customWidget;
  Widget? get getCustomWidget => _customWidget;
  ViewAbstract? get getObject => _object;
  ViewAbstract get getObjectNotNull => _object ?? PermissionActionAbstract();
  ServerActions? get getServerActions => serverActions;
  List<ListToDetailsSecoundPaneHelper?> get getStackedActions => _stack;
  @Deprecated("Use Globals.keyForLargeScreenListable instead")
  void changeCustomWidget(Widget widget) {
    _customWidget = widget;
    _object = null;
    notifyListeners();
  }

  void add(ListToDetailsSecoundPaneHelper l) {
    _stack.add(l);
    debugPrint("ActionViewAbstractProvider add change ${_stack.length}");
    notifyListeners();
  }

  @Deprecated("Use add() instead")
  void change(ViewAbstract object, ServerActions? serverActions,
      {bool isMain = false}) {
    _customWidget = null;
    _object = object;
    this.serverActions = serverActions;
    if (isMain) {
      _stack.clear();
    }
    // if (_stack.isNotEmpty) {
    //   if (removeLast) {
    //     _stack.removeLast();
    //     // (element) => element?.object?.isEqualsAsType(object) ?? false);
    //   }
    // }
    // _stack.add(StackedActions(object, serverActions, _stack.isEmpty));
    debugPrint("popS change ${_stack.length}");
    notifyListeners();
  }

  ///LIST [products, products type , grade]
  ///pop => product type
  ///
  void pop() {
    if (_stack.isNotEmpty) {
      ListToDetailsSecoundPaneHelper? s;
      for (int i = _stack.length - 1; i >= 0; i--) {
        bool selectingTheShowingObject =
            _stack[i]?.viewAbstract?.isEqualsAsType(_object) ?? false;
        if (selectingTheShowingObject) {
          _stack.removeAt(i);
          debugPrint(
              "popS selecting the previous objcet index ${i - 1}  ${_stack[i - 1]?.viewAbstract?.getTableNameApi()}");
          s = _stack[i - 1];
          break;
        }
      }

      // s = _stack.removeLast();
      // s = _stack.removeLast();
      debugPrint("popS lastItem ${s?.viewAbstract?.getTableNameApi()}");

      if (s != null) {
        _object = s.viewAbstract;
        serverActions = s.action;
        debugPrint(
            "popS ${_object?.getTableNameApi()} serverActions $serverActions  list $_stack");
        // _stack.removeAt(_stack.length - 2);
        notifyListeners();
      }
    }
    //TODO: this
  }
}

class StackedActions {
  bool? isMain;
  ViewAbstract? object;
  ServerActions? serverActions;
  StackedActions(this.object, this.serverActions, this.isMain);

  @override
  String toString() {
    return "${object?.getTableNameApi()} serverActions $serverActions";
  }
}

class StackList<E> {
  var _list = <E>[];

  void push(E value) => _list.add(value);

  E pop() => _list.removeLast();

  E? get peek {
    try {
      return _list.last;
    } catch (e) {
      return null;
    }
  }

  bool get isEmpty => _list.isEmpty;
  bool get isNotEmpty => _list.isNotEmpty;
  int get length => _list.length;
  void revers() {
    _list = _list.reversed.toList();
  }

  E get(int indx) => _list[indx];

  @override
  String toString() => _list.toString();
}
