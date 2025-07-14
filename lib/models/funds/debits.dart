import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/funds/currency/equalities.dart';
import 'package:flutter_saffoury_paper/models/funds/money_funds.dart';
import 'package:flutter_saffoury_paper/models/products/warehouse.dart';
import 'package:flutter_saffoury_paper/models/users/customers.dart';
import 'package:flutter_saffoury_paper/models/users/employees.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:json_annotation/json_annotation.dart';

part 'debits.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class Debits extends MoneyFunds<Debits> {
  Debits() : super();

  @override
  Debits getSelfNewInstance() {
    return Debits();
  }

  @override
  List<String> getMainFields({BuildContext? context}) =>
      ["customers", "employees", "date", "value", "equalities", "warehouse"];
  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.debits;
  @override
  IconData getMainIconData() => Icons.outbox;

  @override
  String? getTableNameApi() => "debits";

  factory Debits.fromJson(Map<String, dynamic> data) => _$DebitsFromJson(data);

  Map<String, dynamic> toJson() => _$DebitsToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  Debits fromJsonViewAbstract(Map<String, dynamic> json) =>
      Debits.fromJson(json);
}
