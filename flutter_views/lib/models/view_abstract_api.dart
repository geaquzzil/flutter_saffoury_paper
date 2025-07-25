// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:collection';
import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
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
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_api_master_new.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/test_var.dart';
import 'package:http/http.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:provider/provider.dart';

import 'servers/server_helpers.dart';

abstract class ViewAbstractApi<T> extends ViewAbstractBase<T> {
  @JsonKey(includeFromJson: false, includeToJson: false)
  Map<ServerActions, RequestOptions> _requestOption = {};

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<T>? _lastSearchViewAbstractByTextInputList;

  @JsonKey(includeFromJson: false, includeToJson: false)
  static Map<String, List<ViewAbstract?>>? _lastListReduseSizeViewAbstract;

  RequestOptions? getRequestOption({
    required ServerActions action,
    RequestOptions? generatedOptionFromListCall,
  });
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
  T getSelfInstanceWithSimilarOption({
    required BuildContext context,
    ServerActions action = ServerActions.list,
    ViewAbstract? obj,
    RequestOptions? copyWith,
  }) {
    RequestOptions? o =
        obj?.getSimilarCustomParams(context: context) ??
        this.getSimilarCustomParams(context: context);

    debugPrint(
      "getSelfInstanceWithSimilarOption getSimilarCustomParams ====> ${o.getKey()}",
    );

    return setRequestOption(
      action: action,
      option: o.copyWithObjcet(option: copyWith),
    );
  }

  RequestOptions getSimilarCustomParams({required BuildContext context}) {
    return RequestOptions().addSearchByField(
      castViewAbstract().getForeignKeyName(),
      "$iD",
    );
  }

  T setRequestOption({
    ServerActions action = ServerActions.list,
    required RequestOptions option,
  }) {
    _requestOption[action] = option;
    return this as T;
  }

  T setRequestOptionMap({
    required Map<ServerActions, RequestOptions> requestOption,
  }) {
    _requestOption = requestOption;
    return this as T;
  }

  SortFieldValue? getSortByInitialType({
    ServerActions action = ServerActions.list,
  }) {
    return getRequestOption(action: action)?.sortBy;
  }

  RequestOptions? getRequestOptionFromParamOrAbstract({
    required ServerActions action,
    RequestOptions? generatedOptionFromListCall,
  }) {
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
      "getListSearchViewByTextInputList list=>$getLastSearchViewByTextInputList",
    );
    debugPrint(
      "getListSearchViewByTextInputList value=>$fieldValue field $field",
    );
    return getLastSearchViewByTextInputList?.firstWhereOrNull(
      (element) => (element as ViewAbstract)
          .getFieldValue(field)
          .toString()
          .toLowerCase()
          .contains(fieldValue.toLowerCase()),
    );
  }

  List<String>? getCustomAction() {
    return null;
  }

  List<String>? getRequestedForginListOnCall({required ServerActions action});

  Future<Map<String, String>> getHeadersExtenstion(BuildContext context) async {
    Map<String, String> defaultHeaders = HashMap<String, String>();
    AuthUser? hasUser = context.read<AuthProvider<AuthUser>>().getUser;
    if (hasUser != null) {
      String? token = hasUser.token;
      if (token != null) {
        defaultHeaders['Authorization'] = 'Bearer $token';
      }
    }
    return defaultHeaders;
  }

  String getListableKeyWithoutCustomMap() {
    return "${getTableNameApi()}listAPI${getRequestOptionFromParamOrAbstract(action: ServerActions.list)?.filterMap}";
  }

  String getListableKey({SliverMixinObjectType? type}) {
    return "${getCustomAction()}-${getTableNameApi()}-$type-${getRequestOptionFromParamOrAbstract(action: ServerActions.list)?.getKey() ?? ""}";
  }

  Future<Map<String, String>> getHeaders(BuildContext context) async {
    Map<String, String> defaultHeaders = HashMap<String, String>();
    defaultHeaders.addAll(URLS.requestHeaders);
    defaultHeaders.addAll(await getHeadersExtenstion(context));
    return defaultHeaders;
  }

  Uri _getUrl({int? iD, Map<String, dynamic>? params}) {
    List<String>? customAction = getCustomAction();
    String? tableName = getTableNameApi();
    debugPrint("_getUrl params ===>$params");
    var url = Uri(
      scheme: "http",
      queryParameters: params,
      host: URLS.getBaseUrl(),
      pathSegments: [
        ...URLS.getBasePath(),
        if (tableName != null) tableName,
        if (customAction != null) ...customAction,
        if (iD != null) "$iD",
      ],
    );
    return url;
  }

  bool shouldGetFromApi(ServerActions action) {
    return _checkListToRequest(action) != false;
  }

  dynamic _checkListToRequest(ServerActions action) {
    List<String>? requiredList = getRequestedForginListOnCall(action: action);

    if (requiredList == null) return false;
    if (requiredList.isNotEmpty) {
      debugPrint(
        "checkListToRequest action:$action checking $T requiredList :$requiredList",
      );
      List l = requiredList.where((element) {
        int? count = getFieldValue("${element}_count");
        List? list = getFieldValue(element);
        if (count == null && list == null) return true;
        debugPrint(
          "checkListToRequest $T field:$element count:$count list:${list?.length}",
        );
        return count != list?.length;
      }).toList();
      debugPrint("checkListToRequest list $l");
      return l.isEmpty ? false : l;
    }
    return false;
  }

  Future<Response?> _getListResponse({
    required BuildContext context,
    RequestOptions? option,
  }) async {
    return getHttp().get(
      _getUrl(
        params:
            getRequestOptionFromParamOrAbstract(
                  action: option?.getServerAction() ?? ServerActions.list,
                  generatedOptionFromListCall: option,
                )
                ?.copyWithObjcet(option: option)
                .copyWith(requestLists: _checkListToRequest(ServerActions.list))
                .getRequestParams(),
      ),
      headers: await getHeaders(context),
    );
  }

  Future<Response?> _getViewResponse({
    required BuildContext context,
    int? customID,
    ServerActions? customAction,
  }) async {
    return await getHttp().get(
      _getUrl(
        iD: customID == null ? customID : (isNew() ? null : iD),
        params:
            getRequestOptionFromParamOrAbstract(
                  action: customAction ?? ServerActions.view,
                )
                ?.copyWith(
                  requestLists: _checkListToRequest(
                    customAction ?? ServerActions.view,
                  ),
                )
                .getRequestParams(),
      ),
      headers: await getHeaders(context),
    );
  }

  Future<Response?> _getEditResponse({required BuildContext context}) async {
    var headers = await getHeaders(context);
    return await getHttp().put(
      _getUrl(iD: iD),
      headers: headers,
      body: toJsonString(),
    );
  }

  Future<Response?> _getAddResponse({required BuildContext context}) async {
    var headers = await getHeaders(context);
    return await getHttp().post(
      _getUrl(),
      headers: headers,
      body: toJsonString(),
    );
  }

  Future<Response?> _getDeleteResponse({required BuildContext context}) async {
    var headers = await getHeaders(context);
    return await getHttp().delete(
      _getUrl(
        iD: iD == -1 ? null : iD,
        params: getRequestOptionFromParamOrAbstract(
          action: ServerActions.delete_action,
        )?.getRequestParams(),
      ),
      headers: headers,
    );
  }

  T onResponse200K(T oldValue) {
    return this as T;
  }

  Future<List<T>?> listCall<T>({
    required BuildContext context,
    RequestOptions? option,
    OnResponseCallback? onResponse,
    ServerActions? customAction,
  }) async {
    try {
      var response = await _getListResponse(context: context, option: option);
      if (response == null) return null;
      if (response.statusCode == 200) {
        // debugPrint("listCall response s ${response.body}");
        List<T> t = getJsonEncodeListResponse(response);
        if (customAction == ServerActions.search_viewabstract_by_field) {
          setLastSearchViewAbstractByTextInputList(t.cast());
        }
        return t;
      } else if (response.statusCode == 204) {
        return [];
      } else {
        onCallCheckError(
          onResponse: onResponse,
          response: response,
          context: context,
        );
        return null;
      }
    } on Exception catch (e, s) {
      debugPrint("listCall ex ${e.toString()}");
      debugPrint("listCall trace ${s.toString()}");
      onResponse?.onFlutterClientFailure?.call(e);
    }
    return null;
  }

  T getJsonEncodeResponse(Response response) {
    return fromJsonViewAbstract(convert.jsonDecode(response.body));
  }

  List<T> getJsonEncodeListResponse<T>(Response response) {
    Iterable l = convert.jsonDecode(response.body);
    return List<T>.from(l.map((model) => fromJsonViewAbstract(model)));
  }

  Future<T?> viewCall({
    required BuildContext context,
    int? customID,
    OnResponseCallback? onResponse,
    ServerActions? customAction,
  }) async {
    try {
      debugPrint("viewCall is Called");
      dynamic isRequireList = _checkListToRequest(
        customAction ?? ServerActions.view,
      );
      if (customID == null || customID == iD) {
        if (isRequireList == false && !isNew()) {
          debugPrint("viewCall $T returning this");
          return this as T;
        }
      }
      var response = await _getViewResponse(
        context: context,
        customID: customID,
      );
      // debugPrint("viewCall  resp ${response?.body}");
      if (response == null) return null;
      if (response.statusCode == 200) {
        debugPrint("viewCall 200 ");
        return getJsonEncodeResponse(response);
      } else {
        debugPrint("viewCall error");
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
      var response = await _getAddResponse(context: context);
      if (response == null) return null;
      if (response.statusCode == 200) {
        return getJsonEncodeResponse(response);
      } else {
        onCallCheckError(
          onResponse: onResponse,
          response: response,
          context: context,
        );
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
      var response = await _getEditResponse(context: context);
      if (response == null) return null;
      if (response.statusCode == 200) {
        return getJsonEncodeResponse(response);
      } else {
        onCallCheckError(
          onResponse: onResponse,
          response: response,
          context: context,
        );
        return null;
      }
    } catch (e) {
      onResponse?.onFlutterClientFailure?.call(e);
    }
    return null;
  }

  void _getSnackbar(BuildContext context, String text) {
    var snackBar = SnackBar(
      // width: SizeConfig.,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      content: Text(text),
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Future<E> getServerDataApi<E extends ServerData>(
  //     BuildContext context, E data) async {

  //   Map<String, String> mainBody = HashMap<String, String>();
  //   mainBody["action"] = "list_server_data";
  //   Response? response = await getHttp().post(Uri.parse(URLS.BASE_URL),
  //       headers: await getHeaders(), body: mainBody);

  // }

  Future<List<String>> searchByFieldName({
    required String field,
    required String searchQuery,
    OnResponseCallback? onResponse,
    required BuildContext context,
  }) async {
    var response = await listCall(
      onResponse: onResponse,
      context: context,
      option: RequestOptions(searchQuery: searchQuery),
    );
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
        "ViewAbstractApi ViewAbstractApi listCallFake ${e.toString()}",
      );
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

  void onCallCheckError({
    OnResponseCallback? onResponse,
    dynamic response,
    required BuildContext context,
  }) {
    if (response is Response) {
      if (onResponse == null) {
        debugPrint(
          "ViewAbstractApi onCallCheckError====> called but no response callback registered",
        );
        return;
      }
      int statusCode = response.statusCode;
      if (statusCode >= 400 && statusCode <= 500) {
        ServerResponse serverResponse = ServerResponse.fromJson(
          convert.jsonDecode(response.body),
        );
        debugPrint(
          "ViewAbstractApi onCallCheckError====> called code:$statusCode  message : ${serverResponse.toJson()}",
        );
        if (statusCode == 401) {
          onResponse.onEmailOrPassword?.call();
          _getSnackbar(
            context,
            AppLocalizations.of(context)!.error_login_failed,
          );
          //Invalid user and password
        } else if (statusCode == 402) {
          onResponse.onBlocked?.call();
          _getSnackbar(
            context,
            AppLocalizations.of(context)!.error_login_failed,
          );
          //BLOCK
        } else if (statusCode == 403) {
          onResponse.onNoPermission?.call();
          _getSnackbar(context, AppLocalizations.of(context)!.err_permission);
        } else if (statusCode == 405 || statusCode == 406) {
          //TODO translate
          _getSnackbar(context, AppLocalizations.of(context)!.error401);
          onResponse.onAuthRequired?.call(statusCode == 405);
        } else {
          _getSnackbar(
            context,
            AppLocalizations.of(context)!.errOperationFailed,
          );
          onResponse.onServerFailureResponse?.call(
            (serverResponse.message ?? " unkown exceptions"),
          );
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

  void onCallCheck200Response({
    required BuildContext context,
    required List list,
    required ServerActions action,
    required OnResponseCallback onResponse,
  }) {
    int faildCount = list.where((i) => i.hasErrorOnDelete()).length;
    bool allSuccess = faildCount == 0;
    bool allFaild = faildCount == list.length;
    //TODO translate
    if (allSuccess) {
      onResponse.onServerResponse?.call(
        AppLocalizations.of(context)!.successDeleted,
      );
    } else if (allFaild) {
      onResponse.onServerFailureResponse?.call(
        "ALL ${AppLocalizations.of(context)!.errOperationFailed}",
      );
    } else {
      onResponse.onServerFailureResponse?.call(
        "${AppLocalizations.of(context)!.errOperationFailed}: $faildCount",
      );
    }
  }

  Future<bool> deleteCall(
    BuildContext context, {
    required OnResponseCallback onResponse,
  }) async {
    debugPrint("ViewAbstractApi deleteCall iD=> $iD ");
    try {
      var response = await _getDeleteResponse(context: context);
      if (response == null) return false;
      if (response.statusCode == 200) {
        ServerResponse serverResponse = ServerResponse.fromJson(
          convert.jsonDecode(response.body),
        );

        if (serverResponse.serverStatus == false) {
          onResponse.onServerFailureResponse?.call(
            "ALL ${AppLocalizations.of(context)!.errOperationFailed}",
          );
          _getSnackbar(context, AppLocalizations.of(context)!.error401);
          return false;
        } else {
          onResponse.onServerResponse?.call(
            AppLocalizations.of(context)!.successDeleted,
          );
          return true;
        }
      } else {
        onCallCheckError(
          onResponse: onResponse,
          response: response,
          context: context,
        );
        return false;
      }
    } on Exception catch (e, s) {
      debugPrint("viewCall ex ${e.toString()}");
      debugPrint("viewCall trace ${s.toString()}");
      onResponse.onFlutterClientFailure?.call(e);
      return false;
    }
  }

  List fromJsonViewAbstractList(String fromJsonView) {
    Iterable l = convert.jsonDecode(fromJsonView);
    return List.from(l.map((model) => fromJsonViewAbstract(model)));
  }

  String toJsonViewAbstractList(List list) {
    return jsonEncode(list.map((i) => i.toJson()).toList()).toString();
  }

  Future<List<T>> listCallNotNull({
    required BuildContext context,
    RequestOptions? option,
    OnResponseCallback? onResponse,
    ServerActions? customAction,
  }) async {
    var response = await listCall(
      context: context,
      customAction: customAction,
      onResponse: onResponse,
      option: option,
    );
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
      middlewares: [HttpLogger(logLevel: LogLevel.BODY)],
    );
  }

  void setLastSearchViewAbstractByTextInputList(List<T>? lastList) {
    _lastSearchViewAbstractByTextInputList = lastList;
  }

  List<ViewAbstract?> getLastReduseSize(String field) {
    return _lastListReduseSizeViewAbstract?["$T$field"] ?? [];
  }

  void setListReduseSizeViewAbstract(
    String field,
    List<ViewAbstract> lastList,
  ) {
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
    BuildContext context,
  ) {
    Map<String, dynamic> map = toJsonViewAbstract();

    for (var element in map.entries) {
      if (element.value == null) continue;
      if (isViewAbstract(element.key)) {
        map[element.key] = getMirrorNewInstanceViewAbstract(
          element.key,
        ).fromJsonViewAbstract(element.value);
        continue;
      }
      if (element.value is List) {
        map[element.key] =
            (fromJsonViewAbstract({element.key: element.value}) as ViewAbstract)
                .getFieldValue(element.key);
        continue;
      }

      FormFieldControllerType type = castViewAbstract().getInputType(
        element.key,
      );
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
      l.map((model) => viewAbstract.fromJsonViewAbstract(model)),
    );
    Isolate.exit(p, t);
  }
}

//TODO dispose this
class SearchCache {
  String query;
  List? response;
  SearchCache({required this.query, this.response});
  static List getResultAndAdd(
    String query,
    List response,
    List<SearchCache> list,
  ) {
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
