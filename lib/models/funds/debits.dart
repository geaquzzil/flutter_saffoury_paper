import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/funds/money_funds.dart';
import 'package:flutter_view_controller/models/va_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

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

  @override
  Debits fromJsonViewAbstract(Map<String, dynamic> json) {
    // TODO: implement fromJsonViewAbstract
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    // TODO: implement toJsonViewAbstract
    throw UnimplementedError();
  }
}
