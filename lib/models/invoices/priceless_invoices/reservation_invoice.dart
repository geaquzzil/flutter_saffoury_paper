import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_saffoury_paper/models/invoices/invoice_master_details.dart';
import 'package:flutter_view_controller/models/va_mirrors.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:json_annotation/json_annotation.dart';

import '../invoice_master.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
part 'reservation_invoice.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class ReservationInvoice extends InvoiceMaster<ReservationInvoice> {
  List<ReservationInvoiceDetails>? reservation_invoice_details;
  int? reservation_invoice_details_count;
  ReservationInvoice() : super();

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.reservationInvoice;

  @override
  String? getTableNameApi() => "reservation_invoice";

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    // TODO: implement toJsonViewAbstract
    throw UnimplementedError();
  }

  @override
  ReservationInvoice fromJsonViewAbstract(Map<String, dynamic> json) {
    // TODO: implement fromJsonViewAbstract
    throw UnimplementedError();
  }
}

@JsonSerializable(explicitToJson: true)
@reflector
class ReservationInvoiceDetails
    extends InvoiceMasterDetails<ReservationInvoiceDetails> {
  int? ReservationID;
  ReservationInvoice? reservation_invoice;
  ReservationInvoiceDetails() : super();

  @override
  String? getTableNameApi() => "reservation_invoice_details";

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    // TODO: implement toJsonViewAbstract
    throw UnimplementedError();
  }

  @override
  ReservationInvoiceDetails fromJsonViewAbstract(Map<String, dynamic> json) {
    // TODO: implement fromJsonViewAbstract
    throw UnimplementedError();
  }
}
