// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:collection';
import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:flutter_view_controller/configrations.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/interfaces/listable_interface.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/models/request_options.dart';
import 'package:flutter_view_controller/models/servers/server_response_master.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/models/view_abstract_inputs_validaters.dart';
import 'package:flutter_view_controller/providers/filterables/filterable_provider.dart';
import 'package:flutter_view_controller/test_var.dart';
import 'package:http/http.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';

import 'servers/server_helpers.dart';

abstract class ViewAbstractApi<T> extends ViewAbstractBase<T> {
  @JsonKey(includeFromJson: false, includeToJson: false)
  RequestOptions? _requestOption;

  @JsonKey(includeFromJson: false, includeToJson: false)
  int _page = 0;

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<T>? _lastSearchViewAbstractByTextInputList;
  @JsonKey(includeFromJson: false, includeToJson: false)
  static Map<String, List<ViewAbstract?>>? _lastListReduseSizeViewAbstract;

  List<T>? get getLastSearchViewByTextInputList =>
      _lastSearchViewAbstractByTextInputList;

  @Deprecated("use RequestOptions")
  @JsonKey(includeFromJson: false, includeToJson: false)
  Map<String, String>? _customMap;
  @Deprecated("use RequestOptions")
  @JsonKey(includeFromJson: false, includeToJson: false)
  Map<String, String>? _customMapOnSearch;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final List<SearchCache> _searchCache = [];

  @JsonKey(includeFromJson: false, includeToJson: false)
  Map<String, String> get getCustomMapOnSearch => _customMapOnSearch ?? {};

  Map<String, String> get getCustomMap => _customMap ?? {};

  RequestOptions  getRequestOption({ServerActions? action}) {
    if (this._requestOption == null) {
      this._requestOption = RequestOptions(
        searchByField: getCustomMap,
        requestObjcets: isRequiredObjects(),
        requestLists: ,
          countPerPage: getPageItemCount,
          sortBy: castViewAbstract().getSortFieldValue);
    }
    return this._requestOption!;
  }

  set setRequestOption(RequestOptions value) => this._requestOption = value;

  RequestOptions getRequestOptionCopyWith(RequestOptions option) {
    return getRequestOption.copyWithObjcet(option: option);
  }

  void setCustomMap(Map<String, String> customMap) {
    _customMap = customMap;
  }

  void setCustomMapOnSearch(Map<String, String> customMap) {
    _customMapOnSearch = customMap;
  }

  void setCustomMapOnListAndSearch(Map<String, String> customMap) {
    setCustomMap(customMap);
    setCustomMapOnSearch(customMap);
  }

  void setCustomMapAsSearchable(String? searchQuery) {
    _customMap = <String, String>{};
    _customMap!["searchStringQuery"] = searchQuery ?? "";
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

  @Deprecated("use RequestOptions")
  int get getPageIndex => _page;

  @Deprecated("use RequestOptions")
  int get getPageItemCount => 20;

  @Deprecated("use RequestOptions")
  int get getPageItemCountSearch => 20;

  String? getCustomAction() {
    return null;
  }

  @Deprecated("use RequestOptions")
  bool isRequiredObjects() {
    return true;
  }

  Map<ServerActions, List<String>>? canGetObjectWithoutApiCheckerList() {
    return null;
  }

  /// call api to get objects list if its false
  bool canGetObjectWithoutApiChecker(ServerActions action) {
    return false;
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
      Map<String, FilterableProviderHelper>? map,
      int? pageIndex,
      ViewAbstract? printObject}) {
    Map<String, String> mainBody = HashMap<String, String>();
    mainBody.addAll(getBodyExtenstionParams());
    mainBody.addAll(getBodyCurrentAction(action,
        fieldBySearchQuery: fieldBySearchQuery,
        searchQuery: searchQuery,
        itemCount: itemCount,
        map: map,
        pageIndex: pageIndex,
        printObject: printObject));
    return mainBody;
  }

  Future<Map<String, String>> getHeadersExtenstion() async {
    Map<String, String> defaultHeaders = HashMap<String, String>();
    bool hasUser = await Configurations.hasSavedValue(AuthUser());
    if (hasUser) {
      AuthUser? authUser = await Configurations.get(AuthUser());
      String? token = authUser?.barrerToken;
      if (token != null) {
        defaultHeaders['Authorization'] = 'Bearer $token';
      }
    }
    return defaultHeaders;
  }

  Future<Map<String, String>> getHeaders() async {
    Map<String, String> defaultHeaders = HashMap<String, String>();
    defaultHeaders.addAll(URLS.requestHeaders);
    defaultHeaders.addAll(await getHeadersExtenstion());
    return defaultHeaders;
  }

  Uri _getUrl(
      {String? tableName,
      String? customAction,
      int? iD,
      Map<String, dynamic>? params}) {
    var url = Uri(
        scheme: "http",
        queryParameters: params,
        host: URLS.getBaseUrl(),
        pathSegments: [
          if (customAction != null || tableName != null)
            (customAction ?? tableName) ?? "",
          if (iD != null) "$iD"
        ]);
    return url;
  }

  Future<Response?> _getListResponse({RequestOptions? option}) async {
    return await getHttp().get(
        _getUrl(
            customAction: getCustomAction(),
            tableName: getTableNameApi(),
            params: getRequestOption
                .copyWithObjcet(option: option)
                .getRequestParams()),
        headers: await getHeaders());
  }

  Future<Response?> _getViewResponse({int? customID}) async {
    return await getHttp().get(
        _getUrl(
            iD: customID ?? iD,
            tableName: getTableNameApi(),
            params: getRequestOption.getRequestParamsOnlyForings(),
            customAction: getCustomAction()),
        headers: await getHeaders());
  }

  Future<Response?> _getEditResponse() async {
    var headers = await getHeaders();
    return await getHttp().put(
        _getUrl(
            iD: iD,
            tableName: getTableNameApi(),
            customAction: getCustomAction()),
        headers: headers,
        body: toJsonString());
  }

  Future<Response?> _getAddResponse() async {
    var headers = await getHeaders();
    return await getHttp().post(
        _getUrl(tableName: getTableNameApi(), customAction: getCustomAction()),
        headers: headers,
        body: toJsonString());
  }

  Future<Response?> _getDeleteResponse() async {
    var headers = await getHeaders();
    return await getHttp().delete(
        _getUrl(
            iD: iD,
            tableName: getTableNameApi(),
            customAction: getCustomAction()),
        headers: headers);
  }

  @Deprecated("")
  Future<Response?> getRespones(
      {ServerActions? serverActions,
      OnResponseCallback? onResponse,
      Map<String, FilterableProviderHelper>? map,
      String? searchQuery,
      String? fieldBySearchQuery,
      int? itemCount,
      int? pageIndex,
      ViewAbstract? printObject}) async {
    try {
      return await getHttp().post(
          Uri.parse(serverActions == ServerActions.print
              ? URLS.getBaseUrlPrint()
              : URLS.getBaseUrl()),
          headers: await getHeaders(),
          body: getBody(serverActions,
              searchQuery: searchQuery,
              fieldBySearchQuery: fieldBySearchQuery,
              itemCount: itemCount,
              pageIndex: pageIndex,
              map: map,
              printObject: printObject));
    } on Exception catch (e) {
      // Display an alert, no internet
      onResponse?.onClientFailure(e);
      debugPrint(e.toString());
      return null;
    } catch (err) {
      debugPrint(err.toString());
      return null;
    }
  }

  ///call only with custom action and added custom params
  Future<T?> callApi({required BuildContext context}) async {
    var response = await getRespones(serverActions: ServerActions.call);
    // debugPrint("ViewAbstractApi ViewAbstractApicallApi $response");

    debugPrint(
        "ViewAbstractApi ViewAbstractApi callApi status code ${response?.statusCode}");
    // debugPrint("ViewAbstractApi ViewAbstractApi callApi response =>${response?.body}");

    if (response == null) return null;
    if (response.statusCode == 200) {
      return fromJsonViewAbstract(convert.jsonDecode(response.body));
    } else {
      onCallCheckError(response: response, context: context);
      return null;
    }
  }

  T onResponse200K(T oldValue) {
    return this as T;
  }

  Future<T?> viewCallGetFirstFromList(int iD,
      {required BuildContext context}) async {
    this.iD = iD;
    var response = await getRespones(serverActions: ServerActions.view);
    if (response == null) return null;
    if (response.statusCode == 200) {
      Iterable l = convert.jsonDecode(response.body);

      List<T> t = List<T>.from(l.map((model) => fromJsonViewAbstract(model)));
      return (t[0] as ViewAbstract).onResponse200K(this as ViewAbstract);
    } else {
      onCallCheckError(response: response, context: context);
      return null;
    }
  }

  Future<List<T>?> listCall({
    required BuildContext context,
    RequestOptions? option,
    OnResponseCallback? onResponse,
  }) async {
    try {
      var response = await _getListResponse(option: option);
      if (response == null) return null;
      if (response.statusCode == 200) {
        Iterable l = convert.jsonDecode(response.body);
        List<T> t = List<T>.from(l.map((model) => fromJsonViewAbstract(model)));
        return t;
      } else {
        onCallCheckError(
            onResponse: onResponse, response: response, context: context);
        return null;
      }
    } catch (e) {
      onResponse?.onClientFailure(e);
    }
    return null;
  }

  Future<T?> viewCall({
    required BuildContext context,
    int? customID,
    OnResponseCallback? onResponse,
  }) async {
    try {
      var response = await _getViewResponse(customID: customID);
      if (response == null) return null;
      if (response.statusCode == 200) {
        return fromJsonViewAbstract(convert.jsonDecode(response.body));
      } else {
        onCallCheckError(response: response, context: context);
        return null;
      }
    } on Exception catch (e) {
      onResponse?.onClientFailure(e);
    }
    return null;
  }

  Future<T?> addCall({
    OnResponseCallback? onResponse,
    required BuildContext context,
  }) async {
    var response = await getRespones(
        onResponse: onResponse,
        serverActions: isEditing() ? ServerActions.edit : ServerActions.add);
    if (response == null) return null;
    if (response.statusCode == 200) {
      return fromJsonViewAbstract(convert.jsonDecode(response.body));
    } else {
      onCallCheckError(
          onResponse: onResponse, response: response, context: context);
      return null;
    }
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
      required BuildContext context,
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
    } else {
      onCallCheckError(
          onResponse: onResponse, response: response, context: context);
      return [];
    }
  }

  Future<List<String>> searchViewAbstractByTextInput(
      {required String field,
      required String searchQuery,
      OnResponseCallback? onResponse,
      required BuildContext context}) async {
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
    } else {
      onCallCheckError(
          onResponse: onResponse, response: response, context: context);
      return [];
    }
  }

  Future<List<String>> searchByFieldName(
      {required String field,
      required String searchQuery,
      OnResponseCallback? onResponse,
      required BuildContext context}) async {
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
    } else {
      onCallCheckError(
          onResponse: onResponse, response: response, context: context);
      return [];
    }
  }

  Future<List<T>>? listApiReduceSizes({required BuildContext context}) async {
    String customField = (this as ViewAbstract).getFieldToReduceSize();
    if (getLastReduseSize(customField).isNotEmpty) {
      return getLastReduseSize(customField).cast();
    }
    var response = await getRespones(
        serverActions: ServerActions.list_reduce_size,
        searchQuery: customField);

    if (response == null) return [];
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      Iterable l = convert.jsonDecode(response.body);
      List<T> list =
          List<T>.from(l.map((model) => fromJsonViewAbstract(model)));

      setListReduseSizeViewAbstract(customField, list.cast());
      return list;
    } else {
      onCallCheckError(response: response, context: context);
      return [];
    }
  }

  Future<List<T>> search(int count, int pageIndex, String searchQuery,
      {OnResponseCallback? onResponse,
      Map<String, FilterableProviderHelper>? filter,
      bool cache = false,
      required BuildContext context}) async {
    var response = await getRespones(
        onResponse: onResponse,
        map: filter,
        serverActions: ServerActions.search,
        searchQuery: searchQuery,
        itemCount: count,
        pageIndex: pageIndex);

    if (response == null) return [];
    if (response.statusCode == 200) {
//       final parser = ResultsParser<T>(response.body, castViewAbstract());
// parser.parseInBackground();
      Iterable l = convert.jsonDecode(response.body);
      List<T> t = List<T>.from(l.map((model) => fromJsonViewAbstract(model)));
      //TODO if (cache) {
      //   return SearchCache.getResultAndAdd(searchQuery, t, _searchCache).cast();
      // }
      return t;
    } else {
      onCallCheckError(
          onResponse: onResponse, response: response, context: context);
      return [];
    }
  }

  Future<List<T>?> listCallFake() async {
    try {
      Iterable l = convert.jsonDecode(convert.jsonEncode(productsJson));
      return List<T>.from(l.map((model) => fromJsonViewAbstract(model)));
    } catch (e) {
      debugPrint(
          "ViewAbstractApi ViewAbstractApi listCallFake ${e.toString()}");
    }
    return null;
  }

  Future<Response?> printCall(ViewAbstract printObject,
      {required BuildContext context}) async {
    var response = await getRespones(
        serverActions: ServerActions.print, printObject: printObject);

    if (response == null) return null;
    if (response.statusCode == 200) {
      return response;
    } else {
      onCallCheckError(response: response, context: context);
      return null;
    }
  }

  String getErrorCodeMessage(BuildContext context, int code) {
    if (code == 500) {
      return AppLocalizations.of(context)!.error500;
    } else if (code == 401) {
      return AppLocalizations.of(context)!.error401;
    } else if (code == 400) {
      return AppLocalizations.of(context)!.error400;
    } else if (code == 200) {
      return AppLocalizations.of(context)!.success200;
    } else {
      return AppLocalizations.of(context)!.success200;
    }
  }

  void onCallCheckError(
      {OnResponseCallback? onResponse,
      dynamic response,
      required BuildContext context}) {
    if (response is Response) {
      if (onResponse == null) {
        debugPrint(
            "ViewAbstractApi onCallCheckError====> called but no response callback registered");
        return;
      }
      int statusCode = response.statusCode;

      if (statusCode >= 400 && statusCode <= 500) {
        //this is a error
        ServerResponseMaster serverResponse =
            ServerResponseMaster.fromJson(convert.jsonDecode(response.body));
        debugPrint(
            "ViewAbstractApi onCallCheckError====> called code:$statusCode  message : ${serverResponse.toJson()}");
        onResponse.onServerFailureResponse(
            (serverResponse.getFailureMessage(context)));
      }
    }
  }

  bool hasErrorOnDelete() {
    ViewAbstract t = this as ViewAbstract;
    bool res = t.serverStatus != "true" || t.serverStatus != "True";
    debugPrint("ViewAbstractApi ViewAbstractApi hasErrorOnDelete res: $res");
    return res;
  }

  bool successOnDelete() {
    return !hasErrorOnDelete();
  }

  void onCallCheck200Response(
      {required BuildContext context,
      required List list,
      required ServerActions action,
      required OnResponseCallback onResponse}) {
    int faildCount = list.where((i) => i.hasErrorOnDelete()).length;
    bool allSuccess = faildCount == 0;
    bool allFaild = faildCount == list.length;
    //TODO translate
    if (allSuccess) {
      onResponse.onServerResponse(AppLocalizations.of(context)!.successDeleted);
    } else if (allFaild) {
      onResponse.onServerFailureResponse(
          "ALL ${AppLocalizations.of(context)!.errOperationFailed}");
    } else {
      onResponse.onServerFailureResponse(
          "${AppLocalizations.of(context)!.errOperationFailed}: $faildCount");
    }
  }

  void deleteCall(BuildContext context,
      {required OnResponseCallback onResponse}) async {
    debugPrint("ViewAbstractApi deleteCall iD=> $iD ");
    var response = await getRespones(
        onResponse: onResponse, serverActions: ServerActions.delete_action);

    if (response == null) {
      // onResponse.onClientFailure("response is null");
      return;
    }
    if (response.statusCode == 200) {
      Iterable l = convert.jsonDecode(response.body);
      List list = List<T>.from(l.map((model) => fromJsonViewAbstract(model)));
      if (list.length == 1) {
        bool success = (list[0] as ViewAbstract).successOnDelete();
        if (success) {
          onResponse
              .onServerResponse(AppLocalizations.of(context)!.successDeleted);
        } else {
          onResponse.onServerFailureResponse(
              "${AppLocalizations.of(context)!.errOperationFailed}: ${(list[0] as ViewAbstract).serverStatus}");
        }
      } else {
        onCallCheck200Response(
            context: context,
            action: ServerActions.delete_action,
            list: list,
            onResponse: onResponse);
      }
    } else {
      onCallCheckError(
          onResponse: onResponse, response: response, context: context);
    }
  }

  List fromJsonViewAbstractList(String fromJsonView) {
    Iterable l = convert.jsonDecode(fromJsonView);
    return List.from(l.map((model) => fromJsonViewAbstract(model)));
  }

  String toJsonViewAbstractList(List list) {
    return jsonEncode(list.map((i) => i.toJson()).toList()).toString();
  }

  bool getBodyWithoutApi(ServerActions action) {
    bool canGetBody =
        (this as ViewAbstract).canGetObjectWithoutApiCheckerList()?[action] ==
            null;
    if (canGetBody) {
      debugPrint(
          "ViewAbstractApi BaseApiCallPageState getBodyWithoutApi skiped");
      return true;
    }
    bool res = (this as ViewAbstract).isNew() ||
        (this as ViewAbstract).canGetObjectWithoutApiChecker(action);
    debugPrint(
        "ViewAbstractApi BaseApiCallPageState getBodyWithoutApi result => $res");
    return res;
  }

  Future<List<T>> listCallNotNull(
      {int? count,
      int? page,
      OnResponseCallback? onResponse,
      Map<String, FilterableProviderHelper>? filter,
      required BuildContext context}) async {
    debugPrint("ViewAbstractApi listCall count=> $count page=>$page");
    var response = await getRespones(
        map: filter,
        itemCount: count,
        pageIndex: page,
        onResponse: onResponse,
        serverActions: ServerActions.list);

    if (response == null) return [];
    if (response.statusCode == 200) {
      // final parser = ResultsParser<T>(response.body, castViewAbstract());
      // return parser.parseInBackground();

      Iterable l = convert.jsonDecode(response.body);
      List<T> t = List<T>.from(l.map((model) => fromJsonViewAbstract(model)));

      return t;
    } else {
      onCallCheckError(
          onResponse: onResponse, response: response, context: context);
      return [];
    }
  }

  ViewAbstract castViewAbstract() {
    return this as ViewAbstract;
  }

  ListableInterface castListableInterface() {
    return (this as ListableInterface);
  }

  HttpWithMiddleware getHttp() {
    return HttpWithMiddleware.build(
        requestTimeout: const Duration(seconds: 120),
        middlewares: [
          HttpLogger(logLevel: LogLevel.BODY),
        ]);
  }

  Map<String, String> getBodyCurrentAction(ServerActions? action,
      {String? fieldBySearchQuery,
      String? searchQuery,
      Map<String, FilterableProviderHelper>? map,
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
    mainBody['forginList'] = convert.jsonEncode(isRequiredObjects());
    mainBody['forginObject'] = canGetObjectWithoutApiCheckerList() == null
        ? convert.jsonEncode([])
        : convert
            .jsonEncode(canGetObjectWithoutApiCheckerList()?[action] ?? []);

    String? table = getTableNameApi();
    if (table != null) {
      mainBody['table'] = table;
    }
    switch (action) {
      case ServerActions.view:
      case ServerActions.delete_action:
        mainBody['<iD>'] = iD.toString();
        break;
      case ServerActions.list:
        mainBody.addAll(getBodyCurrentActionASC(action));
        mainBody['countPerPage'] =
            itemCount?.toString() ?? getPageItemCount.toString();
        mainBody['page'] = pageIndex?.toString() ?? getPageIndex.toString();
        SortFieldValue? sort = (this as ViewAbstract).getSortFieldValue;
        if (sort != null) {
          mainBody.addAll(sort.getMap());
        }
        mainBody.addAll(getCustomMap);
        mainBody.addAll(castViewAbstract().getFilterableMap(map));
        break;
      case ServerActions.call:
        mainBody.addAll(getCustomMap);
        break;
      case ServerActions.search:
        mainBody['searchStringQuery'] = searchQuery?.trim() ?? "";
        mainBody['start'] =
            itemCount?.toString() ?? getPageItemCount.toString();
        mainBody['end'] = pageIndex?.toString() ?? getPageIndex.toString();

        mainBody.addAll(getCustomMapOnSearch);
        mainBody.addAll(castViewAbstract().getFilterableMap(map));
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

  List<ViewAbstract?> getLastReduseSize(String field) {
    return _lastListReduseSizeViewAbstract?["$T$field"] ?? [];
  }

  void setListReduseSizeViewAbstract(
      String field, List<ViewAbstract> lastList) {
    _lastListReduseSizeViewAbstract ??= {};
    _lastListReduseSizeViewAbstract!["$T$field"] = lastList;
  }

  set setPageIndex(int page) {
    _page = page;
  }

  String toJsonString() {
    return jsonEncode(toJsonViewAbstract());
  }

  T fromJsonViewAbstract(Map<String, dynamic> json);
  Map<String, dynamic> toJsonViewAbstract();

  Map<String, dynamic> toJsonViewAbstractForAutoCompleteField(
      BuildContext context) {
    Map<String, dynamic> map = toJsonViewAbstract();

    for (var element in map.entries) {
      if (element.value == null) continue;
      if (isViewAbstract(element.key)) {
        map[element.key] = getMirrorNewInstanceViewAbstract(element.key)
            .fromJsonViewAbstract(element.value);
        continue;
      }
      if (element.value is List) {
        map[element.key] =
            (fromJsonViewAbstract({element.key: element.value}) as ViewAbstract)
                .getFieldValue(element.key);
        continue;
      }

      FormFieldControllerType type =
          castViewAbstract().getInputType(element.key);
      if (type == FormFieldControllerType.COLOR_PICKER) {
        map[element.key] = (element.value as String).fromHex();
      } else if (type == FormFieldControllerType.DATE_TIME) {
        map[element.key] = (element.value as String).toDateTime();
      }
    }
    return map;
  }
}

class ViewAbstractListResponseHelper {
  int count;
  int faildCount;
  int successCount;
  ViewAbstractListResponseHelper({
    required this.count,
    required this.faildCount,
    required this.successCount,
  });
}

class ResultsParser<T> {
  // 1. pass the encoded json as a constructor argument
  final ViewAbstract viewAbstract;
  ResultsParser(this.encodedJson, this.viewAbstract);
  final String encodedJson;

  // 2. public method that does the parsing in the background
  Future<List<T>> parseInBackground() async {
    // create a port
    final p = ReceivePort();
    // spawn the isolate and wait for it to complete
    await Isolate.spawn(_decodeAndParseJson, p.sendPort);
    // get and return the result data
    return await p.first;
  }

  // 3. json parsing
  Future<void> _decodeAndParseJson(SendPort p) async {
    Iterable l = convert.jsonDecode(encodedJson);
    List<T> t = List<T>.from(
        l.map((model) => viewAbstract.fromJsonViewAbstract(model)));
    Isolate.exit(p, t);
  }
}

//TODO dispose this
class SearchCache {
  String query;
  List? response;
  SearchCache({
    required this.query,
    this.response,
  });
  static List getResultAndAdd(
      String query, List response, List<SearchCache> list) {
    SearchCache? search = getResult(query, list);
    if (search == null) {
      list.add(SearchCache(query: query, response: response));
      return response;
    }
    return search.response ?? [];
  }

  static void shouldAdd(String query, List response, List<SearchCache> list) {
    SearchCache? search = getResult(query, list);
    if (search == null) {
      list.add(SearchCache(query: query, response: response));
    }
  }

  static SearchCache? getResult(String query, List<SearchCache> list) {
    return list.firstWhereOrNull((s) {
      return query == s.query || query.contains(s.query);
    });
  }
}
