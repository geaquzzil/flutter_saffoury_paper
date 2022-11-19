import 'dart:collection';
import 'dart:convert' as convert;
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_view_controller/configrations.dart';
import 'package:flutter_view_controller/encyptions/encrypter.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/models/servers/server_response_master.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/test_var.dart';
import 'package:http/http.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'servers/server_helpers.dart';

abstract class ViewAbstractApi<T> extends ViewAbstractBase<T> {
  @JsonKey(ignore: true)
  int _page = 0;

  @JsonKey(ignore: true)
  List<T>? _lastSearchViewAbstractByTextInputList;

  List<T>? get getLastSearchViewByTextInputList =>
      _lastSearchViewAbstractByTextInputList;

  @JsonKey(ignore: true)
  Map<String, String>? _customMap;

  Map<String, String> getCustomMapOnSearch() => {};

  Map<String, String> get getCustomMap => _customMap ?? {};

  void setCustomMap(Map<String, String> customMap) {
    _customMap = customMap;
  }

  

  dynamic getListSearchViewByTextInputList(String field, String fieldValue) {
    debugPrint(
        "getListSearchViewByTextInputList list=>$getLastSearchViewByTextInputList");
    debugPrint(
        "getListSearchViewByTextInputList value=>$fieldValue field $field");
    return getLastSearchViewByTextInputList?.firstWhereOrNull((element) =>
        (element as ViewAbstract)
            .getFieldValue(field)
            .toString()
            .toLowerCase()
            .contains(fieldValue.toLowerCase()));
  }

  int get getPageIndex => _page;

  int get getPageItemCount => 20;

  String? getCustomAction() {
    return null;
  }

  bool isRequiredObjects() {
    return true;
  }

  List<String>? isRequiredObjectsList() {
    return null;
  }

  Map<String, String> getBodyExtenstionParams() => {};

  Map<String, String> getBodyCurrentActionASC(ServerActions? action) {
    Map<String, String> map = HashMap<String, String>();

    return map;
  }

  Map<String, String> getBody(ServerActions? action,
      {String? fieldBySearchQuery,
      String? searchQuery,
      int? itemCount,
      int? pageIndex,
      ViewAbstract? printObject}) {
    Map<String, String> mainBody = HashMap<String, String>();
    mainBody.addAll(getBodyExtenstionParams());
    mainBody.addAll(getBodyCurrentAction(action,
        fieldBySearchQuery: fieldBySearchQuery,
        searchQuery: searchQuery,
        itemCount: itemCount,
        pageIndex: pageIndex,
        printObject: printObject));
    return mainBody;
  }

  Future<Map<String, String>> getHeadersExtenstion() async {
    Map<String, String> defaultHeaders = HashMap<String, String>();
    defaultHeaders['Platform'] = "Flutter";
    defaultHeaders['Auth'] =
        Encriptions.encypt("HIIAMANANDROIDUSERFROMSAFFOURYCOMPANY");

    defaultHeaders['X-Authorization'] =
        "WNYDGno8agC7nVmX99/uxyz24UgjvUTsjWFk3T94bERF9JLgBubq4cwiga3q5r9XExvUiE5rezZ5axsWvBjfmOwyW0GL34NS0y5y1UeVM12OU6JLnAEWfO6TxkMe7O9nr+H1LUkn4uYhVJFcJ0t8pYZF9iO7UHQXZTnDzTRQ4vnDRrWazwgtPXrBjMHNrYzNhxiuBzsH5CGtE2ZPnX+slhCI4F1KWfJHrXJX7n+Ddvc=";

    bool hasUser = await Configurations.hasSavedValue(AuthUser());
    if (hasUser) {
      AuthUser authUser = await Configurations.get(AuthUser());
      defaultHeaders['X-Authorization'] =
          Encriptions.encypt(authUser.toJsonString());
    }

    return defaultHeaders;
  }

  Future<Map<String, String>> getHeaders() async {
    Map<String, String> defaultHeaders = HashMap<String, String>();
    defaultHeaders.addAll(URLS.requestHeaders);
    defaultHeaders.addAll(await getHeadersExtenstion());
    return defaultHeaders;
  }

  Future<Response?> getRespones(
      {ServerActions? serverActions,
      OnResponseCallback? onResponse,
      String? searchQuery,
      String? fieldBySearchQuery,
      int? itemCount,
      int? pageIndex,
      ViewAbstract? printObject}) async {
    try {
      return await getHttp().post(
          Uri.parse(serverActions == ServerActions.print
              ? URLS.BASE_URL_PRINT
              : URLS.BASE_URL),
          headers: await getHeaders(),
          body: getBody(serverActions,
              searchQuery: searchQuery,
              fieldBySearchQuery: fieldBySearchQuery,
              itemCount: itemCount,
              pageIndex: pageIndex,
              printObject: printObject));
    } on Exception catch (e) {
      // Display an alert, no internet
      onResponse?.onServerFailure(e);
      return null;
    } catch (err) {
      return null;
    }
  }

  ///call only with custom action and added custom params
  Future<T?> callApi() async {
    var response = await getRespones(serverActions: ServerActions.call);
    debugPrint("callApi $response");
    debugPrint("callApi status code ${response?.statusCode}");
    debugPrint("callApi response =>${response?.body}");

    if (response == null) return null;
    if (response.statusCode == 200) {
      return fromJsonViewAbstract(convert.jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      ServerResponseMaster serverResponse =
          ServerResponseMaster.fromJson(convert.jsonDecode(response.body));
      return null;
    } else {
      return null;
    }
  }

  Future<T?> viewCall(int iD, {OnResponseCallback? onResponse}) async {
    var response = await getRespones(
        onResponse: onResponse, serverActions: ServerActions.view);
    if (response == null) return null;
    if (response.statusCode == 200) {
      return fromJsonViewAbstract(convert.jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      ServerResponseMaster serverResponse =
          ServerResponseMaster.fromJson(convert.jsonDecode(response.body));
      onResponse?.onServerFailureResponse(serverResponse.serverResponse);
      //throw Exception('Failed to load album');
      return null;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return null;
    }
  }

  Future<T?> addCall({OnResponseCallback? onResponse}) async {
    var response = await getRespones(
        onResponse: onResponse,
        serverActions: isEditing() ? ServerActions.edit : ServerActions.add);
    if (response == null) return null;
    if (response.statusCode == 200) {
      return fromJsonViewAbstract(convert.jsonDecode(response.body));
    }
    return null;
  }

  // Future<E> getServerDataApi<E extends ServerData>(
  //     BuildContext context, E data) async {

  //   Map<String, String> mainBody = HashMap<String, String>();
  //   mainBody["action"] = "list_server_data";
  //   Response? response = await getHttp().post(Uri.parse(URLS.BASE_URL),
  //       headers: await getHeaders(), body: mainBody);

  // }
  Future<List<ViewAbstract>> searchViewAbstractByTextInputViewAbstract(
      {required String field,
      required String searchQuery,
      OnResponseCallback? onResponse}) async {
    var response = await getRespones(
        onResponse: onResponse,
        fieldBySearchQuery: field,
        serverActions: ServerActions.search_viewabstract_by_field,
        searchQuery: searchQuery);

    if (response == null) return [];
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      Iterable l = convert.jsonDecode(response.body);
      List<T> list =
          List<T>.from(l.map((model) => fromJsonViewAbstract(model)));
      setLastSearchViewAbstractByTextInputList(list);

      return list.cast();
    } else if (response.statusCode == 401) {
      ServerResponseMaster serverResponse =
          ServerResponseMaster.fromJson(convert.jsonDecode(response.body));
      onResponse?.onServerFailureResponse(serverResponse.serverResponse);
      return [];
    } else {
      return [];
    }
  }

  Future<List<String>> searchViewAbstractByTextInput(
      {required String field,
      required String searchQuery,
      OnResponseCallback? onResponse}) async {
    var response = await getRespones(
        onResponse: onResponse,
        fieldBySearchQuery: field,
        serverActions: ServerActions.search_viewabstract_by_field,
        searchQuery: searchQuery);

    if (response == null) return [];
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      Iterable l = convert.jsonDecode(response.body);
      List<T> list =
          List<T>.from(l.map((model) => fromJsonViewAbstract(model)));
      setLastSearchViewAbstractByTextInputList(list);

      return list
          .map((e) => (e as ViewAbstract).getFieldValue(field).toString())
          .toList();
    } else if (response.statusCode == 401) {
      ServerResponseMaster serverResponse =
          ServerResponseMaster.fromJson(convert.jsonDecode(response.body));
      onResponse?.onServerFailureResponse(serverResponse.serverResponse);
      return [];
    } else {
      return [];
    }
  }

  Future<List<String>> searchByFieldName(
      {required String field,
      required String searchQuery,
      OnResponseCallback? onResponse}) async {
    var response = await getRespones(
        onResponse: onResponse,
        fieldBySearchQuery: field,
        serverActions: ServerActions.search_by_field,
        searchQuery: searchQuery);

    if (response == null) return [];
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      Iterable l = convert.jsonDecode(response.body);
      List<T> list =
          List<T>.from(l.map((model) => fromJsonViewAbstract(model)));

      return list
          .map((e) => (e as ViewAbstract).getFieldValue(field).toString())
          .toList();
    } else if (response.statusCode == 401) {
      ServerResponseMaster serverResponse =
          ServerResponseMaster.fromJson(convert.jsonDecode(response.body));
      onResponse?.onServerFailureResponse(serverResponse.serverResponse);
      return [];
    } else {
      return [];
    }
  }

  Future<List<T>>? listApiReduceSizes(String customField) async {
    var response = await getRespones(
        serverActions: ServerActions.list_reduce_size,
        searchQuery: customField);

    if (response == null) return [];
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      Iterable l = convert.jsonDecode(response.body);
      return List<T>.from(l.map((model) => fromJsonViewAbstract(model)));
    } else if (response.statusCode == 401) {
      return [];
    } else {
      return [];
    }
  }

  Future<List<T>> search(int count, int pageIndex, String searchQuery,
      {OnResponseCallback? onResponse}) async {
    var response = await getRespones(
        onResponse: onResponse,
        serverActions: ServerActions.search,
        searchQuery: searchQuery,
        itemCount: count,
        pageIndex: pageIndex);

    if (response == null) return [];
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      Iterable l = convert.jsonDecode(response.body);
      return List<T>.from(l.map((model) => fromJsonViewAbstract(model)));
    } else if (response.statusCode == 401) {
      ServerResponseMaster serverResponse =
          ServerResponseMaster.fromJson(convert.jsonDecode(response.body));
      onResponse?.onServerFailureResponse(serverResponse.serverResponse);
      return [];
    } else {
      return [];
    }
  }

  Future<List<T>?> listCallFake() async {
    try {
      Iterable l = convert.jsonDecode(convert.jsonEncode(productsJson));
      return List<T>.from(l.map((model) => fromJsonViewAbstract(model)));
    } catch (e) {
      debugPrint("listCallFake ${e.toString()}");
    }
    return null;
  }

  Future<Response?> printCall(ViewAbstract printObject) async {
    var response = await getRespones(
        serverActions: ServerActions.print, printObject: printObject);

    if (response == null) return null;
    if (response.statusCode == 200) {
      return response;
    } else if (response.statusCode == 401) {
      return null;
    } else {
      return null;
    }
  }

  Future<List<T>?> listCall(
      {int? count, int? page, OnResponseCallback? onResponse}) async {
    debugPrint("listCall count=> $count page=>$page");
    var response = await getRespones(
        itemCount: count,
        pageIndex: page,
        onResponse: onResponse,
        serverActions: ServerActions.list);

    if (response == null) return null;
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      //todo change this when finish testing
      Iterable l = convert.jsonDecode(response.body);
      return List<T>.from(l.map((model) => fromJsonViewAbstract(model)));
    } else if (response.statusCode == 401) {
      ServerResponseMaster serverResponse =
          ServerResponseMaster.fromJson(convert.jsonDecode(response.body));
      onResponse?.onServerFailureResponse(serverResponse.serverResponse);
      return null;
    } else {
      return null;
    }
  }

  HttpWithMiddleware getHttp() => HttpWithMiddleware.build(middlewares: [
        HttpLogger(logLevel: LogLevel.BODY),
      ]);

  Map<String, String> getBodyCurrentAction(ServerActions? action,
      {String? fieldBySearchQuery,
      String? searchQuery,
      int? itemCount,
      int? pageIndex,
      ViewAbstract? printObject}) {
    Map<String, String> mainBody = HashMap();
    String? customAction = getCustomAction();
    mainBody['action'] = action == ServerActions.search ||
            action == ServerActions.search_by_field ||
            action == ServerActions.search_viewabstract_by_field
        ? "list"
        : action == ServerActions.list_reduce_size
            ? "list_reduce_size"
            : customAction ?? action.toString().split(".").last;
    mainBody['objectTables'] = convert.jsonEncode(isRequiredObjects());
    mainBody['detailTables'] = isRequiredObjectsList() == null
        ? convert.jsonEncode([])
        : convert.jsonEncode(isRequiredObjectsList());

    String? table = getTableNameApi();
    if (table != null) {
      mainBody['table'] = table;
    }
    switch (action) {
      case ServerActions.add:
        //TODO multiple add
        mainBody['data'] = convert.jsonEncode(toJsonViewAbstract());
        break;

      case ServerActions.view:
      case ServerActions.delete_action:
        mainBody['<iD>'] = iD.toString();
        break;
      case ServerActions.list:
        mainBody.addAll(getBodyCurrentActionASC(action));
        mainBody['start'] =
            itemCount?.toString() ?? getPageItemCount.toString();
        mainBody['end'] = pageIndex?.toString() ?? getPageIndex.toString();
        if (getCustomMap.isEmpty) {
          String? hasSortByFieldDefault =
              (this as ViewAbstractFilterable).getSortByFieldName();
          if (hasSortByFieldDefault != null) {
            mainBody[(this as ViewAbstractFilterable).getSortByType().name] =
                hasSortByFieldDefault;
          }
        }
        mainBody.addAll(getCustomMap);
        break;
      case ServerActions.call:
        mainBody.addAll(getCustomMap);
        break;
      case ServerActions.search:
        mainBody['searchStringQuery'] = searchQuery?.trim() ?? "";
        mainBody['start'] =
            itemCount?.toString() ?? getPageItemCount.toString();
        mainBody['end'] = pageIndex?.toString() ?? getPageIndex.toString();

        mainBody.addAll(getCustomMapOnSearch());
        break;

      case ServerActions.list_reduce_size:
        mainBody['<fieldToSelectList>'] = searchQuery?.trim() ?? "";
        break;
      case ServerActions.search_by_field:
        mainBody['<$fieldBySearchQuery>'] = searchQuery?.trim() ?? "";
        mainBody['searchByFieldName'] = fieldBySearchQuery ?? "";

        break;
      case ServerActions.search_viewabstract_by_field:
        mainBody['<$fieldBySearchQuery>'] = searchQuery?.trim() ?? "";
        mainBody['searchViewAbstractByFieldName'] = fieldBySearchQuery ?? "";
        break;
      case ServerActions.print:
        mainBody['data'] = printObject?.toJsonString() ?? "";
        break;
      default:
        break;
    }

    return mainBody;
  }

  void setLastSearchViewAbstractByTextInputList(List<T>? lastList) {
    _lastSearchViewAbstractByTextInputList = lastList;
  }

  set setPageIndex(int page) {
    _page = page;
  }

  String toJsonString() {
    return jsonEncode(toJsonViewAbstract());
  }

  T fromJsonViewAbstract(Map<String, dynamic> json);
  Map<String, dynamic> toJsonViewAbstract();
}
