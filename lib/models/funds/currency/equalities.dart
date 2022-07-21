import 'package:flutter_saffoury_paper/models/funds/currency/currency.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_saffoury_paper/models/funds/money_funds.dart';
import 'package:flutter_view_controller/models/va_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:json_annotation/json_annotation.dart';

part 'equalities.g.dart';

@JsonSerializable()
@reflector
class Equalities extends ViewAbstract<Equalities> {
  int? CurrencyID;
  double? value;
  String? date;

  Currency? currency;

  Equalities() : super();
}
