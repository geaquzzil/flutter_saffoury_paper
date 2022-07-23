import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/icon_data.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/services/text_input.dart';
import 'package:flutter_saffoury_paper/models/funds/currency/currency.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_saffoury_paper/models/funds/money_funds.dart';
import 'package:flutter_view_controller/models/va_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
part 'equalities.g.dart';

@JsonSerializable()
@reflector
class Equalities extends ViewAbstract<Equalities> {
  int? CurrencyID;
  double? value;
  String? date;

  Currency? currency;

  Equalities() : super();

  @override
  List<String> getMainFields() => ["currency", "value", "date"];

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {
        "value": AppLocalizations.of(context)!.value,
        "date": AppLocalizations.of(context)!.date
      };

  @override
  Map<String, IconData> getFieldIconDataMap() =>
      {"value": Icons.monetization_on, "date": Icons.date_range};

  @override
  String? getMainDrawerGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.money_fund;

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.equality;

  @override
  String getMainHeaderTextOnly(BuildContext context) =>
      "1 USD = ${1 / (value ?? 1)}";

  @override
  IconData getMainIconData() => Icons.currency_exchange;

  @override
  String? getSortByFieldName() => "date";

  @override
  SortByType getSortByType() => SortByType.DESC;

  @override
  String? getTableNameApi() => "equalities";

  @override
  Map<String, bool> getTextInputIsAutoCompleteMap() => {};

  @override
  Map<String, bool> getTextInputIsAutoCompleteViewAbstractMap() => {};

  @override
  Map<String, int> getTextInputMaxLengthMap() => {"value": 6};

  @override
  Map<String, double> getTextInputMinValidateMap() => {"value": 1};

  @override
  Map<String, TextInputType?> getTextInputTypeMap() =>
      {"value": TextInputType.number, "date": TextInputType.datetime};
  @override
  Map<String, bool> isFieldCanBeNullableMap() => {"currency": false};

  @override
  Map<String, bool> isFieldRequiredMap() => {"value": true, "currency": true};

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    // TODO: implement toJsonViewAbstract
    throw UnimplementedError();
  }

  @override
  Equalities fromJsonViewAbstract(Map<String, dynamic> json) {
    // TODO: implement fromJsonViewAbstract
    throw UnimplementedError();
  }

  @override
  Map<String, double> getTextInputMaxValidateMap() => {};
}
