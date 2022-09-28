import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/permissions/permission_action_abstract.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/v_non_view_object.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

class ActionViewAbstractProvider with ChangeNotifier {
  ViewAbstract? object;
  ServerActions? serverActions;
  ActionViewAbstractProvider();

  ViewAbstract? get getObject => object;
  ViewAbstract get getObjectNotNull => object??PermissionActionAbstract();
  ServerActions? get getServerActions => serverActions;

  void change(ViewAbstract object,ServerActions? serverActions) {
    this.object = object;
    this.serverActions = serverActions;
    notifyListeners();
  }
}
