import 'package:flutter_view_controller/models/va_mirrors.dart';

abstract class ServerData extends VMirrors<ServerData> {
  ServerData fromJsonServerData(Map<String, dynamic> json);
  Map<String, dynamic> toJsonServerData();
}
