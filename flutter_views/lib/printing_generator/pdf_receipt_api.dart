import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_bill_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_invoice_interface.dart';
import 'package:flutter_view_controller/models/prints/print_commad_abstract.dart';
import 'package:flutter_view_controller/printing_generator/utils.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:flutter/material.dart' as material;
import 'package:printing/printing.dart';
import 'package:flutter/material.dart' as mt;
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:intl/intl.dart' as intl;

import '../interfaces/printable/printable_master.dart';

class PdfReceipt<T extends PrintableReceiptInterface> {
  material.BuildContext context;
  T printObj;
  PrintCommandAbstract? printCommand;
  PdfReceipt(this.context, this.printObj, {this.printCommand});

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

  Future<Widget> buildHeader() async => pw.Image(await networkImage(
      'https://saffoury.com/SaffouryPaper2/print/headers/headerA5IMG.php?color=${printObj.getPrintablePrimaryColor()}&darkColor=${printObj.getPrintableSecondaryColor()}'));

  Future<Uint8List> generate(PdfPageFormat? format) async {
    var myTheme = await getThemeData();
    final header = await buildHeader();

    final pdf = Document(
        title: "TEST", pageMode: PdfPageMode.fullscreen, theme: myTheme);
    pdf.addPage(MultiPage(
      footer: (_) =>
          Container(width: double.infinity, height: 15, color: PdfColors.green),
      pageFormat: format,
      // orientation: PageOrientation.landscape,
      margin: EdgeInsets.zero,

      // pageTheme: ,
      build: (context) => [
        Stack(alignment: Alignment.bottomCenter, fit: StackFit.loose,
            // alignment: ,
            children: [header, buildTitle()]),
        // header,
        // buildInvoiceMainInfoHeader(),
        Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: buildTable()),
              Expanded(flex: 1, child: buildQrCode())
            ])
        // buildInvoiceMainTable(),
      ],
    ));
    return pdf.save();
    // return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  List<String> getList(List<RecieptHeaderTitleAndDescriptionInfo> list) {
    List<String> stringList = [];
    list.forEach((element) {
      stringList.add(element.title);
      stringList.add(element.description);
    });
    return stringList;
  }

  Widget buildTable() {
    return Column(
        children: [buildInvoiceMainTable(), buildInvoiceBottomOfQr()]);
  }

  Widget buildInvoiceBottomOfQr() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 0),
        child: Table.fromTextArray(
          headers: ["", ""],
          data: [
            // ["iD", "23132"],
            ["paymant amount", "21231"],
            ["balance", "2421"],
            ["served by", "Qussai Al-Saffoury"]
          ],
          border: null,
          oddCellStyle: TextStyle(color: PdfColors.green),
          cellAlignment: Alignment.centerRight,
          cellAlignments: {0: Alignment.centerLeft, 1: Alignment.centerRight},

          // oddCellStyle: TextStyle(fontWeight: FontWeight.bold),
          cellDecoration: (index, data, rowNum) {
            mt.debugPrint("cellDecoration rownum $rowNum index= $index");
            return BoxDecoration(

                // borderRadius: BorderRadius.circular(1),
                // color: index % 2 != 0 ? PdfColors.grey200 : PdfColors.white,
                border: Border(
                    bottom: BorderSide(
              width: 10,
              //                    <--- top side
              color: PdfColors.white,
              // width: 1.0,
            )));
          },
          headerCellDecoration: const BoxDecoration(
              color: PdfColors.white,
              border: Border(
                  bottom: BorderSide(
                //                    <--- top side
                color: PdfColors.white,
                // width: 2.0,
              ))),
          //this is content table text color
          // cellFormat: ,
          // cellStyle:
          //     TextStyle(color: PdfColors.black, fontWeight: FontWeight.bold),
          // oddCellStyle: TextStyle(
          //   color: PdfColors.black,
          // ),
          headerStyle: TextStyle(
              color: PdfColors.green,
              fontWeight: FontWeight.bold,
              background: BoxDecoration(color: PdfColors.white)),
          headerDecoration: BoxDecoration(color: PdfColors.grey300),
          // cellHeight: 20,
          // cellAlignments: {0: Alignment.centerRight, 1: Alignment.centerLeft}
          // cellAlignments: Map.fromIterable(headers, key: (e) {
          //   int idx = headers.indexOf(e);
          //   return idx;
          // }, value: (e) {
          //   int idx = headers.indexOf(e);
          //   return idx == 0
          //       ? Alignment.centerLeft
          //       : (idx == headers.length - 1
          //           ? Alignment.centerRight
          //           : Alignment.center);
          // })
        ));
  }

  // Widget buildTable() {
  //   return Column(children: [buildIdAndDate(), buildInvoiceMainTable()]);
  // }

  Widget buildInvoiceMainTable() {
    // PrintableInvoiceInterfaceDetails head = details[0];
    final data = printObj
        .getPrintableRecieptHeaderTitleAndDescription(context, null)
        .entries
        .map((e) => getList(e.value))
        .toList();

    // return Table(children: [
    //   TableRow(children: [
    //     Text("iD"),
    //     Text("231qq", style: TextStyle(fontWeight: FontWeight.bold))
    //   ])
    // ]);

    // data.addAll(getTotalText(headers.length - 1));
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Table.fromTextArray(
            headers: ["", ""],
            data: data,
            // cellStyle: TextStyle(fontSize: 14),
            border: null,
            // oddCellStyle: TextStyle(fontSize: 14),
            cellAlignment: Alignment.centerLeft,

            // oddCellStyle: TextStyle(fontWeight: FontWeight.bold),
            cellDecoration: (index, data, rowNum) {
              mt.debugPrint("cellDecoration rownum $rowNum index= $index");
              return BoxDecoration(

                  // borderRadius: BorderRadius.circular(1),
                  color: index % 2 != 0 ? PdfColors.grey200 : PdfColors.white,
                  border: Border(
                      bottom: BorderSide(
                    width: 10,
                    //                    <--- top side
                    color: PdfColors.white,
                    // width: 1.0,
                  )));
            },
            headerCellDecoration: const BoxDecoration(
                color: PdfColors.white,
                border: Border(
                    bottom: BorderSide(
                  //                    <--- top side
                  color: PdfColors.white,
                  // width: 2.0,
                ))),
            //this is content table text color
            // cellFormat: ,
            // cellStyle:
            //     TextStyle(color: PdfColors.black, fontWeight: FontWeight.bold),
            // oddCellStyle: TextStyle(
            //   color: PdfColors.black,
            // ),

            headerStyle: TextStyle(
                color: PdfColors.green,
                fontWeight: FontWeight.bold,
                background: BoxDecoration(color: PdfColors.white)),
            headerDecoration: BoxDecoration(color: PdfColors.grey300),
            cellHeight: 30,
            cellAlignments: {0: Alignment.centerRight, 1: Alignment.centerLeft}
            // cellAlignments: Map.fromIterable(headers, key: (e) {
            //   int idx = headers.indexOf(e);
            //   return idx;
            // }, value: (e) {
            //   int idx = headers.indexOf(e);
            //   return idx == 0
            //       ? Alignment.centerLeft
            //       : (idx == headers.length - 1
            //           ? Alignment.centerRight
            //           : Alignment.center);
            // })
            ));
  }

  Widget buildTitle() => Padding(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
      child: Text(
        printObj.getPrintableInvoiceTitle(context, printCommand),
        style: TextStyle(
            fontSize: 20,
            color: PdfColor.fromHex(printObj.getPrintablePrimaryColor())),
      ));
  Widget buildTitleOnInvoice(String title) {
    return Text(title,
        style: TextStyle(fontWeight: FontWeight.bold, color: PdfColors.green));
  }

  Widget buildQrCode() {
    return Column(
        // verticalDirection: VerticalDirection.down,
        // crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 80),
          // Container(color: PdfColors.blue, width: 100, height: 100),
          SizedBox(
              width: 80,
              height: 80,
              child: BarcodeWidget(
                barcode: Barcode.qrCode(),
                data: printObj.getPrintableQrCode(),
              )),
          SizedBox(height: .4 * (PdfPageFormat.cm)),
          Text(printObj.getPrintableQrCodeID(), style: TextStyle(fontSize: 9)),
        ]);
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
