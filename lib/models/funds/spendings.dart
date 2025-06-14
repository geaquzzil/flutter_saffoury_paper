import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/funds/accounts/account_names.dart';
import 'package:flutter_saffoury_paper/models/funds/currency/equalities.dart';
import 'package:flutter_saffoury_paper/models/funds/money_funds.dart';
import 'package:flutter_saffoury_paper/models/products/warehouse.dart';
import 'package:flutter_saffoury_paper/models/users/customers.dart';
import 'package:flutter_saffoury_paper/models/users/employees.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:json_annotation/json_annotation.dart';

part 'spendings.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class Spendings extends MoneyFunds<Spendings> {
  // int? NameID;
  AccountName? account_names;

  Spendings() : super();

  @override
  Spendings getSelfNewInstance() {
    return Spendings();
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      super.getMirrorFieldsMapNewInstance()
        ..addAll({"account_names": AccountName()});

  @override
  List<String> getMainFields({BuildContext? context}) => [
        "account_names",
        "employees",
        "date",
        "value",
        "equalities",
        "warehouse"
      ];

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.spendings;
  @override
  IconData getMainIconData() => Icons.input_rounded;

  @override
  String? getTableNameApi() => "spendings";

  factory Spendings.fromJson(Map<String, dynamic> data) =>
      _$SpendingsFromJson(data);

  Map<String, dynamic> toJson() => _$SpendingsToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  Spendings fromJsonViewAbstract(Map<String, dynamic> json) =>
      Spendings.fromJson(json);
}
