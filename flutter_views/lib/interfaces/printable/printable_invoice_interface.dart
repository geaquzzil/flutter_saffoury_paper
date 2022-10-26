import 'package:flutter/material.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:pdf/pdf.dart';

abstract class PrintableInvoiceInterfaceDetails<T extends PrintLocalSetting> {
  Map<String, String> getPrintableInvoiceTableHeaderAndContent(
      BuildContext context, T? pca);
}

abstract class PrintableInvoiceInterface<T extends PrintLocalSetting> extends PrintableMaster <T>{
  

  List<List<InvoiceHeaderTitleAndDescriptionInfo>> getPrintableInvoiceInfo(
      BuildContext context, T? pca);

  List<InvoiceTotalTitleAndDescriptionInfo> getPrintableInvoiceTotal(
      BuildContext context, T? pca);

  List<InvoiceTotalTitleAndDescriptionInfo> getPrintableInvoiceTotalDescripton(
      BuildContext context, T? pca);

  List<PrintableInvoiceInterfaceDetails> getPrintableInvoiceDetailsList();

  List<InvoiceHeaderTitleAndDescriptionInfo>
      getPrintableInvoiceAccountInfoInBottom(
          BuildContext context, T? pca);

  
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
