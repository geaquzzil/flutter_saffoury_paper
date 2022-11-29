import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:pdf/pdf.dart';
import 'package:flutter/material.dart' as material;
import 'package:pdf/widgets.dart';
import 'package:intl/intl.dart' as intl;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/prints/print_local_setting.dart';

class PrintMasterPDF<T extends PrintableMaster, E extends PrintLocalSetting> {
  T printObj;
  E? setting;
  late Context contextPDF;
  material.BuildContext context;

  late ThemeData themeData;
  late Widget header;

  PrintMasterPDF({required this.context, required this.printObj, this.setting});

  Future<Widget> buildHeader() async {
    return Image(await networkImage(
        'https://saffoury.com/SaffouryPaper2/print/headers/headerA4IMG.php?color=${getPrimaryColor()}&darkColor=${getSecondaryColor()}'));
  }

  CrossAxisAlignment getCrossAxis() {
    return isArabic() ? CrossAxisAlignment.end : CrossAxisAlignment.start;
  }

  MainAxisAlignment getMainAxis() {
    return isArabic() ? MainAxisAlignment.end : MainAxisAlignment.start;
  }

  Future<void> initHeader() async {
    themeData = await getThemeData();
    header = await buildHeader();
  }

  Future<ThemeData> getThemeData() async {
    var pathToFile = await rootBundle.load("assets/fonts/materialIcons.ttf");
    final ttf = Font.ttf(pathToFile);
    return ThemeData.withFont(
        icons: ttf,
        base: await PdfGoogleFonts.tajawalRegular(),
        bold: await PdfGoogleFonts.tajawalBold(),
        italic: await PdfGoogleFonts.tajawalMedium(),
        boldItalic: await PdfGoogleFonts.tajawalBold());
  }

  Future<Document> getDocument() async {
    await initHeader();
    final pdf = Document(
        title: "TEST", pageMode: PdfPageMode.fullscreen, theme: themeData);

    return pdf;
  }

  Widget buildTitle() {
    String title =
        printObj.getPrintableInvoiceTitle(context, setting).toUpperCase();
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 5),
        child: Text(
          title,
          textDirection: getTextDirection(title),
          style: TextStyle(
              fontSize: 20,
              color:
                  PdfColor.fromHex(printObj.getPrintablePrimaryColor(setting))),
        ));
  }

  PdfColor getSecondaryColor() {
    return PdfColor.fromHex(printObj.getPrintableSecondaryColor(setting));
  }

  PdfColor getPrimaryColor() {
    return PdfColor.fromHex(printObj.getPrintablePrimaryColor(setting));
  }

  TextDirection getTextDirection(String? value) {
    return isRTL(value) ? TextDirection.rtl : TextDirection.ltr;
  }

  List<U> checkListToReverse<U>(List<U> list) {
    if (!isArabic()) return list;
    return list.reversed.toList();
  }

  Directionality getDirections({required Widget child, String? byValue}) {
    return Directionality(
        textDirection: byValue == null
            ? isArabic()
                ? TextDirection.rtl
                : TextDirection.ltr
            : getTextDirection(byValue),
        child: child);
  }

  bool isRTL(String? text) {
    if (text == null) return false;
    return intl.Bidi.detectRtlDirectionality(text);
  }

  bool hasSortBy() {
    return setting?.getPrintableSortByName() != null;
  }

  bool isArabic() {
    return true;
  }

  double getQrCodeSize(PdfPageFormat? format) {
    if (format == PdfPageFormat.a4) {
      return 80;
    } else if (format == PdfPageFormat.a3) {
      return 80;
    } else if (format == PdfPageFormat.a5) {
      return 10;
    } else {
      return 10;
    }
  }

  int compareDynamic(bool ascending, dynamic value1, dynamic value2) {
    material.debugPrint(
        "checkToSort compareDynamic value1 => ${value1.toString()} , value2 => $value2");
    if (value1 == null) {
      return 0;
    }
    if (value1.runtimeType == int) {
      return compareInt(ascending, value1, value2);
    } else if (value1.runtimeType == double) {
      return compareDouble(ascending, value1, value2);
    } else if (value1.runtimeType == String) {
      return compareString(ascending, value1, value2);
    } else {
      return 0;
    }
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);

  int compareInt(bool ascending, int value1, int value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);

  int compareDouble(bool ascending, double value1, double value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);
}
