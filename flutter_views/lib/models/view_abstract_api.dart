import 'dart:collection';
import 'dart:convert' as convert;
import 'package:flutter_view_controller/encyptions/encrypter.dart';
import 'package:flutter_view_controller/models/servers/server_response_master.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:http/http.dart';
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
  T fromJsonViewAbstract(Map<String, dynamic> json);
  Map<String, dynamic> toJsonViewAbstract();

  String? getTableNameApi();
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

  Map<String, String> getBody(ServerActions? action) {
    Map<String, String> mainBody = HashMap<String, String>();
    mainBody.addAll(getBodyExtenstionParams());
    mainBody.addAll(getBodyCurrentAction(action));
    return mainBody;
  }

  Map<String, String> getHeadersExtenstion() {
    Map<String, String> defaultHeaders = HashMap<String, String>();
    defaultHeaders['Auth'] =
        Encriptions.encypt("HIIAMANANDROIDUSERFROMSAFFOURYCOMPANY");
    return defaultHeaders;
  }

  Map<String, String> getHeaders() {
    Map<String, String> defaultHeaders = HashMap<String, String>();
    defaultHeaders.addAll(URLS.requestHeaders);
    defaultHeaders.addAll(getHeadersExtenstion());
    return defaultHeaders;
  }

  Future<Response?> getRespones(
      {ServerActions? serverActions, OnResponseCallback? onResponse}) async {
    try {
      return await getHttp().post(Uri.parse(URLS.BASE_URL),
          headers: getHeaders(), body: getBody(serverActions));
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

  Future<List<T>?> listCall(int count, int page,
      {OnResponseCallback? onResponse}) async {
    var response = await getRespones(
        onResponse: onResponse, serverActions: ServerActions.list);

    if (response == null) return null;
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

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

  Map<String, String> getBodyCurrentAction(ServerActions? action) {
    Map<String, String> mainBody = HashMap();
    String? customAction = getCustomAction();
    mainBody['action'] = customAction ?? action.toString().split(".").last;
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
        mainBody['start'] = 10.toString();
        mainBody['end'] = 0.toString();
        break;
      default:
        break;
    }

    return mainBody;
  }
}
