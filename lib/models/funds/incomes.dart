import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/funds/accounts/account_names.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_saffoury_paper/models/users/customers.dart';
import 'money_funds.dart';
import 'package:flutter_saffoury_paper/models/funds/currency/equalities.dart';
import 'package:flutter_saffoury_paper/models/products/warehouse.dart';
import 'package:flutter_saffoury_paper/models/users/employees.dart';

part 'incomes.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class Incomes extends MoneyFunds<Incomes> {
  // int? NameID;

  AccountName? account_names;

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      super.getMirrorFieldsMapNewInstance()
        ..addAll({"account_names": AccountName()});

  Incomes() : super();

  @override
  Incomes getSelfNewInstance() {
    return Incomes();
  }

  @override
  List<String> getMainFields({BuildContext? context}) =>
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
