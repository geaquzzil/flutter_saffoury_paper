import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

class AutoRest<T extends ViewAbstract> {
  T obj;
  String key;
  AutoRest({required this.obj, required this.key});
}

class AutoRestCustomResponseView<T extends ViewAbstract,
    E extends CustomViewResponse<T>> {
  T obj;
  String key;
  bool? isSingleResponse;
  AutoRestCustomResponseView({required this.obj, required this.key,this.isSingleResponse});
}

abstract class CustomViewResponse<T> {
  Widget getItemWidget(BuildContext context, T item);
  Widget? getWidgetIfSingle(BuildContext context, T item);
  void onCardClicked(BuildContext context, T istem);
}
