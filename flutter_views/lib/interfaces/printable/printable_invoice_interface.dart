import 'package:flutter/material.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/models/prints/print_commad_abstract.dart';
import 'package:pdf/pdf.dart';

abstract class PrintableInvoiceInterfaceDetails {
  Map<String, String> getPrintableInvoiceTableHeaderAndContent(
      BuildContext context, PrintCommandAbstract? pca);
}

abstract class PrintableInvoiceInterface extends PrintableMaster {
  

  List<List<InvoiceHeaderTitleAndDescriptionInfo>> getPrintableInvoiceInfo(
      BuildContext context, PrintCommandAbstract? pca);

  List<InvoiceTotalTitleAndDescriptionInfo> getPrintableInvoiceTotal(
      BuildContext context, PrintCommandAbstract? pca);

  List<InvoiceTotalTitleAndDescriptionInfo> getPrintableInvoiceTotalDescripton(
      BuildContext context, PrintCommandAbstract? pca);

  List<PrintableInvoiceInterfaceDetails> getPrintableInvoiceDetailsList();

  List<InvoiceHeaderTitleAndDescriptionInfo>
      getPrintableInvoiceAccountInfoInBottom(
          BuildContext context, PrintCommandAbstract? pca);

  
}

class InvoiceHeaderTitleAndDescriptionInfo {
  IconData? icon;
  String? hexColor;
  String title;
  String description;
  InvoiceHeaderTitleAndDescriptionInfo(
      {required this.title,
      required this.description,
      this.icon,
      this.hexColor});

  int? getCodeIcon() {
    return icon?.codePoint;
  }

  PdfColor getColor() {
    if (hexColor == null) return PdfColors.black;
    return PdfColor.fromHex(hexColor ?? "");
  }
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
