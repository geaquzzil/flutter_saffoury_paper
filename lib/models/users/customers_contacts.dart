import 'package:flutter_saffoury_paper/models/invoices/invoice_master.dart';
import 'package:flutter_saffoury_paper/models/users/user.dart';
import 'package:flutter_view_controller/models/va_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:json_annotation/json_annotation.dart';

import 'customers.dart';
import 'employees.dart';

part 'customers_contacts.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class CustomerContacts extends ViewAbstract<CustomerContacts> {
  int? CustomerID;
  Customer? customers;

  String? name; // varchare 50
  String? phone; // varchasre 20

  CustomerContacts() : super();
}
