import 'package:flutter_view_controller/models/va_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:json_annotation/json_annotation.dart';


part 'manufactures.g.dart';

@JsonSerializable()
@reflector
class Manufacture extends ViewAbstract<Manufacture> {
  String? name;
  Manufacture() : super();
}
