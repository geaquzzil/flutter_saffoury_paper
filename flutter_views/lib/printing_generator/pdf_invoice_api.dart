import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';
import 'package:flutter_view_controller/interfaces/printable/printable_invoice_interface.dart';
import 'package:flutter_view_controller/printing_generator/ext.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:flutter/material.dart' as material;
import 'package:printing/printing.dart';
import 'package:flutter/material.dart' as mt;
import 'package:intl/intl.dart' as intl;

import '../models/prints/print_local_setting.dart';

class PdfInvoiceApi<T extends PrintableInvoiceInterface,
    E extends PrintLocalSetting> {
  material.BuildContext context;
  T printObj;
  E? printCommand;
  PdfInvoiceApi(this.context, this.printObj, {this.printCommand});
  @deprecated
  Future<Uint8List> generateFromImage(Uint8List? list) {
    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        // buildHeader(),
        if (list != null) pw.Image(MemoryImage(list)),

        buildInvoiceMainInfoHeader(),
        // buildSubHeaderInfo(invoice),
        SizedBox(height: 3 * PdfPageFormat.cm),
        buildTitle(this.context, printObj, printCommandAbstract: printCommand),
        // buildInvoiceTable(),
        // Divider(),
        buildMainTotal(),
      ],
      // footer: (context) => buildFooter(invoice),
    ));
    return pdf.save();
    // return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  Future<pw.ThemeData> getThemeData() async {
    var pathToFile = await rootBundle.load("assets/fonts/materialIcons.ttf");
    final ttf = pw.Font.ttf(pathToFile);
    return ThemeData.withFont(
        icons: ttf,
        base: await PdfGoogleFonts.tajawalRegular(),
        bold: await PdfGoogleFonts.tajawalBold(),
        italic: await PdfGoogleFonts.tajawalMedium(),
        boldItalic: await PdfGoogleFonts.tajawalBold());
  }

  Future<Widget> buildHeader() async {
    mt.debugPrint(
        'https://saffoury.com/SaffouryPaper2/print/headers/headerA4IMG.php?color=${printObj.getPrintablePrimaryColor(printCommand)}&darkColor=${printObj.getPrintableSecondaryColor(printCommand)}');
    return pw.Image(await networkImage(
        'https://saffoury.com/SaffouryPaper2/print/headers/headerA4IMG.php?color=${printObj.getPrintablePrimaryColor(printCommand)}&darkColor=${printObj.getPrintableSecondaryColor(printCommand)}'));
  }

  Future<Uint8List> generate(PdfPageFormat? format) async {
    var myTheme = await getThemeData();
    final header = await buildHeader();

    final pdf = Document(
        title: "TEST", pageMode: PdfPageMode.fullscreen, theme: myTheme);
    pdf.addPage(MultiPage(
      pageFormat: format,

      margin: EdgeInsets.zero,

      // pageTheme: ,
      build: (context) => [
        Stack(alignment: Alignment.bottomRight, fit: StackFit.loose,
            // alignment: ,
            children: [
              header,
              buildTitle(this.context, printObj,
                  printCommandAbstract: printCommand)
            ]),
        // header,
        buildInvoiceMainInfoHeader(),

        SizedBox(height: .5 * (PdfPageFormat.cm)),
        buildInvoiceMainTable(),
        buildMainTotal(),
      ],
      // footer: (context) => buildFooter(),
    ));
    return pdf.save();
    // return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  Widget buildInvoiceMainInfoHeader() {
    List<List<InvoiceHeaderTitleAndDescriptionInfo>> inf =
        printObj.getPrintableInvoiceInfo(context, printCommand);
    return Container(
        width: double.infinity,
        color: PdfColors.grey200,
        padding: const EdgeInsets.all(20),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: inf.map((e) {
              // inf.firs==
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: e
                      .map((item) => buildInvoiceInfoItem(
                          item, inf.length, inf.indexOf(e)))
                      .toList());
            }).toList()));
  }

  MainAxisAlignment getMainAxisSizeForHeaderInfo(int length, int idx) {
    if (idx == length - 1) {
      return MainAxisAlignment.end;
    } else if (idx == 0) {
      return MainAxisAlignment.start;
    } else {
      return MainAxisAlignment.center;
    }
  }

  double getSizeForHeaderInfo(int length, int idx) {
    if (idx == length - 1) {
      return 200;
    } else if (idx == 0) {
      return 200;
    } else {
      return 100;
    }
  }

  CrossAxisAlignment getCrossAxisAlignmentForHeaderInfo(int length, int idx) {
    if (idx == length - 1) {
      return CrossAxisAlignment.end;
    } else if (idx == 0) {
      return CrossAxisAlignment.start;
    } else {
      return CrossAxisAlignment.center;
    }
  }

  pw.Padding buildInvoiceInfoItem(
      InvoiceHeaderTitleAndDescriptionInfo item, int length, int idx) {
    return Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
            width: getSizeForHeaderInfo(length, idx),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                // crossAxisAlignment: ,
                crossAxisAlignment:
                    getCrossAxisAlignmentForHeaderInfo(length, idx),
                mainAxisAlignment: getMainAxisSizeForHeaderInfo(length, idx),
                children: [
                  buildTextWithIcon(item),
                  Padding(
                      padding: item.getCodeIcon() == null
                          ? const EdgeInsets.symmetric()
                          : const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(item.description,
                          textDirection: getTextDirection(item.description),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: item.getColor()))),
                ])));
  }

  PdfColor getSecondaryColor() {
    return PdfColor.fromHex(printObj.getPrintableSecondaryColor(printCommand));
  }

  PdfColor getPrimaryColor() {
    return PdfColor.fromHex(printObj.getPrintablePrimaryColor(printCommand));
  }

  pw.Row buildTextWithIcon(InvoiceHeaderTitleAndDescriptionInfo item) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (item.getCodeIcon() != null)
          Icon(
            color: PdfColors.grey,
            size: 15,
            IconData(item.getCodeIcon()!, matchTextDirection: true),
          ),
        if (item.getCodeIcon() != null) SizedBox(width: 0.2 * PdfPageFormat.cm),
        Text(item.title),
      ],
    );
  }

  Widget buildInvoiceMainTable() {
    List<PrintableInvoiceInterfaceDetails> details =
        printObj.getPrintableInvoiceDetailsList();

    PrintableInvoiceInterfaceDetails head = details[0];
    final headers = head
        .getPrintableInvoiceTableHeaderAndContent(context, printCommand)
        .keys
        .map((e) => e.toUpperCase())
        .toList();

    final data = details
        .map((e) => e
            .getPrintableInvoiceTableHeaderAndContent(context, printCommand)
            .values
            .toList())
        .toList();

    // data.addAll(getTotalText(headers.length - 1));
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Table.fromTextArray(
            headers: headers,
            data: data,
            border: null,
            cellDecoration: (index, data, rowNum) {
              mt.debugPrint("cellDecoration rownum $rowNum index= $index");
              return const BoxDecoration(
                  color: PdfColors.white,
                  border: Border(
                      bottom: BorderSide(
                    //                    <--- top side
                    color: PdfColors.grey,
                    // width: 1.0,
                  )));
            },
            headerCellDecoration: BoxDecoration(
                color: PdfColors.white,
                border: Border(
                    bottom: BorderSide(
                        //                    <--- top side
                        color: getSecondaryColor()
                        // width: 2.0,
                        ))),
            //this is content table text color
            cellStyle: const TextStyle(color: PdfColors.black),
            headerStyle: TextStyle(
                color: getSecondaryColor(),
                fontWeight: FontWeight.bold,
                background: const BoxDecoration(color: PdfColors.white)),
            headerDecoration: const BoxDecoration(color: PdfColors.grey300),
            cellHeight: 30,
            cellAlignments: Map.fromIterable(headers, key: (e) {
              int idx = headers.indexOf(e);
              return idx;
            }, value: (e) {
              int idx = headers.indexOf(e);
              return idx == 0
                  ? Alignment.centerLeft
                  : (idx == headers.length - 1
                      ? Alignment.centerRight
                      : Alignment.center);
            })));
  }

  Widget buildTitleOnInvoice(String title) {
    return Text(title,
        style:
            TextStyle(fontWeight: FontWeight.bold, color: getSecondaryColor()));
  }

  Widget buildInvoiceBottomInfoWithQrCode() {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: printObj
                  .getPrintableInvoiceAccountInfoInBottom(context, printCommand)
                  .map((e) => buildBottomAccountInfo(
                      title: e.title, value: e.description))
                  .toList()),
          // BarcodeWidget(
          //   height: 50,
          //   width: 50,
          //   barcode: Barcode.qrCode(),
          //   data: printObj.getInvoiceQrCode(),
          // ),
          if (printCommand?.hideQrCode == false)
            Column(children: [
              BarcodeWidget(
                height: 50,
                width: 50,
                barcode: Barcode.qrCode(),
                data: printObj.getPrintableQrCode(),
              ),
              SizedBox(height: .1 * (PdfPageFormat.cm)),
              Text(printObj.getPrintableQrCodeID(),
                  style: const TextStyle(fontSize: 9))
            ])
        ]);
  }

  Widget buildInvoiceBottom() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 1 * (PdfPageFormat.cm)),
              buildTitleOnInvoice("ACCOUNT INFO"),
              buildInvoiceBottomInfoWithQrCode(),
              SizedBox(height: 1 * (PdfPageFormat.cm / 2)),
              buildTitleOnInvoice("Terms and conditions"),
              Text(
                  "1- Please quote invoice number when remitting funds, otherwise no item will be replaced or refunded after 2 days of purchase\n\n2- Please pay before the invoice expiry date mentioned above, @ 14% late interest will be charged on late payments.",
                  style:
                      const TextStyle(fontSize: 9, color: PdfColors.grey700)),
              SizedBox(height: 1 * (PdfPageFormat.cm / 2)),
              buildTitleOnInvoice("Additional notes"),
              Text(
                  "Thank you for your business!\nFor any enquiries, email us on paper@saffoury.com or call us on\n+963 989944381",
                  style: const TextStyle(fontSize: 9, color: PdfColors.grey700))
            ]));
  }

  Widget buildFooter() {
    return Text(
        "Thank you for your business!\nFor any enquiries, email us on paper@saffoury.com or call us on\n+963 989944381",
        style: const TextStyle(fontSize: 8, color: PdfColors.grey700));
  }

  Widget buildMainTotal() {
    List<InvoiceTotalTitleAndDescriptionInfo> totals =
        printObj.getPrintableInvoiceTotal(context, printCommand);
    List<InvoiceTotalTitleAndDescriptionInfo> totalDes =
        printObj.getPrintableInvoiceTotalDescripton(context, printCommand);

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: buildInvoiceBottom()),
              Expanded(
                  flex: 1,
                  child: Container(
                    decoration: const BoxDecoration(color: PdfColors.grey),
                    // color: PdfColors.grey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...totals
                            .map(
                              (e) => buildTotalText(
                                  title: e.title,
                                  value: e.description,
                                  color: e.getColor(),
                                  withDivider:
                                      totals.indexOf(e) != totals.length - 1),
                            )
                            .toList(),
                        ...totalDes
                            .map((e) => buildTotalText(
                                size: e.size,
                                title: e.title,
                                value: e.description,
                                color: e.getColor(),
                                withDivider:
                                    totalDes.indexOf(e) == totalDes.length - 1))
                            .toList()
                      ],
                    ),
                  )),
            ],
          ),
        ));
  }

//   static buildSimpleText({
//     required String title,
//     required String value,
//   }) {
//     final style = TextStyle(fontWeight: FontWeight.bold);

//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: pw.CrossAxisAlignment.end,
//       children: [
//         Text(title, style: style),
//         SizedBox(width: 2 * PdfPageFormat.mm),
//         Text(value),
//       ],
//     );
//   }
  Widget buildBottomAccountInfo(
      {required String title,
      String? value,
      PdfColor? color,
      double width = double.infinity,
      bool withDivider = true}) {
    return Container(
      // width: width,
      // height: 25,
      // decoration: getDividerBetweenContent(withDivider: withDivider),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: color, fontSize: 8)),
          // RichText(text: text)
          if (value != null)
            Text(value,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: color, fontSize: 8),
                textDirection: getTextDirection(value)),
          SizedBox(height: .3 * (PdfPageFormat.cm))
        ],
      ),
    );
  }

  buildTotalText(
      {required String title,
      String? value,
      PdfColor? color,
      double width = double.infinity,
      double? size,
      bool withDivider = true}) {
    return Container(
      width: width,
      height: 25,
      decoration: getDividerBetweenContent(withDivider: withDivider),
      child: Row(
        children: [
          Expanded(
              child: Text(
            title,
            style: TextStyle(color: color, fontSize: size),
            textDirection: getTextDirection(value),
          )),
          // RichText(text: text)
          if (value != null)
            Text(
              value,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: color, fontSize: size),
              textDirection: getTextDirection(value),
            ),
        ],
      ),
    );
  }

  TextDirection getTextDirection(String? value) {
    return isRTL(value) ? TextDirection.rtl : TextDirection.ltr;
  }

  bool isRTL(String? text) {
    if (text == null) return false;
    return intl.Bidi.detectRtlDirectionality(text);
  }

  static pw.BoxDecoration getDividerBetweenContent({bool withDivider = true}) {
    return BoxDecoration(
        color: PdfColors.white,
        border: withDivider
            ? const Border(
                bottom: BorderSide(
                color: PdfColors.grey,
                width: 1.0,
              ))
            : null);
  }
}
