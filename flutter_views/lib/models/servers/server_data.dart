import 'package:flutter_view_controller/models/va_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

abstract class ServerData extends VMirrors<ServerData> {
  ServerData fromJsonServerData(Map<String, dynamic> json);
  Map<String, dynamic> toJsonServerData();
}
