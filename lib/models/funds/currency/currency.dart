import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_saffoury_paper/models/funds/money_funds.dart';
import 'package:flutter_view_controller/models/va_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:json_annotation/json_annotation.dart';

part 'currency.g.dart';

@JsonSerializable()
@reflector
class Currency extends ViewAbstract<Currency> {
  String? name;
  String? nameAr;

  Currency() : super();
}
