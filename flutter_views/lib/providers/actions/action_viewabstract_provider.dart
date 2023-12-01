import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/permissions/permission_action_abstract.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

class ActionViewAbstractProvider with ChangeNotifier {
  ViewAbstract? _object;
  ServerActions? serverActions;
  List<StackedActions?> stack = [null];
  ActionViewAbstractProvider();
  Widget? _customWidget;
  Widget? get getCustomWidget => _customWidget;
  ViewAbstract? get getObject => _object;
  ViewAbstract get getObjectNotNull => _object ?? PermissionActionAbstract();
  ServerActions? get getServerActions => serverActions;
  List<StackedActions?> get getStackedActions => stack;
  void changeCustomWidget(Widget widget) {
    _customWidget = widget;
    _object = null;
    notifyListeners();
  }

  void change(ViewAbstract object, ServerActions? serverActions) {
    _customWidget = null;
    this._object = object;
    this.serverActions = serverActions;
    if (stack.isNotEmpty) {
      stack.removeWhere(
          (element) => element?.object?.isEqualsAsType(object) ?? false);
    }
    stack.add(StackedActions(object, serverActions, stack.isEmpty));
    notifyListeners();
  }

  void pop() {
    if (stack.isNotEmpty) {
      StackedActions? s = stack.removeLast();
      if (s != null) {
        _object = s.object;
        serverActions = s.serverActions;
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
