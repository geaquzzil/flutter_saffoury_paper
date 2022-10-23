import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/prints/print_commad_abstract.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';

abstract class PrintableMaster<T extends PrintLocalSetting> {
  ///QR CODE CONTENT
  String getPrintableQrCode();

  ///CONTAINS QR CODE TITLE
  String getPrintableQrCodeID();

  ///HexColor
  String getPrintablePrimaryColor();

  ///HexColor
  String getPrintableSecondaryColor();

  String getPrintableInvoiceTitle(
      BuildContext context, T? pca);

      
}
