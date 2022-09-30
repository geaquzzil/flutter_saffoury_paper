import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/permissions/permission_action_abstract.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/v_non_view_object.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

class ActionViewAbstractProvider with ChangeNotifier {
  ViewAbstract? object;
  ServerActions? serverActions;
  List<StackedActions?> stack = [null];
  ActionViewAbstractProvider();

  ViewAbstract? get getObject => object;
  ViewAbstract get getObjectNotNull => object ?? PermissionActionAbstract();
  ServerActions? get getServerActions => serverActions;
  List<StackedActions?> get getStackedActions => stack;

  void change(ViewAbstract object, ServerActions? serverActions) {
    this.object = object;
    this.serverActions = serverActions;
    if (stack.isNotEmpty) {
      dynamic obj = stack.last;
      if (obj != null) {
        if (object.isEqualsAsType((obj as StackedActions).object)) {
          stack.removeLast();
        }
      }
    }
    stack.add(StackedActions(object, serverActions, stack.isEmpty));
    notifyListeners();
  }
  void popUntil(StackedActions stack){
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
