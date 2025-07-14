import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';

abstract class SharableInterface {
  String getContentSharable(BuildContext context,{ServerActions? action});
}
