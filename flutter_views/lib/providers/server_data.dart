import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/servers/server_data.dart';

class ServerDataProvider with ChangeNotifier {
  late ServerData _serverData;
  DateTime dateTime = DateTime.now();
  set setData(ServerData serverData) {
    _serverData = serverData;
    dateTime = DateTime.now();
  }

  get getData => _serverData;
}
