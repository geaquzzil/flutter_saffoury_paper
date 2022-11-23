import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';

abstract class PrintableMaster<T extends PrintLocalSetting> {
  ///QR CODE CONTENT
  String? getPrintableQrCode(T? pca);

  ///CONTAINS QR CODE TITLE
  String? getPrintableQrCodeID(T? pca);

  ///HexColor
  String getPrintablePrimaryColor(T? pca);

  ///HexColor
  String getPrintableSecondaryColor(T? pca);

  String getPrintableInvoiceTitle(
      BuildContext context, T? pca);

      
}
