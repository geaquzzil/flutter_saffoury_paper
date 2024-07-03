import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/invoices/invoice_master_details.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_saffoury_paper/models/invoices/cargo_transporters.dart';
import 'package:flutter_saffoury_paper/models/users/customers.dart';
import 'package:flutter_saffoury_paper/models/users/employees.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_saffoury_paper/models/products/warehouse.dart';
import '../invoice_master.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
part 'reservation_invoice.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class ReservationInvoice extends InvoiceMaster<ReservationInvoice> {
  List<ReservationInvoiceDetails>? reservation_invoice_details;
  int? reservation_invoice_details_count;
  ReservationInvoice() : super() {
    reservation_invoice_details = <ReservationInvoiceDetails>[];
  }

  @override
  ReservationInvoice getSelfNewInstance() {
    return ReservationInvoice();
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      super.getMirrorFieldsMapNewInstance()
        ..addAll({
          "reservation_invoice_details":
              List<ReservationInvoiceDetails>.empty(),
          "reservation_invoice_details_count": 0
        });

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.reservationInvoice;

  @override
  String? getTableNameApi() => "reservation_invoice";

  factory ReservationInvoice.fromJson(Map<String, dynamic> data) =>
      _$ReservationInvoiceFromJson(data);

  Map<String, dynamic> toJson() => _$ReservationInvoiceToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  ReservationInvoice fromJsonViewAbstract(Map<String, dynamic> json) =>
      ReservationInvoice.fromJson(json);
}

@JsonSerializable(explicitToJson: true)
@reflector
class ReservationInvoiceDetails
    extends InvoiceMasterDetails<ReservationInvoiceDetails> {
  // int? ReservationID;
  ReservationInvoice? reservation_invoice;
  ReservationInvoiceDetails() : super();
  @override
  ReservationInvoiceDetails getSelfNewInstance() {
    return ReservationInvoiceDetails();
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      super.getMirrorFieldsMapNewInstance()
        ..addAll({
          "reservation_invoice": ReservationInvoice(),
        });

  @override
  String? getTableNameApi() => "reservation_invoice_details";

  factory ReservationInvoiceDetails.fromJson(Map<String, dynamic> data) =>
      _$ReservationInvoiceDetailsFromJson(data);

  Map<String, dynamic> toJson() => _$ReservationInvoiceDetailsToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  ReservationInvoiceDetails fromJsonViewAbstract(Map<String, dynamic> json) =>
      ReservationInvoiceDetails.fromJson(json);
}
