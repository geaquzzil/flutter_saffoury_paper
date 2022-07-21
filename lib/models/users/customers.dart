import 'package:flutter_saffoury_paper/models/invoices/invoice_master.dart';
import 'package:flutter_saffoury_paper/models/users/user.dart';
import 'package:flutter_view_controller/models/va_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:json_annotation/json_annotation.dart';

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
}
