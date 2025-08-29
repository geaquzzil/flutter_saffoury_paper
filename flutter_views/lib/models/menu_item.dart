import 'package:flutter/cupertino.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';

class MenuItemBuild {
  String title;
  IconData icon;
  String route;
  ServerActions? action;
  MenuItemBuild(this.title, this.icon, this.route,{this.action});
}

class MenuItemBuildGenirc<T> {
  String title;
  IconData icon;
  String route;
  T? value;
  MenuItemBuildGenirc(
      {required this.title,
      required this.icon,
      required this.route,
      this.value});
}
