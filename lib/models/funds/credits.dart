import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/funds/money_funds.dart';
import 'package:flutter_view_controller/models/va_mirrors.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
part 'credits.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class Credits extends MoneyFunds<Credits> {
  Credits() : super();
  @override
  List<String> getMainFields() =>
      ["customer", "employee", "date", "value", "equalities", "warehouse"];

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.credits;
  @override
  IconData getMainIconData() => Icons.move_to_inbox_sharp;

  @override
  String? getTableNameApi() => "credits";

   factory Credits.fromJson(Map<String, dynamic> data) =>
      _$CreditsFromJson(data);

  Map<String, dynamic> toJson() => _$CreditsToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  Credits fromJsonViewAbstract(Map<String, dynamic> json) =>
      Credits.fromJson(json);
}
