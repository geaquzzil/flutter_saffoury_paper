// ignore_for_file: public_member_api_docs, sort_constructors_first, constant_identifier_names
import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/request_options.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_api_master_new.dart';
import 'package:http/http.dart';
import 'view_abstract_api.dart';

abstract class JsonHelper<T> {
  T fromJson(Map<String, dynamic> data);

  Map<String, dynamic> toJson();
}

@Deprecated("Use ViewAbstract")
class AutoRest<T extends ViewAbstract> {
  T obj;
  @Deprecated("Should implement a function instead ")
  String key;
  int? range;

  AutoRest({required this.obj, required this.key, this.range});
}

class AutoRestCustom<T extends JsonHelper<T>> extends ViewAbstractApi<T> {
  List<String>? action;
  String tableName;

  T responseObjcect;
  ResponseType responseType;
  AutoRestCustom({
    required this.tableName,
    this.action,
    required this.responseObjcect,
    required this.responseType,
  });

  @override
  String? getTableNameApi() => tableName;
  @override
  String getListableKey({SliverMixinObjectType? type}) {
    return "${super.getListableKey(type: type)}-$tableName-$action-${responseObjcect.runtimeType}";
  }

  @override
  List<String>? getCustomAction() {
    return action;
  }

  ResponseType getCustomViewResponseType() {
    return responseType;
  }

  @override
  T getJsonEncodeResponse(Response response) {
    return responseObjcect.fromJson(convert.jsonDecode(response.body));
  }

  @override
  List<T> getJsonEncodeListResponse<T>(Response response) {
    Iterable l = convert.jsonDecode(response.body);
    return List<T>.from(l.map((model) => responseObjcect.fromJson(model)));
  }

  @override
  T fromJsonViewAbstract(Map<String, dynamic> json) {
    return responseObjcect.fromJson(json);
  }

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    return responseObjcect.toJson();
  }

  @override
  Map<String, IconData> getFieldIconDataMap() => {};

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {};

  @override
  String? getMainDrawerGroupName(BuildContext context) => null;

  @override
  List<String> getMainFields({BuildContext? context}) => [];

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) => "";

  @override
  String getMainHeaderTextOnly(BuildContext context) => "";
  @override
  IconData getMainIconData() => Icons.abc;

  @override
  T getSelfNewInstance() {
    return responseObjcect;
  }

  @override
  RequestOptions? getRequestOption({
    required ServerActions action,
    RequestOptions? generatedOptionFromListCall,
  }) => null;

  @override
  List<String>? getRequestedForginListOnCall({required ServerActions action}) =>
      null;
}

abstract class CustomViewHorizontalListResponse<T extends ViewAbstract> {
  // Widget? getCustomViewListResponseWidget(BuildContext context, List<T> item);

  ///if return is List<Widget> then wrap with SliverList
  dynamic getCustomViewResponseWidget(
    BuildContext context, {

    required SliverApiWithStaticMixin state,
    List<dynamic>? items,
    required dynamic requestObjcet,
    required bool isSliver,
  });
  // Widget? getCustomViewTitleWidget(
  //   BuildContext context,
  //   SliverApiWithStaticMixin state,
  // );
  void onCustomViewCardClicked(BuildContext context, T istem);
  // double? getCustomViewHeight();
  ResponseType getCustomViewResponseType();

  String getCustomViewKey();

  // Widget? getCustomViewOnResponse(T response);
  // dynamic getCustomViewOnResponseAddWidget(T response);
}

enum ResponseType { SINGLE, LIST, NONE_RESPONSE_TYPE }
