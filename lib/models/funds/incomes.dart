import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/va_mirrors.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'money_funds.dart';

part 'incomes.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class Incomes extends MoneyFunds<Incomes> {
  Incomes() : super();

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.incomes;
  @override
  IconData getMainIconData() => Icons.input_rounded;

  @override
  String? getTableNameApi() => "incomes";

  @override
  Incomes fromJsonViewAbstract(Map<String, dynamic> json) {
    // TODO: implement fromJsonViewAbstract
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    // TODO: implement toJsonViewAbstract
    throw UnimplementedError();
  }
}
