import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/servers/server_data.dart';

class ServerDataProvider with ChangeNotifier {
  late FilterableData _serverData;
  DateTime dateTime = DateTime.now();
  set setData(FilterableData serverData) {
    _serverData = serverData;
    dateTime = DateTime.now();
  }

  get getData => _serverData;
}
