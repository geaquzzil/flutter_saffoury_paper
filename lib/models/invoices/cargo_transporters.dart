import 'package:flutter_saffoury_paper/models/cities/governorates.dart';
import 'package:flutter_saffoury_paper/models/invoices/invoice_master.dart';
import 'package:flutter_view_controller/models/va_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cargo_transporters.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class CargoTransporter extends InvoiceMaster<CargoTransporter> {
  // int? GovernorateID;

  String? name;
  String? phone;
  double? maxWeight;
  String? carNumber;
  Governorate? governorates;

  CargoTransporter() : super();
}
