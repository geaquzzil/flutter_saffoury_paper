// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warehouse_employees.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WarehouseEmployee _$WarehouseEmployeeFromJson(Map<String, dynamic> json) =>
    WarehouseEmployee()
      ..iD = json['iD'] as int
      ..warehouse = json['warehouse'] == null
          ? null
          : Warehouse.fromJson(json['warehouse'] as Map<String, dynamic>)
      ..employees = json['employees'] == null
          ? null
          : Employee.fromJson(json['employees'] as Map<String, dynamic>);

Map<String, dynamic> _$WarehouseEmployeeToJson(WarehouseEmployee instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'warehouse': instance.warehouse?.toJson(),
      'employees': instance.employees?.toJson(),
    };
