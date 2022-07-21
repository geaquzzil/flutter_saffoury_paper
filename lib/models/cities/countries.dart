import 'package:flutter_view_controller/models/va_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:json_annotation/json_annotation.dart';

part 'countries.g.dart';

@JsonSerializable()
@reflector
class Country extends ViewAbstract<Country> {
  String? name;
  Country() : super();
}
