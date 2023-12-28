import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';

abstract class PrintableMaster<T extends PrintLocalSetting>
    extends PrintableMasterEmpty<T> {
  ///QR CODE CONTENT
  String getPrintableQrCode();

  ///CONTAINS QR CODE TITLE
  String getPrintableQrCodeID();

  ///HexColor
  String getPrintablePrimaryColor(T? pca);

  ///HexColor
  String getPrintableSecondaryColor(T? pca);

  String getPrintableInvoiceTitle(BuildContext context, T? pca);

  pdf.Widget? getPrintableWatermark();

  List<dynamic>? getPrintableInvoiceTableHeaderAndContentWhenDashboard(
      BuildContext context, PrintLocalSetting? dashboardSetting);
}

class PrintableMasterEmpty<T extends PrintLocalSetting> {}
