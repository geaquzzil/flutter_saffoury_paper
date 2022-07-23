import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/funds/accounts/account_names.dart';
import 'package:flutter_saffoury_paper/models/funds/money_funds.dart';
import 'package:flutter_view_controller/models/va_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
part 'spendings.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class Spendings extends MoneyFunds<Spendings> {
  int? NameID;
  AccountName? account_names;
  Spendings() : super();

  @override
  List<String> getMainFields() =>
      ["account_names", "employee", "date", "value", "equalities", "warehouse"];

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.credits;
  @override
  IconData getMainIconData() => Icons.input_rounded;

  @override
  String? getTableNameApi() => "spendings";

  @override
  Spendings fromJsonViewAbstract(Map<String, dynamic> json) {
    // TODO: implement fromJsonViewAbstract
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    // TODO: implement toJsonViewAbstract
    throw UnimplementedError();
  }
}
