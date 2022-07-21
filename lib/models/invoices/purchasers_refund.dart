import 'package:flutter_view_controller/models/va_mirrors.dart';
import 'package:json_annotation/json_annotation.dart';

import 'invoice_master.dart';
import 'invoice_master_details.dart';


part 'purchasers_refund.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class PurchasesRefund extends InvoiceMaster<PurchasesRefund> {
  List<PurchasesRefundDetails>? purchases_details;
  PurchasesRefund() : super();
}

@JsonSerializable(explicitToJson: true)
@reflector
class PurchasesRefundDetails
    extends InvoiceMasterDetails<PurchasesRefundDetails> {
  PurchasesRefund? purchasesRefund;
  PurchasesRefundDetails() : super();
}
