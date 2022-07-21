import 'package:flutter_saffoury_paper/models/invoices/invoice_master.dart';
import 'package:flutter_saffoury_paper/models/products/sizes.dart';
import 'package:flutter_saffoury_paper/models/users/customers.dart';
import 'package:flutter_saffoury_paper/models/users/employees.dart';
import 'package:flutter_view_controller/models/va_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:json_annotation/json_annotation.dart';
part 'customers_request_sizes.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class CustomerRequestSize extends ViewAbstract<CustomerRequestSize> {
  // int? CustomerID;
  // int? EmployeeID;

  String? date;
  String? comments;
  Customer? customers;
  Employee? employees;

  List<CustomerRequestSizeDetails>? customers_requesst_sizes_details;
  int? customers_requesst_sizes_details_count;

  CustomerRequestSize() : super();
}

@JsonSerializable(explicitToJson: true)
@reflector
class CustomerRequestSizeDetails
    extends ViewAbstract<CustomerRequestSizeDetails> {
  // int? CustomerReqID;
  // int ?SizeID;
  CustomerRequestSize? customers_request_sizes;
  Size sizes;
  String? date;

  CustomerRequestSizeDetails() : super();
}
