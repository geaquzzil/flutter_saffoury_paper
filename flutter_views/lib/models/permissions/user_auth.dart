import 'dart:convert';
import 'dart:math';

import 'package:flutter_view_controller/models/response_message.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/servers/server_response_master.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_auth.g.dart';

@JsonSerializable()
class AuthUser<T> extends ResponseMessage<T> {
  String? phone;
  String? password;
  AuthUser({bool? setPassword}) : super() {
    if (setPassword ?? false) {
      setRandomPassword();
    }
  }
  @override
  String? getCustomAction() {
    return "login";
  }

  void set(String key, dynamic v) {
    gets()[key] = v;
  }

  Map<String, dynamic> gets() {
    return {"login": login};
  }

  Future<T?> login({OnResponseCallback? onResponse}) async {
    var response = await getRespones(
        onResponse: onResponse, serverActions: ServerActions.view);
    if (response == null) return null;
    if (response.statusCode == 200) {
      return fromJsonViewAbstract(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      ServerResponseMaster serverResponse =
          ServerResponseMaster.fromJson(jsonDecode(response.body));
      onResponse?.onServerFailureResponse(serverResponse.serverResponse);
      //throw Exception('Failed to load album');
      return null;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return null;
    }
  }

  void setRandomPassword() {
    final alphabet =
        "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890";
    Random r = Random();
    password = String.fromCharCodes(Iterable.generate(alphabet.length,
        (_) => alphabet.codeUnitAt(r.nextInt(alphabet.length))));
  }

  factory AuthUser.fromJson(Map<String, dynamic> data) =>
      _$AuthUserFromJson(data);

  Map<String, dynamic> toJson() => _$AuthUserToJson(this);
}
