import 'package:flutter_view_controller/models/va_mirrors.dart';
import 'package:json_annotation/json_annotation.dart';

import 'invoice_master.dart';
import 'invoice_master_details.dart';
part 'products_output.g.dart';
@JsonSerializable(explicitToJson: true)
@reflector
class ProductOutput extends InvoiceMaster<ProductOutput> {
  List<ProductOutputDetails>? products_outputs_details;
  ProductOutput() : super();
}

@JsonSerializable(explicitToJson: true)
@reflector
class ProductOutputDetails extends InvoiceMasterDetails<ProductOutputDetails> {
  ProductOutput? products_outputs;

  ProductOutputDetails() : super();
}
