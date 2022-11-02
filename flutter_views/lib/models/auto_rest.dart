import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

class AutoRest<T extends ViewAbstract> {
  T obj;
  String key;
  AutoRest({required this.obj, required this.key});
}

abstract class CustomViewHorizontalListResponse<T extends ViewAbstract> {
  Widget? getCustomViewListResponseWidget(BuildContext context, List<T> item);
  Widget? getCustomViewSingleResponseWidget(BuildContext context, T item);
  void onCustomViewCardClicked(BuildContext context, T istem);
  double? getCustomViewHeight();
  ResponseType getCustomViewResponseType();
  String getCustomViewKey();
}

enum ResponseType {
  SINGLE,
  LIST,
}
