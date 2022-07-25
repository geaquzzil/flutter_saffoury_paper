import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/funds/currency/equalities.dart';
import 'package:flutter_saffoury_paper/models/products/warehouse.dart';
import 'package:flutter_saffoury_paper/models/users/employees.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../users/customers.dart';

abstract class MoneyFunds<T> extends ViewAbstract<T> {
  // int? CashBoxID;
  // int? EmployeeID;
  // int? CustomerID;
  // int? EqualitiesID;

  int? fromBox;
  int? isDirect;

  String? date;
  double? value;

  String? comments;

  Customer? customers;
  Employee? employees;
  Equalities? equalities;
  Warehouse? warehouse;

  MoneyFunds() : super();

 
  @override
  Map<String, IconData> getFieldIconDataMap() => {
        "value": Icons.attach_money_rounded,
        "date": Icons.date_range,
        "comments": Icons.notes
      };

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {
        "value": AppLocalizations.of(context)!.value,
        "date": AppLocalizations.of(context)!.date,
        "comments": AppLocalizations.of(context)!.comments
      };

  @override
  String getMainHeaderTextOnly(BuildContext context) {
    return "${customers?.name}: $value";
  }

  @override
  String? getSortByFieldName() => "date";

  @override
  SortByType getSortByType() => SortByType.DESC;

  @override
  Map<String, bool> getTextInputIsAutoCompleteMap() => {};

  @override
  Map<String, bool> getTextInputIsAutoCompleteViewAbstractMap() => {};

  @override
  Map<String, int> getTextInputMaxLengthMap() => {"value": 12};

  @override
  Map<String, double> getTextInputMaxValidateMap() => {};

  @override
  Map<String, double> getTextInputMinValidateMap() => {};

  @override
  Map<String, TextInputType?> getTextInputTypeMap() => {
        "value": TextInputType.number,
        "date": TextInputType.datetime,
        "comments": TextInputType.text
      };

  @override
  Map<String, bool> isFieldCanBeNullableMap() => {};

  @override
  Map<String, bool> isFieldRequiredMap() => {"value": true};

  @override
  String? getMainDrawerGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.money_fund;
}
