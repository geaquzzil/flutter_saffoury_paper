import 'package:flutter/material.dart' as mt;
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/models/prints/print_commad_abstract.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

Widget buildTitle(mt.BuildContext context, PrintableMaster printObj,
        {PrintCommandAbstract? printCommandAbstract}) =>
    Padding(
        padding: EdgeInsets.symmetric(horizontal: 26, vertical: 5),
        child: Text(
          printObj
              .getPrintableInvoiceTitle(context, printCommandAbstract)
              .toUpperCase(),
          style: TextStyle(
              fontSize: 20,
              color: PdfColor.fromHex(printObj.getPrintablePrimaryColor())),
        ));

Widget buildQrCode(mt.BuildContext context, PrintableMaster printObj,
    {PrintCommandAbstract? printCommandAbstract,
    bool withPaddingTop = true,
    double size = 80}) {
  return Column(
      // verticalDirection: VerticalDirection.down,
      // crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (withPaddingTop) SizedBox(height: 80),
        // Container(color: PdfColors.blue, width: 100, height: 100),
        SizedBox(
            width: size,
            height: size,
            child: BarcodeWidget(
              barcode: Barcode.qrCode(),
              data: printObj.getPrintableQrCode(),
            )),
        SizedBox(height: .4 * (PdfPageFormat.cm)),
        Text(printObj.getPrintableQrCodeID(), style: TextStyle(fontSize: 9)),
      ]);
}
