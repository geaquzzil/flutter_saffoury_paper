import 'dart:math';

import 'package:flutter_view_controller/models/response_message.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_auth.g.dart';

@JsonSerializable()

class AuthUser<T> extends ResponseMessage<T> {
  String phone;
  String password;


  

  AuthUser(this.phone, this.password, {bool? setPassword}) : super() {
    if (setPassword ?? false) {
      setRandomPassword();
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
