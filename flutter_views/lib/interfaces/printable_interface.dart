import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/prints/print_commad_abstract.dart';
import 'package:pdf/pdf.dart';

abstract class PrintableInterfaceDetails {
  Map<String, String> getInvoiceTableHeaderAndContent(
      BuildContext context, PrintCommandAbstract? pca);
}

abstract class PrintableInterface {
  String getInvoiceTitle(BuildContext context, PrintCommandAbstract? pca);

  List<List<InvoiceHeaderTitleAndDescriptionInfo>> getInvoiceInfo(
      BuildContext context, PrintCommandAbstract? pca);

  List<InvoiceTotalTitleAndDescriptionInfo> getInvoiceTotal(
      BuildContext context, PrintCommandAbstract? pca);

  List<InvoiceTotalTitleAndDescriptionInfo> getInvoiceTotalDescripton(
      BuildContext context, PrintCommandAbstract? pca);

  List<PrintableInterfaceDetails> getInvoiceDetailsList();

  List<InvoiceHeaderTitleAndDescriptionInfo> getInvoiceAccountInfoInBottom(
      BuildContext context, PrintCommandAbstract? pca);

  String getInvoicePrimaryColor();
  String getInvoiceSecondaryColor();
  String getInvoiceQrCode();
  String getInvoiceQrCodeID();
}

class InvoiceHeaderTitleAndDescriptionInfo {
  IconData? icon;
  String title;
  String description;
  InvoiceHeaderTitleAndDescriptionInfo(
      {required this.title, required this.description, this.icon});
}

class InvoiceTotalTitleAndDescriptionInfo {
  String? hexColor;
  String title;
  String? description;
  double? size;
  InvoiceTotalTitleAndDescriptionInfo(
      {required this.title, this.description, this.hexColor, this.size});

  PdfColor getColor() {
    if (hexColor == null) return PdfColors.black;
    return PdfColor.fromHex(hexColor ?? "");
  }
}
