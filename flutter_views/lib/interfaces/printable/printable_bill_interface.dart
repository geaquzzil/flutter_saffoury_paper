import 'package:flutter/material.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;

abstract class PrintableReceiptInterface<T extends PrintLocalSetting>
    extends PrintableMaster<T> {
  ///for each int key is a column
  ///for each List is row list
  Map<int, List<RecieptHeaderTitleAndDescriptionInfo>>
      getPrintableRecieptHeaderTitleAndDescription(
          BuildContext context, T? pca);

  Map<int, List<RecieptHeaderTitleAndDescriptionInfo>>
      getPrintableRecieptFooterTitleAndDescription(
          BuildContext context, T? pca);

  pdf.Widget? getPrintableRecieptCustomWidget(BuildContext context, T? pca);
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
