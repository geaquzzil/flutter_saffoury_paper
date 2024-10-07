import 'package:flutter/material.dart' as mt;
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

const double printerLabelFontSizePrimary = 14;
const double printerLabelFontSizeSecoundry = 8;

const double printerFontSizePrimary = 32;
const double printerFontSizeSecoundry = 10;
const double point = 1.0;
const double inch = 72.0;
const double cm = inch / 2.54;
const double mm = inch / 25.4;
const PdfPageFormat roll80 =
    PdfPageFormat(80 * mm, 120 * mm, marginAll: 2 * mm);

double findLabelTextSize({PdfPageFormat? format}) {
  switch (format) {
    case PdfPageFormat.a4:
      break;
    case PdfPageFormat.a5:
      break;
    case PdfPageFormat.a3:
      break;
    case roll80:
      break;
    default:
      break;
  }
}

double findTextSize({
  PdfPageFormat? format,
}) {
  switch (format) {
    case PdfPageFormat.a4:
      break;
    case PdfPageFormat.a5:
      break;
    case PdfPageFormat.a3:
      break;
    case roll80:
      break;
    default:
      break;
  }
}

Widget buildLabelAndText(String label, String value,
    {double size = 80,
    Widget? isValueWidget,
    PdfPageFormat? format,
    double fontSize = printerFontSizePrimary}) {
  fontSize = isLabel ? printerLabelFontSizePrimary : fontSize;
  size = isLabel ? 40 : size;
  return Container(
      height: size,
      // padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        border: Border.all(color: PdfColors.black, width: .5),
        // borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      child: Column(children: [
        Align(
            child: Padding(
                padding: isLabel
                    ? const EdgeInsets.symmetric(horizontal: 1, vertical: 4)
                    : const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(label,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                            fontWeight:
                                isLabel ? FontWeight.bold : FontWeight.normal,
                            fontSize: isLabel
                                ? printerLabelFontSizeSecoundry
                                : printerFontSizeSecoundry)))),
            alignment: Globals.isArabic(context)
                ? Alignment.topRight
                : Alignment.topLeft),
        Expanded(
            child: Align(
                alignment: Alignment.center,
                child: isValueWidget ??
                    Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text(value,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: fontSize))))),
      ]));
}

Widget borderContainer(Widget child, {double padding = 0}) {
  return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(border: Border.all()),
      child: child);
}

Widget wrapBorderContainerWithExpanded(Widget child,
    {double padding = 0, int flex = 1}) {
  return Expanded(flex: flex, child: borderContainer(child, padding: padding));
}

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

Widget buildBarcode(mt.BuildContext context, String barcode,
    {double size = 20}) {
  return Column(children: [
    SizedBox(
        width: double.maxFinite,
        height: size,
        child: BarcodeWidget(
          height: size,
          width: double.maxFinite,
          barcode: Barcode.code128(),
          data: barcode,
        )),
  ]);
}

Widget buildQrCode<T extends PrintLocalSetting>(
    mt.BuildContext context, PrintableMaster printObj,
    {T? printCommandAbstract,
    bool withPaddingTop = true,
    double size = 80,
    double fontSize = 10}) {
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
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
    ),
  ]);
}
