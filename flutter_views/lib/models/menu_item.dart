import 'package:flutter/cupertino.dart';

class MenuItemBuild {
  String title;
  IconData icon;
  String route;
  MenuItemBuild(this.title, this.icon, this.route);
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
