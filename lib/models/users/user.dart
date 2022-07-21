import 'package:flutter_view_controller/models/permissions/user_auth.dart';

class User<T> extends AuthUser {
  String? name;
  String? email;
  String? token;
  int? activated;
  String? date;
  String? city;
  String? address;
  String? profile;
  String? comments;

  User() : super();
}
