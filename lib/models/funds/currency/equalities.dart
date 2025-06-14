import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/funds/currency/currency.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/models/view_abstract_inputs_validaters.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:json_annotation/json_annotation.dart';

part 'equalities.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class Equalities extends ViewAbstract<Equalities> {
  // int? CurrencyID;
  double? value;
  String? date;

  Currency? currency;

  Equalities() : super() {
    date = "".toDateTimeNowString();
  }
  @override
  String getForeignKeyName() {
    return "EqualitiesID";
  }

  @override
  Equalities getSelfNewInstance() {
    return Equalities();
  }

  bool isDollar() {
    return currency?.iD == 1;
  }

  @override
  FormFieldControllerType getInputType(String field) {
    if (field == "currency") {
      return FormFieldControllerType.DROP_DOWN_API;
    }
    return FormFieldControllerType.EDIT_TEXT;
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      {"value": 0.toDouble(), "date": "", "currency": Currency()};
  @override
  List<String> getMainFields({BuildContext? context}) =>
      ["currency", "value", "date"];

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
      "1 USD = ${(1 / (value ?? 1)).toCurrencyFormat()}";

  @override
  IconData getMainIconData() => Icons.currency_exchange;

  @override
  SortFieldValue? getSortByInitialType() =>
      SortFieldValue(field: "date", type: SortByType.DESC);

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

  factory Equalities.fromJson(Map<String, dynamic> data) =>
      _$EqualitiesFromJson(data);

  Map<String, dynamic> toJson() => _$EqualitiesToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  Equalities fromJsonViewAbstract(Map<String, dynamic> json) =>
      Equalities.fromJson(json);

  @override
  Map<String, double> getTextInputMaxValidateMap() => {};
}
