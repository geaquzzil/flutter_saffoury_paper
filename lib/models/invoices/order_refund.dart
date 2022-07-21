import 'package:flutter_saffoury_paper/models/invoices/invoice_master.dart';
import 'package:flutter_saffoury_paper/models/invoices/invoice_master_details.dart';
import 'package:flutter_view_controller/models/va_mirrors.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_refund.g.dart';
@JsonSerializable(explicitToJson: true)
@reflector
class OrderRefund extends InvoiceMaster<OrderRefund> {
  List<OrderRefundDetails>? orders_refunds_details;
  OrderRefund() : super();
}

@JsonSerializable(explicitToJson: true)
@reflector
class OrderRefundDetails extends InvoiceMasterDetails<OrderRefund> {
  OrderRefund? orders_refunds;
  OrderRefundDetails() : super();
}
