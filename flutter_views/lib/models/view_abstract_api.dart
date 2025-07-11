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
import 'package:flutter_view_controller/models/servers/server_response.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/models/view_abstract_inputs_validaters.dart';
import 'package:flutter_view_controller/test_var.dart';
import 'package:http/http.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';

import 'servers/server_helpers.dart';

abstract class ViewAbstractApi<T> extends ViewAbstractBase<T> {
  @JsonKey(includeFromJson: false, includeToJson: false)
  Map<ServerActions, RequestOptions> _requestOption = {};

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<T>? _lastSearchViewAbstractByTextInputList;

  @JsonKey(includeFromJson: false, includeToJson: false)
  static Map<String, List<ViewAbstract?>>? _lastListReduseSizeViewAbstract;

  RequestOptions? getRequestOption({required ServerActions action});
  Map<ServerActions, RequestOptions> getRequestOptionMap() {
    return _requestOption;
  }

  int getPageItemCount({ServerActions action = ServerActions.list}) {
    return getRequestOption(action: action)?.countPerPage ?? 20;
  }

  List<T>? get getLastSearchViewByTextInputList =>
      _lastSearchViewAbstractByTextInputList;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final List<SearchCache> _searchCache = [];

  @Deprecated("dont use new self")
  T getSelfInstanceWithSimilarOption(
      {required BuildContext context,
      ServerActions action = ServerActions.list,
      ViewAbstract? obj,
      RequestOptions? copyWith}) {
    RequestOptions? o = obj?.getSimilarCustomParams(context: context) ??
        this.getSimilarCustomParams(context: context);

    debugPrint(
        "getSelfInstanceWithSimilarOption getSimilarCustomParams ====> ${o.getKey()}");

    return setRequestOption(
        action: action, option: o.copyWithObjcet(option: copyWith));
  }

  RequestOptions getSimilarCustomParams({required BuildContext context}) {
    return RequestOptions()
        .addSearchByField(castViewAbstract().getForeignKeyName(), "$iD");
  }

  T setRequestOption(
      {ServerActions action = ServerActions.list,
      required RequestOptions option}) {
    _requestOption[action] = option;
    return this as T;
  }

  T setRequestOptionMap(
      {required Map<ServerActions, RequestOptions> requestOption}) {
    _requestOption = requestOption;
    return this as T;
  }

  SortFieldValue? getSortByInitialType(
      {ServerActions action = ServerActions.list}) {
    return getRequestOption(action: action)?.sortBy;
  }

  RequestOptions? getRequestOptionFromParamOrAbstract(
      {required ServerActions action}) {
    if (_requestOption.isNotEmpty) {
      // debugPrint(
      //     "_getRequestOptionFromParamOrAbstract is Not empty ${_requestOption.toString()}");
      if (_requestOption.containsKey(action)) {
        return _requestOption[action];
      }
    }
    RequestOptions? op = getRequestOption(action: action);
    if (op != null) setRequestOption(action: action, option: op);
    return op;
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

  String? getCustomAction() {
    return null;
  }

  List<String>? getRequestedForginListOnCall({required ServerActions action});

  Future<Map<String, String>> getHeadersExtenstion() async {
    Map<String, String> defaultHeaders = HashMap<String, String>();
    bool hasUser = await Configurations.hasSavedValue(AuthUser());
    if (hasUser) {
      AuthUser? authUser = await Configurations.get(AuthUser());
      String? token = authUser?.token;
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

  Uri _getUrl({int? iD, Map<String, dynamic>? params}) {
    String? customAction = getCustomAction();
    String? tableName = getTableNameApi();
    debugPrint("listCall _getUrl params ===>$params");
    var url = Uri(
        scheme: "http",
        queryParameters: params,
        host: URLS.getBaseUrl(),
        pathSegments: [
          ...URLS.getBasePath(),
          if (customAction != null || tableName != null)
            (customAction ?? tableName) ?? "",
          if (iD != null) "$iD"
        ]);
    return url;
  }

  dynamic _checkListToRequest(ServerActions action) {
    List<String>? requiredList = getRequestedForginListOnCall(action: action);

    if (requiredList == null) return false;
    if (requiredList.isNotEmpty) {
      List l = requiredList.where(
        (element) {
          int? count = getFieldValue("${element}_count");
          List? list = getFieldValue(element);
          if (count == null && list == null) return true;
          debugPrint(
              "checkListToRequest field:$element count:$count list:${list?.length}");
          return count != list?.length;
        },
      ).toList();
      debugPrint("checkListToRequest list $l");
      return l.isEmpty ? false : l;
    }
    return false;
  }

  Future<Response?> _getListResponse({RequestOptions? option}) async {
    return getHttp().get(
        _getUrl(
            params: getRequestOptionFromParamOrAbstract(
                    action: option?.getServerAction() ?? ServerActions.list)
                ?.copyWithObjcet(option: option)
                .copyWith(requestLists: _checkListToRequest(ServerActions.list))
                .getRequestParams()),
        headers: await getHeaders());
  }

  Future<Response?> _getViewResponse(
      {int? customID, ServerActions? customAction}) async {
    return await getHttp().get(
        _getUrl(
          iD: customID == null ? customID : (isNew() ? null : iD),
          params: getRequestOptionFromParamOrAbstract(
                  action: customAction ?? ServerActions.view)
              ?.copyWith(
                  requestLists:
                      _checkListToRequest(customAction ?? ServerActions.view))
              .getRequestParams(),
        ),
        headers: await getHeaders());
  }

  Future<Response?> _getEditResponse() async {
    var headers = await getHeaders();
    return await getHttp().put(
        _getUrl(
          iD: iD,
        ),
        headers: headers,
        body: toJsonString());
  }

  Future<Response?> _getAddResponse() async {
    var headers = await getHeaders();
    return await getHttp()
        .post(_getUrl(), headers: headers, body: toJsonString());
  }

  Future<Response?> _getDeleteResponse() async {
    var headers = await getHeaders();
    return await getHttp().delete(
        _getUrl(
          iD: iD,
        ),
        headers: headers);
  }

  T onResponse200K(T oldValue) {
    return this as T;
  }

  Future<List<T>?> listCall<T>(
      {required BuildContext context,
      RequestOptions? option,
      OnResponseCallback? onResponse,
      ServerActions? customAction}) async {
    try {
      var response = await _getListResponse(option: option);
      if (response == null) return null;
      if (response.statusCode == 200) {
        // debugPrint("listCall response s ${response.body}");
        Iterable l = convert.jsonDecode(response.body);
        List<T> t = List<T>.from(l.map((model) => fromJsonViewAbstract(model)));
        if (customAction == ServerActions.search_viewabstract_by_field) {
          setLastSearchViewAbstractByTextInputList(t.cast());
        }
        return t;
      } else if (response.statusCode == 204) {
        return [];
      } else {
        onCallCheckError(
            onResponse: onResponse, response: response, context: context);
        return null;
      }
    } on Exception catch (e, s) {
      debugPrint("listCall ex ${e.toString()}");
      debugPrint("listCall trace ${s.toString()}");
      onResponse?.onFlutterClientFailure?.call(e);
    }
    return null;
  }

  Future<T?> viewCall({
    required BuildContext context,
    int? customID,
    OnResponseCallback? onResponse,
    ServerActions? customAction,
  }) async {
    try {
      debugPrint("viewCall is Called");
      dynamic isRequireList =
          _checkListToRequest(customAction ?? ServerActions.view);
      if (customID == null) {
        if (isRequireList == false && !isNew()) {
          return this as T;
        }
      }
      var response = await _getViewResponse(customID: customID);
      // debugPrint("viewCall  resp ${response?.body}");
      if (response == null) return null;
      if (response.statusCode == 200) {
        return fromJsonViewAbstract(convert.jsonDecode(response.body));
      } else {
        onCallCheckError(response: response, context: context);
        return null;
      }
    } on Exception catch (e, s) {
      debugPrint("viewCall ex ${e.toString()}");
      debugPrint("viewCall trace ${s.toString()}");
      onResponse?.onFlutterClientFailure?.call(e);
    }
    return null;
  }

  Future<T?> addCall({
    OnResponseCallback? onResponse,
    required BuildContext context,
  }) async {
    try {
      var response = await _getAddResponse();
      if (response == null) return null;
      if (response.statusCode == 200) {
        return fromJsonViewAbstract(convert.jsonDecode(response.body));
      } else {
        onCallCheckError(
            onResponse: onResponse, response: response, context: context);
        return null;
      }
    } catch (e) {
      onResponse?.onFlutterClientFailure?.call(e);
    }
    return null;
  }

  Future<T?> editCall({
    OnResponseCallback? onResponse,
    required BuildContext context,
  }) async {
    try {
      var response = await _getEditResponse();
      if (response == null) return null;
      if (response.statusCode == 200) {
        return fromJsonViewAbstract(convert.jsonDecode(response.body));
      } else {
        onCallCheckError(
            onResponse: onResponse, response: response, context: context);
        return null;
      }
    } catch (e) {
      onResponse?.onFlutterClientFailure?.call(e);
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

  Future<List<String>> searchByFieldName(
      {required String field,
      required String searchQuery,
      OnResponseCallback? onResponse,
      required BuildContext context}) async {
    var response = await listCall(
        onResponse: onResponse,
        context: context,
        option: RequestOptions(searchQuery: searchQuery));
    if (response != null) {
      return response
          .map((e) => (e as ViewAbstract).getFieldValue(field).toString())
          .toList();
    }
    return [];
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
        ServerResponse serverResponse =
            ServerResponse.fromJson(convert.jsonDecode(response.body));
        debugPrint(
            "ViewAbstractApi onCallCheckError====> called code:$statusCode  message : ${serverResponse.toJson()}");
        if (statusCode == 401) {
          onResponse.onEmailOrPassword?.call();
          //Invalid user and password
        } else if (statusCode == 402) {
          onResponse.onBlocked?.call();
          //BLOCK
        } else if (statusCode == 403) {
          onResponse.onNoPermission?.call();
        } else if (statusCode == 405 || statusCode == 406) {
          onResponse.onAuthRequired?.call(statusCode == 405);
        } else {
          onResponse.onServerFailureResponse
              ?.call((serverResponse.message ?? " unkown exceptions"));
        }
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
      onResponse.onServerResponse
          ?.call(AppLocalizations.of(context)!.successDeleted);
    } else if (allFaild) {
      onResponse.onServerFailureResponse
          ?.call("ALL ${AppLocalizations.of(context)!.errOperationFailed}");
    } else {
      onResponse.onServerFailureResponse?.call(
          "${AppLocalizations.of(context)!.errOperationFailed}: $faildCount");
    }
  }

  void deleteCall(BuildContext context,
      {required OnResponseCallback onResponse}) async {
    debugPrint("ViewAbstractApi deleteCall iD=> $iD ");
    try {
      var response = await _getDeleteResponse();
      if (response == null) return null;
      if (response.statusCode == 200) {
        ServerResponse serverResponse =
            ServerResponse.fromJson(convert.jsonDecode(response.body));

        if (serverResponse.serverStatus == false) {
          onResponse.onServerFailureResponse
              ?.call("ALL ${AppLocalizations.of(context)!.errOperationFailed}");
        } else {
          onResponse.onServerResponse
              ?.call(AppLocalizations.of(context)!.successDeleted);
        }
      } else {
        onCallCheckError(
            onResponse: onResponse, response: response, context: context);
      }
    } catch (e) {
      onResponse.onFlutterClientFailure?.call(e);
    }
  }

  List fromJsonViewAbstractList(String fromJsonView) {
    Iterable l = convert.jsonDecode(fromJsonView);
    return List.from(l.map((model) => fromJsonViewAbstract(model)));
  }

  String toJsonViewAbstractList(List list) {
    return jsonEncode(list.map((i) => i.toJson()).toList()).toString();
  }

  Future<List<T>> listCallNotNull(
      {required BuildContext context,
      RequestOptions? option,
      OnResponseCallback? onResponse,
      ServerActions? customAction}) async {
    var response = await listCall(
        context: context,
        customAction: customAction,
        onResponse: onResponse,
        option: option);
    if (response == null) return [];
    return response.cast();
  }

  ViewAbstract castViewAbstract() {
    return this as ViewAbstract;
  }

  ListableInterface castListableInterface() {
    return (this as ListableInterface);
  }

  HttpWithMiddleware getHttp() {
    return HttpWithMiddleware.build(
        requestTimeout: const Duration(seconds: 60),
        middlewares: [
          HttpLogger(logLevel: LogLevel.HEADERS),
        ]);
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

  String toJsonString() {
    String js = jsonEncode(toJsonViewAbstract());
    // debugPrint("toJsonString ========> $js");
    return js;
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
