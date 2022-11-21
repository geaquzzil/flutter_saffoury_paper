// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warehouse_employees.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WarehouseEmployee _$WarehouseEmployeeFromJson(Map<String, dynamic> json) =>
    WarehouseEmployee()
      ..iD = json['iD'] as int
      ..searchByAutoCompleteTextInput =
          json['searchByAutoCompleteTextInput'] as String?
      ..delete = json['delete'] as bool?
      ..warehouse = json['warehouse'] == null
          ? null
          : Warehouse.fromJson(json['warehouse'] as Map<String, dynamic>)
      ..employees = json['employees'] == null
          ? null
          : Employee.fromJson(json['employees'] as Map<String, dynamic>);

Map<String, dynamic> _$WarehouseEmployeeToJson(WarehouseEmployee instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'searchByAutoCompleteTextInput': instance.searchByAutoCompleteTextInput,
      'delete': instance.delete,
      'warehouse': instance.warehouse?.toJson(),
      'employees': instance.employees?.toJson(),
    };
