import 'dart:collection';
import 'dart:convert' as convert;
import 'package:flutter_view_controller/configrations.dart';
import 'package:flutter_view_controller/encyptions/encrypter.dart';
import 'package:flutter_view_controller/flutter_view_controller.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/models/servers/server_response_master.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/test_var.dart';
import 'package:http/http.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:reflectable/reflectable.dart';

import 'servers/server_helpers.dart';

@GlobalQuantifyCapability(r"^.(SomeClass|SomeEnum)", reflector)
class Reflector extends Reflectable {
  const Reflector()
      : super(invokingCapability, declarationsCapability,
            typeRelationsCapability);
}

const reflector = Reflector();

abstract class ViewAbstractApi<T> extends ViewAbstractBase<T> {
  @JsonKey(ignore: true)
  int _page = 0;
  @JsonKey(ignore: true)
  List<T>? _lastSearchViewAbstractByTextInputList;

 
  List<T>? get getLastSearchViewByTextInputList =>
      _lastSearchViewAbstractByTextInputList;

  dynamic getListSearchViewByTextInputList(String field, String fieldValue) {
    return getLastSearchViewByTextInputList?.firstWhereOrNull((element) =>
        (element as ViewAbstract)
            .getFieldValue(field)
            .toString()
            .toLowerCase()
            .contains(fieldValue.toLowerCase()));
  }

  int get getPageIndex => _page;

  int get getPageItemCount => 5;

  String? getCustomAction() {
    return null;
  }

  bool requireObjects() {
    return true;
  }

  List<String>? requireObjectsList() {
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
      int? pageIndex}) {
    Map<String, String> mainBody = HashMap<String, String>();
    mainBody.addAll(getBodyExtenstionParams());
    mainBody.addAll(getBodyCurrentAction(action,
        fieldBySearchQuery: fieldBySearchQuery,
        searchQuery: searchQuery,
        itemCount: itemCount,
        pageIndex: pageIndex));
    return mainBody;
  }

  Future<Map<String, String>> getHeadersExtenstion() async {
    Map<String, String> defaultHeaders = HashMap<String, String>();
    defaultHeaders['Auth'] =
        Encriptions.encypt("HIIAMANANDROIDUSERFROMSAFFOURYCOMPANY");

    defaultHeaders['X-Authorization'] =
        "YmUxN2E4ZjBlYjE4ZmU0OYkrl2fiKec95AFcix7iEoV7KMO2aRZ9WxKEN7SVYVRy1a2DyFTrAFZMNX1NTqsK8AugH2/9baf69dvhMJNBEARIuuHyaw9e0mm3HAHSGUnj5z0DjMf3m99KRCsrki8k15sG9A4Sxy897NLD3d7Ti79xXRUqYZjua4omEoxfS/63Opwaik3lVVTB6BLhHmwtOEwFjfB/qCLYaCc8PMqXbHV2K0o4kumU4Tl0LjSl0jMFNHTWsNEF3y9YLIrvsqjkgO8WOIgv/o+5FTG/MatJ5Jqs7RRMYICWaZXqDNC6K92qm475jX4Z47o1X81Pi3TDyoOzAhpQtIe+p7MBqrEDwFw=";

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
      int? pageIndex}) async {
    try {
      return await getHttp().post(Uri.parse(URLS.BASE_URL),
          headers: await getHeaders(),
          body: getBody(serverActions,
              searchQuery: searchQuery,
              fieldBySearchQuery: fieldBySearchQuery,
              itemCount: itemCount,
              pageIndex: pageIndex));
    } on Exception catch (e) {
      // Display an alert, no internet
      onResponse?.onServerFailure(e);
      return null;
    } catch (err) {
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
        onResponse: onResponse, serverActions: ServerActions.add);
    if (response == null) return null;
    return null;
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
    Iterable l = convert.jsonDecode(convert.jsonEncode(productsJson));
    return List<T>.from(l.map((model) => fromJsonViewAbstract(model)));
  }

  Future<List<T>?> listCall(int count, int page,
      {OnResponseCallback? onResponse}) async {
    var response = await getRespones(
        onResponse: onResponse, serverActions: ServerActions.list);

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
      int? pageIndex}) {
    Map<String, String> mainBody = HashMap();
    String? customAction = getCustomAction();
    mainBody['action'] = action == ServerActions.search ||
            action == ServerActions.search_by_field ||
            action == ServerActions.search_viewabstract_by_field
        ? "list"
        : customAction ?? action.toString().split(".").last;
    mainBody['objectTables'] = convert.jsonEncode(requireObjects());
    mainBody['detailTables'] = requireObjectsList() == null
        ? convert.jsonEncode([])
        : convert.jsonEncode(requireObjectsList());

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
        break;
      case ServerActions.search:
        mainBody['searchStringQuery'] = searchQuery?.trim() ?? "";
        mainBody['start'] =
            itemCount?.toString() ?? getPageItemCount.toString();
        mainBody['end'] = pageIndex?.toString() ?? getPageIndex.toString();
        break;
      case ServerActions.search_by_field:
        mainBody['<$fieldBySearchQuery>'] = searchQuery?.trim() ?? "";
        mainBody['searchByFieldName'] = fieldBySearchQuery ?? "";

        break;
      case ServerActions.search_viewabstract_by_field:
        mainBody['<$fieldBySearchQuery>'] = searchQuery?.trim() ?? "";
        mainBody['searchViewAbstractByFieldName'] = fieldBySearchQuery ?? "";
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
}
