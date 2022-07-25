import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/funds/accounts/account_names.dart';
import 'package:flutter_view_controller/models/va_mirrors.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'money_funds.dart';

part 'incomes.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class Incomes extends MoneyFunds<Incomes> {
  // int? NameID;

  AccountName? account_names;

  Incomes() : super();

  @override
  List<String> getMainFields() =>
      ["account_names", "employee", "date", "value", "equalities", "warehouse"];

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.incomes;
  @override
  IconData getMainIconData() => Icons.input_rounded;

  @override
  String? getTableNameApi() => "incomes";

  factory Incomes.fromJson(Map<String, dynamic> data) =>
      _$IncomesFromJson(data);

  Map<String, dynamic> toJson() => _$IncomesToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  Incomes fromJsonViewAbstract(Map<String, dynamic> json) =>
      Incomes.fromJson(json);
}
