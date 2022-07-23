import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/invoices/invoice_master.dart';
import 'package:flutter_saffoury_paper/models/users/user.dart';
import 'package:flutter_view_controller/models/va_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
part 'employees.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class Employee extends User<Employee> {
  // int? ParentID;
  int? publish;

  Employee? employee;

  Employee() : super();

  @override
  IconData getMainIconData() {
    return Icons.engineering;
  }

  @override
  String? getTableNameApi() {
    return "employees";
  }

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.customer;

  @override
  Map<String, bool> isFieldCanBeNullableMap() => {};

  
  @override
  Map<String, dynamic> toJsonViewAbstract() {
    return toJson();
  }

  @override
  Employee fromJsonViewAbstract(Map<String, dynamic> json) {
    return new Employee();
  }
}
