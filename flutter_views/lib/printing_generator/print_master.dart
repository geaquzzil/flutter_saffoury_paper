import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:pdf/pdf.dart';
import 'package:flutter/material.dart' as material;
import 'package:pdf/widgets.dart';
import 'package:intl/intl.dart' as intl;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/prints/print_local_setting.dart';

class PrintMasterPDF<T extends PrintableMasterEmpty,
    E extends PrintLocalSetting> extends PrintMasterPDFUtils<E> {
  T printObj;

  PrintMasterPDF(
      {required material.BuildContext context,
      required this.printObj,
      E? setting})
      : super(context: context, setting: setting);

  @override
  Future<Widget> buildHeader() async {
    return Image(await networkImage(
        'https://saffoury.com/SaffouryPaper2/print/headers/headerA4IMG.php?color=${getPrimaryColor()}&darkColor=${getSecondaryColor()}'));
  }

  Widget buildTitle() {
    assert(printObj is PrintableMaster);
    String title = (printObj as PrintableMaster)
        .getPrintableInvoiceTitle(context, setting)
        .toUpperCase();
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 0),
        child: Text(title,
            textDirection: getTextDirection(title),
            style: Theme.of(contextPDF)
                .header1
                .copyWith(color: getPrimaryColor())));
  }

  Widget buildTitleOnInvoice(String title) {
    return Text(title,
        textDirection: getTextDirection(title),
        style: Theme.of(contextPDF)
            .tableHeader
            .copyWith(color: getPrimaryColor()));
  }

  Widget buildDescriptionOnInvoice(String title) {
    return Text(title,
        textDirection: getTextDirection(title),
        style:
            Theme.of(contextPDF).tableCell.copyWith(color: PdfColors.grey700));
  }

  PdfColor getSecondaryColor() {
    assert(printObj is PrintableMaster);
    return PdfColor.fromHex(
        (printObj as PrintableMaster).getPrintableSecondaryColor(setting));
  }

  PdfColor getPrimaryColor() {
    assert(printObj is PrintableMaster);
    return PdfColor.fromHex(
        (printObj as PrintableMaster).getPrintablePrimaryColor(setting));
  }
}

class PrintMasterPDFUtils<T extends PrintLocalSetting> {
  T? setting;
  PdfPageFormat? format;
  late ThemeData themeData;
  late Widget header;
  late Context contextPDF;
  material.BuildContext context;

  PrintMasterPDFUtils({required this.context, this.setting});

  Future<void> initHeader() async {
    themeData = await getThemeData();
    header = await buildHeader();
  }

  Future<Widget> buildHeader() async {
    return Image(await networkImage(""));
  }

  Future<Document> getDocument() async {
    await initHeader();
    final pdf = Document(
        title: "TEST", pageMode: PdfPageMode.fullscreen, theme: themeData);

    return pdf;
  }

  bool isRTL(String? text) {
    if (text == null) return false;
    return intl.Bidi.detectRtlDirectionality(text);
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

  bool hasSortBy() {
    return setting?.getPrintableSortByName() != null;
  }

  CrossAxisAlignment getCrossAxis() {
    return isArabic() ? CrossAxisAlignment.end : CrossAxisAlignment.start;
  }

  MainAxisAlignment getMainAxis() {
    return isArabic() ? MainAxisAlignment.end : MainAxisAlignment.start;
  }

  bool isArabic() {
    return false;
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

  Widget buildSpaceOnInvoice({double cm = 1}) {
    return SizedBox(height: cm * (PdfPageFormat.cm));
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

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);

  int compareInt(bool ascending, int value1, int value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);

  int compareDouble(bool ascending, double value1, double value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);
}
