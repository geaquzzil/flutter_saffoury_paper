import 'package:flutter/material.dart' as mt;
import 'package:flutter_view_controller/globals.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

const double printerFontPrimaryRoll = 14;
const double printerFontSecondryRoll = 8;

const double printerFontPrimaryA4 = 32;
const double printerFontSecondryA4 = 10;

const double printerFontPrimaryA5 = 14;
const double printerFontSecondryA5 = 8;

const double printerFontPrimaryA3 = 42;
const double printerFontSecondryA3 = 14;

const double printerRectangleA4 = 80;
const double printerRectangleA5 = 40;
const double printerRectangleA3 = 100;
const double printerRectangleRoll = 40;

const double point = 1.0;
const double inch = 72.0;
const double cm = inch / 2.54;
const double mm = inch / 25.4;
const PdfPageFormat roll80 =
    PdfPageFormat(80 * mm, 120 * mm, marginAll: 2 * mm);

double printableFindLabelSize({PdfPageFormat? format}) {
  switch (format) {
    case PdfPageFormat.a4:
      return printerFontSecondryA4;
    case PdfPageFormat.a5:
      return printerFontSecondryA5;

    case PdfPageFormat.a3:
      return printerFontSecondryA3;
    case roll80:
      return printerFontSecondryRoll;

    default:
      return printerFontSecondryA4;
  }
}

double printableFindTitleSize({
  PdfPageFormat? format,
}) {
  switch (format) {
    case PdfPageFormat.a4:
      return 20;
    case PdfPageFormat.a5:
      return 14;

    case PdfPageFormat.a3:
      return 30;
    case roll80:
      return 10;

    default:
      return 20;
  }
}

double printableFindTextSize({
  PdfPageFormat? format,
}) {
  switch (format) {
    case PdfPageFormat.a4:
      return printerFontPrimaryA4;
    case PdfPageFormat.a5:
      return printerFontPrimaryA5;

    case PdfPageFormat.a3:
      return printerFontPrimaryA3;
    case roll80:
      return printerFontPrimaryRoll;

    default:
      return printerFontPrimaryA4;
  }
}

double printableFindRectangleSize({
  PdfPageFormat? format,
}) {
  switch (format) {
    case PdfPageFormat.a4:
      return printerRectangleA4;
    case PdfPageFormat.a5:
      return printerRectangleA5;

    case PdfPageFormat.a3:
      return printerRectangleA3;
    case roll80:
      return printerRectangleRoll;

    default:
      return printerRectangleA4;
  }
}

bool printableIsLabel({PdfPageFormat? format}) {
  return format == roll80;
}

EdgeInsetsGeometry printableFindPadding({
  PdfPageFormat? format,
}) {
  switch (format) {
    case PdfPageFormat.a4:
      return const EdgeInsets.symmetric(horizontal: 5, vertical: 8);
    case PdfPageFormat.a5:
      return const EdgeInsets.symmetric(horizontal: 5, vertical: 8);

    case PdfPageFormat.a3:
      return const EdgeInsets.symmetric(horizontal: 5, vertical: 8);
    case roll80:
      return const EdgeInsets.symmetric(horizontal: 1, vertical: 4);

    default:
      return const EdgeInsets.symmetric(horizontal: 5, vertical: 8);
  }
}

Widget printableGetLabelAndText(
    mt.BuildContext context, String label, String value,
    {Widget? isValueWidget, PdfPageFormat? format, double? customFontSize}) {
  double fontSize = customFontSize ?? printableFindTextSize(format: format);
  double labelSize = printableFindLabelSize(format: format);
  double size = printableFindRectangleSize(format: format);
  EdgeInsetsGeometry padding = printableFindPadding(format: format);
  FontWeight fontWeight =
      printableIsLabel(format: format) ? FontWeight.bold : FontWeight.normal;
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
                padding: padding,
                child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(label,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                            fontWeight: fontWeight, fontSize: labelSize)))),
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

Widget printableGetBorderContainer(Widget child, {double padding = 0}) {
  return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(border: Border.all()),
      child: child);
}

Widget printableWrapBorderContainerWithExpanded(Widget child,
    {double padding = 0, int flex = 1}) {
  return Expanded(
      flex: flex, child: printableGetBorderContainer(child, padding: padding));
}

Widget printableGetMainTitle<T extends PrintLocalSetting>(
        mt.BuildContext context, PrintableMaster printObj,
        {T? printCommandAbstract, PdfPageFormat? format}) =>
    Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 5),
        child: Text(
          printObj
              .getPrintableInvoiceTitle(context, printCommandAbstract)
              .toUpperCase(),
          style: TextStyle(
              fontSize: printableFindTextSize(format: format),
              color: PdfColor.fromHex(
                  printObj.getPrintablePrimaryColor(printCommandAbstract))),
        ));

Widget printableBuildBarcode(mt.BuildContext context, String barcode,
    {double size = 20, PdfPageFormat? format}) {
  return Column(children: [
    SizedBox(
        width: double.maxFinite,
        height: size,
        child: BarcodeWidget(
          textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: printableFindLabelSize(format: format)),
          height: size,
          width: double.maxFinite,
          barcode: Barcode.code128(),
          data: barcode,
        )),
  ]);
}

Widget printableBuildQrCode<T extends PrintLocalSetting>(
  mt.BuildContext context,
  PrintableMaster printObj, {
  T? printCommandAbstract,
  bool withPaddingTop = true,
  double size = 80,
  PdfPageFormat? format,
}) {
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
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: printableFindLabelSize(format: format)),
    ),
  ]);
}
