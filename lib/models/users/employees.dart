import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/users/user.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_saffoury_paper/models/invoices/cargo_transporters.dart';
import 'package:flutter_saffoury_paper/models/invoices/cuts_invoices/cut_requests.dart';
import 'package:flutter_saffoury_paper/models/invoices/orders.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/customers_request_sizes.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/products_inputs.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/products_outputs.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/reservation_invoice.dart';
import 'package:flutter_view_controller/models/permissions/setting.dart';
import 'package:flutter_view_controller/models/permissions/permission_level_abstract.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/transfers.dart';
import 'package:flutter_saffoury_paper/models/invoices/refund_invoices/orders_refunds.dart';
import 'package:flutter_saffoury_paper/models/invoices/purchases.dart';
import 'package:flutter_saffoury_paper/models/invoices/refund_invoices/purchasers_refunds.dart';
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

  factory Employee.fromJson(Map<String, dynamic> data) =>
      _$EmployeeFromJson(data);

  @override
  Map<String, dynamic> toJson() => _$EmployeeToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  Employee fromJsonViewAbstract(Map<String, dynamic> json) =>
      Employee.fromJson(json);
}
