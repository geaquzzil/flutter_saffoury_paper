import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/users/user.dart';
import 'package:flutter_view_controller/models/apis/growth_rate.dart';
import 'package:flutter_view_controller/models/dealers/dealer.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'employees.dart';
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
import '../funds/credits.dart';
import '../funds/debits.dart';
import '../funds/incomes.dart';
import '../funds/spendings.dart';
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
  Customer getSelfNewInstance() {
    return Customer();
  }

  @override
  String getForeignKeyName() {
    return "CustomerID";
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      super.getMirrorFieldsMapNewInstance()
        ..addAll({
          "cash": 0,
          "totalCredits": 0,
          "totalDebits": 0,
          "totalOrders": 0,
          "totalPurchases": 0,
          "balance": 0,
          "employees": Employee(),
        });

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

  @override
  Map<String, dynamic> toJson() => _$CustomerToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  Customer fromJsonViewAbstract(Map<String, dynamic> json) =>
      Customer.fromJson(json);
}
