import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_saffoury_paper/models/products/warehouse.dart';
import 'package:flutter_saffoury_paper/models/users/employees.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'warehouse_employees.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class WarehouseEmployee extends ViewAbstract<WarehouseEmployee> {
  // int? EmployeeID;
  // int? WarehouseID;

  Warehouse? warehouse;
  Employee? employees;

  WarehouseEmployee() : super();

  @override
  WarehouseEmployee getSelfNewInstance() {
    //TODO
    return WarehouseEmployee();
  }

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) {
    return AppLocalizations.of(context)!.warehouse;
  }

  @override
  IconData getMainIconData() => Icons.warehouse;
  @override
  String? getTableNameApi() => "warehouse_employees";

  @override
  Map<String, int> getTextInputMaxLengthMap() => {};

  @override
  String? getMainDrawerGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.employeesWarehouse;

  @override
  Map<String, IconData> getFieldIconDataMap() => {};

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {};

  @override
  List<String> getMainFields({BuildContext? context}) =>
      ["warehouse", "employee"];

  @override
  String getMainHeaderTextOnly(BuildContext context) =>
      "${warehouse?.name}: ${employees?.name}";

  @override
  String? getSortByFieldName() => null;

  @override
  SortByType getSortByType() => SortByType.ASC;

  @override
  Map<String, bool> getTextInputIsAutoCompleteMap() => {};

  @override
  Map<String, bool> getTextInputIsAutoCompleteViewAbstractMap() => {};

  @override
  Map<String, double> getTextInputMaxValidateMap() => {};

  @override
  Map<String, double> getTextInputMinValidateMap() => {};

  @override
  Map<String, TextInputType?> getTextInputTypeMap() => {};

  @override
  Map<String, bool> isFieldCanBeNullableMap() =>
      {"employees": false, "warehouse": false};

  @override
  Map<String, bool> isFieldRequiredMap() => {};

  factory WarehouseEmployee.fromJson(Map<String, dynamic> data) =>
      _$WarehouseEmployeeFromJson(data);

  Map<String, dynamic> toJson() => _$WarehouseEmployeeToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  WarehouseEmployee fromJsonViewAbstract(Map<String, dynamic> json) =>
      WarehouseEmployee.fromJson(json);

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      {"warehouse": Warehouse(), "employee": Employee()};

  
}
