import 'package:flutter_view_controller/models/va_mirrors.dart';
import 'package:json_annotation/json_annotation.dart';

import 'invoice_master.dart';
import 'invoice_master_details.dart';


part 'purchases.g.dart';
@JsonSerializable(explicitToJson: true)
@reflector
class Purchases extends InvoiceMaster<Purchases> {
  List<PurchasesDetails>? purchases_details;
  Purchases() : super();
}

@JsonSerializable(explicitToJson: true)
@reflector
class PurchasesDetails extends InvoiceMasterDetails<PurchasesDetails> {
  Purchases? purchases;
  PurchasesDetails() : super();
}
