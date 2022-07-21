import 'package:flutter_view_controller/models/va_mirrors.dart';
import 'package:json_annotation/json_annotation.dart';

import 'invoice_master.dart';
import 'invoice_master_details.dart';

part 'transfers.g.dart';
@JsonSerializable(explicitToJson: true)
@reflector
class Transfers extends InvoiceMaster<Transfers> {
  List<TransfersDetails>? transfers_details;
  Transfers() : super();
}

@JsonSerializable(explicitToJson: true)
@reflector
class TransfersDetails extends InvoiceMasterDetails<TransfersDetails> {
  Transfers? transfers;
  TransfersDetails() : super();
}
