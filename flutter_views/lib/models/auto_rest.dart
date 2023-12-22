// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

class AutoRest<T extends ViewAbstract> {
  T obj;
  String key;
  int? range;

  AutoRest({required this.obj, required this.key, this.range});
}

class AutoRestCustom<T> {
  String action;
  T responseObjcect;
  ResponseType responseType;
  AutoRestCustom(
      {required this.action,
      required this.responseObjcect,
      required this.responseType});
}

abstract class CustomViewHorizontalListResponse<T extends ViewAbstract> {
  Widget? getCustomViewListResponseWidget(BuildContext context, List<T> item);
  Widget? getCustomViewSingleResponseWidget(BuildContext context);
  Widget? getCustomViewTitleWidget(
      BuildContext context, ValueNotifier valueNotifier);
  void onCustomViewCardClicked(BuildContext context, T istem);
  double? getCustomViewHeight();
  ResponseType getCustomViewResponseType();
  String getCustomViewKey();
}

enum ResponseType {
  SINGLE,
  LIST,
  NONE_RESPONSE_TYPE,
}
