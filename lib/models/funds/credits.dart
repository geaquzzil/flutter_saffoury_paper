import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/icon_data.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_saffoury_paper/models/funds/money_funds.dart';
import 'package:flutter_view_controller/models/va_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
part 'credits.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class Credits extends MoneyFunds<Credits> {
  Credits() : super();

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.credits;
  @override
  IconData getMainIconData() => Icons.move_to_inbox_sharp;

  @override
  String? getTableNameApi() => "credits";

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    // TODO: implement toJsonViewAbstract
    throw UnimplementedError();
  }

  @override
  Credits fromJsonViewAbstract(Map<String, dynamic> json) {
    // TODO: implement fromJsonViewAbstract
    throw UnimplementedError();
  }
}
