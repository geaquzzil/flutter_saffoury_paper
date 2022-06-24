import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

class ActionViewAbstractProvider with ChangeNotifier {
  ViewAbstract? object;
  ServerActions? serverActions;
  ActionViewAbstractProvider();

  ViewAbstract? get getObject => object;
  ServerActions? get getServerActions => serverActions;

  void change(ViewAbstract object,ServerActions? serverActions) {
    this.object = object;
    this.serverActions = serverActions;
    notifyListeners();
  }
}
