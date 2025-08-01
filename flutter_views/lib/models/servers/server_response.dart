import 'package:json_annotation/json_annotation.dart';

part 'server_response.g.dart';

@JsonSerializable(explicitToJson: true)
class ServerResponse {
  String? message;
  String? className;
  String? trace;
  String? status;
  int? code;

  int? requestCount;

  List<int>? requestIDS;
  int? serverCount;
  bool? serverStatus;

  int? activated;
  bool? permission;
  bool? login;
  bool? error;
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

  bool isAuthError() {
    return code == 406 || code == 405;
  }
}
