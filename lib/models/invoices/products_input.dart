import 'package:flutter_view_controller/models/va_mirrors.dart';
import 'package:json_annotation/json_annotation.dart';

import 'invoice_master.dart';
import 'invoice_master_details.dart';


part 'products_input.g.dart';
@JsonSerializable(explicitToJson: true)
@reflector
class ProductInput extends InvoiceMaster<ProductInput> {
  List<ProductInputDetails>? product_input_details;
  ProductInput() : super();
}

@JsonSerializable(explicitToJson: true)
@reflector
class ProductInputDetails extends InvoiceMasterDetails<ProductInputDetails> {
  ProductInput? products_input;

  ProductInputDetails() : super();
}
