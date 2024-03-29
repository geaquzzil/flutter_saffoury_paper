import 'package:flutter/material.dart' as mt;
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

Widget buildTitle<T extends PrintLocalSetting>(
        mt.BuildContext context, PrintableMaster printObj,
        {T? printCommandAbstract}) =>
    Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 5),
        child: Text(
          printObj
              .getPrintableInvoiceTitle(context, printCommandAbstract)
              .toUpperCase(),
          style: TextStyle(
              fontSize: 20,
              color: PdfColor.fromHex(
                  printObj.getPrintablePrimaryColor(printCommandAbstract))),
        ));

Widget buildQrCode<T extends PrintLocalSetting>(
    mt.BuildContext context, PrintableMaster printObj,
    {T? printCommandAbstract, bool withPaddingTop = true, double size = 80}) {
  if ((printCommandAbstract?.hideQrCode ?? false)) {
    return Column(children: [SizedBox(width: size, height: size)]);
  }
  return Column(children: [
    SizedBox(
        width: size,
        height: size,
        child: BarcodeWidget(
          height: size,
          width: size,
          barcode: Barcode.qrCode(),
          data: printObj.getPrintableQrCode(),
        )),
    SizedBox(height: .1 * (PdfPageFormat.cm)),
    Text(
      printObj.getPrintableQrCodeID(),
    ),
  ]);
}
