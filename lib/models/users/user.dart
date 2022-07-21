import 'package:flutter_view_controller/models/permissions/user_auth.dart';

class User<T> extends AuthUser {
  String? name; //var 100
  String? email; //var 50
  String? token; // text
  int? activated; //tinyint
  String? date; //date
  String? city; // varchar 20
  String? address; // text
  String? profile; //text
  String? comments; //text

  User() : super();
}
