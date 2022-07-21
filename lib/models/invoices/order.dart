import 'package:flutter_saffoury_paper/models/invoices/invoice_master.dart';
import 'package:flutter_view_controller/models/va_mirrors.dart';
import 'package:json_annotation/json_annotation.dart';

import 'invoice_master_details.dart';

part 'order.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class Order extends InvoiceMaster<Order> {
  List<OrderDetails>? order_details;
  Order() : super();
}

@JsonSerializable(explicitToJson: true)
@reflector
class OrderDetails extends InvoiceMasterDetails<OrderDetails> {
  Order? orders;
  OrderDetails() : super();
}
