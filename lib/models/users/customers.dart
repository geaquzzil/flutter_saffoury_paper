import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/users/user.dart';
import 'package:flutter_view_controller/models/va_mirrors.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'employees.dart';

part 'customers.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class Customer extends User<Customer> {
  // int? EmployeeID;
  int? cash;

  double? totalCredits;
  double? totalDebits;
  double? totalOrders;
  double? totalPurchases;
  double? balance;

  Employee? employees;

  Customer() : super();

  @override
  IconData getMainIconData() {
    return Icons.account_circle;
  }

  @override
  String? getTableNameApi() {
    return "customers";
  }

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.customer;
  factory Customer.fromJson(Map<String, dynamic> data) =>
      _$CustomerFromJson(data);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  Customer fromJsonViewAbstract(Map<String, dynamic> json) =>
      Customer.fromJson(json);
}
