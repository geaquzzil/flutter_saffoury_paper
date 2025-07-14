import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

abstract class NotificationHandlerInterface {
  ViewAbstract getObject(BuildContext context);
}
