import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/prints/print_commad_abstract.dart';
import 'package:pdf/pdf.dart';

abstract class PrintableSharedParams{
  
}

abstract class PrintableInterfaceDetails {
  Map<String, String> getPrintableInvoiceTableHeaderAndContent(
      BuildContext context, PrintCommandAbstract? pca);
}

abstract class PrintableInterface {
  String getPrintableInvoiceTitle(
      BuildContext context, PrintCommandAbstract? pca);

  List<List<InvoiceHeaderTitleAndDescriptionInfo>> getPrintableInvoiceInfo(
      BuildContext context, PrintCommandAbstract? pca);

  List<InvoiceTotalTitleAndDescriptionInfo> getPrintableInvoiceTotal(
      BuildContext context, PrintCommandAbstract? pca);

  List<InvoiceTotalTitleAndDescriptionInfo> getPrintableInvoiceTotalDescripton(
      BuildContext context, PrintCommandAbstract? pca);

  List<PrintableInterfaceDetails> getPrintableInvoiceDetailsList();

  List<InvoiceHeaderTitleAndDescriptionInfo>
      getPrintableInvoiceAccountInfoInBottom(
          BuildContext context, PrintCommandAbstract? pca);

  String getPrintableInvoicePrimaryColor();
  String getPrintableInvoiceSecondaryColor();
  String getPrintableInvoiceQrCode();
  String getPrintableInvoiceQrCodeID();
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
