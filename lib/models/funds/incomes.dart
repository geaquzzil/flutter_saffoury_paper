import 'package:flutter_view_controller/models/va_mirrors.dart';
import 'package:json_annotation/json_annotation.dart';

import 'money_funds.dart';

part 'incomes.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class Incomes extends MoneyFunds<Incomes> {}
