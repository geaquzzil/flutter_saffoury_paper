import 'package:flutter_view_controller/models/va_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:json_annotation/json_annotation.dart';

part 'governorates.g.dart';

@JsonSerializable()
@reflector
class Governorate extends ViewAbstract<Governorate> {
  String? name;
  Governorate() : super();
}
