import 'package:flutter/material.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/models/prints/print_commad_abstract.dart';
import 'package:pdf/pdf.dart';

abstract class PrintableReceiptInterface extends PrintableMaster {
  ///for each int key is a column
  ///for each List is row list
  Map<int, List<RecieptHeaderTitleAndDescriptionInfo>>
      getPrintableRecieptHeaderTitleAndDescription(
          BuildContext context, PrintCommandAbstract? pca);
}

class RecieptHeaderTitleAndDescriptionInfo {
  IconData? icon;
  String? hexColor;
  String title;
  String description;
  RecieptHeaderTitleAndDescriptionInfo(
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
