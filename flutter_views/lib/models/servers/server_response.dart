import 'package:json_annotation/json_annotation.dart';

part 'server_response.g.dart';

@JsonSerializable(explicitToJson:true)
class ServerResponse {
  int? activated;
  bool? permission;
  bool? login;
  bool? error;
  String? message;
  int? code;
  ServerResponse();
  factory ServerResponse.fromJson(Map<String, dynamic> data) =>
      _$ServerResponseFromJson(data);

  Map<String, dynamic> toJson() => _$ServerResponseToJson(this);

  bool isAccountActivated() {
    return activated == 1;
  }

  bool isAccountLoggedIn() {
    return login ?? false;
  }

  bool isAccountHasPermission() {
    return permission ?? false;
  }

  bool isAuthError() {
    if (message == null) return false;
    return message == "Authorization error";
  }
}
