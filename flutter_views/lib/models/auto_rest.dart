import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_api.dart';

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
  E? viewResponse;
  AutoRestCustomResponseView(
      {required this.obj,
      required this.viewResponse,
      required this.key,
      this.isSingleResponse});
}

abstract class CustomViewResponse<T extends ViewAbstract> {
  Widget? getCustomViewListResponseWidget(BuildContext context, List<T> item);
  Widget? getCustomViewSingleResponseWidget(BuildContext context, T item);
  void onCustomViewCardClicked(BuildContext context, T istem);
  ResponseType getCustomViewResponseType();
  String getCustomViewKey();
}

enum ResponseType {
  SINGLE,
  LIST,
}
