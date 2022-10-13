import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/funds/money_funds.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_saffoury_paper/models/users/customers.dart';
import 'package:flutter_saffoury_paper/models/funds/currency/equalities.dart';
import 'package:flutter_saffoury_paper/models/products/warehouse.dart';
import 'package:flutter_saffoury_paper/models/users/employees.dart';

part 'debits.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class Debits extends MoneyFunds<Debits> {
  Debits() : super();
  @override
  List<String> getMainFields() =>
      ["customer", "employee", "date", "value", "equalities", "warehouse"];
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
