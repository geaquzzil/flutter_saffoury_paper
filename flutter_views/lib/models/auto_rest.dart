// ignore_for_file: public_member_api_docs, sort_constructors_first, constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/servers/server_response_master.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'dart:convert' as convert;
import 'view_abstract_api.dart';

abstract class JsonHelper<T> {
  T fromJson(Map<String, dynamic> data);

  Map<String, dynamic> toJson();
}

class AutoRest<T extends ViewAbstract> {
  T obj;
  String key;
  int? range;

  AutoRest({required this.obj, required this.key, this.range});
}

class AutoRestCustom<T extends JsonHelper<T>> extends ViewAbstractApi<T> {
  String action;
  T responseObjcect;
  ResponseType responseType;
  Map<String, String>? customMap;
  String key;
  AutoRestCustom(
      {this.customMap,
      required this.action,
      required this.key,
      required this.responseObjcect,
      required this.responseType});
  ResponseType getCustomViewResponseType() {
    return responseType;
  }

  String getCustomViewKey() {
    return key;
  }

  @override
  Future<T?> viewCall(
    int iD, {
    OnResponseCallback? onResponse,
  }) async {
    this.iD = iD;
    var response = await getRespones(
        onResponse: onResponse, serverActions: ServerActions.view);
    if (response == null) return null;
    if (response.statusCode == 200) {
      return responseObjcect.fromJson(convert.jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      ServerResponseMaster serverResponse =
          ServerResponseMaster.fromJson(convert.jsonDecode(response.body));
      onResponse?.onServerFailureResponse(serverResponse);
      //throw Exception('Failed to load album');
      return null;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return null;
    }
  }

  @override
  Future<List<T>?> listCall(
      {int? count, int? page, OnResponseCallback? onResponse}) async {
    var response = await getRespones(
        itemCount: count,
        pageIndex: page,
        onResponse: onResponse,
        serverActions: ServerActions.list);

    if (response == null) return null;
    if (response.statusCode == 200) {
      Iterable l = convert.jsonDecode(response.body);
      return List<T>.from(l.map((model) => responseObjcect.fromJson(model)));
    } else if (response.statusCode == 401) {
      ServerResponseMaster serverResponse =
          ServerResponseMaster.fromJson(convert.jsonDecode(response.body));
      onResponse?.onServerFailureResponse(serverResponse);
      return null;
    } else {
      return null;
    }
  }

  @override
  String? getCustomAction() {
    return action;
  }

  @override
  Map<String, String> get getCustomMap => customMap ?? super.getCustomMap;

  @override
  T fromJsonViewAbstract(Map<String, dynamic> json) {
    return responseObjcect.fromJson(json);
  }

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    return responseObjcect.toJson();
  }

  @override
  Map<String, IconData> getFieldIconDataMap() {
    // TODO: implement getFieldIconDataMap
    throw UnimplementedError();
  }

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) {
    // TODO: implement getFieldLabelMap
    throw UnimplementedError();
  }

  @override
  String? getMainDrawerGroupName(BuildContext context) {
    // TODO: implement getMainDrawerGroupName
    throw UnimplementedError();
  }

  @override
  List<String> getMainFields({BuildContext? context}) {
    // TODO: implement getMainFields
    throw UnimplementedError();
  }

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) {
    // TODO: implement getMainHeaderLabelTextOnly
    throw UnimplementedError();
  }

  @override
  String getMainHeaderTextOnly(BuildContext context) {
    // TODO: implement getMainHeaderTextOnly
    throw UnimplementedError();
  }

  @override
  IconData getMainIconData() {
    // TODO: implement getMainIconData
    throw UnimplementedError();
  }

  @override
  T getSelfNewInstance() {
    return responseObjcect;
  }

  @override
  String? getTableNameApi() => action;
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
