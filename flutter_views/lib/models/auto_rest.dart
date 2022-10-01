import 'package:flutter_view_controller/models/view_abstract.dart';

class AutoRest<T extends ViewAbstract> {
  T obj;
  String key;
  AutoRest({required this.obj, required this.key});
}
