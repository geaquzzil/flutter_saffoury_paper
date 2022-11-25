import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';
import 'package:flutter_view_controller/interfaces/printable/printable_bill_interface.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:flutter/material.dart' as material;
import 'package:printing/printing.dart';
import 'package:flutter/material.dart' as mt;
import 'package:intl/intl.dart' as intl;

import 'ext.dart';

class PdfReceipt<T extends PrintableReceiptInterface,
    E extends PrintLocalSetting> {
  material.BuildContext context;
  late Context contextPDF;
  T printObj;
  E? printCommand;
  late final header;
  late final myTheme;
  PdfReceipt(this.context, this.printObj, {this.printCommand});
  Future<void> initHeader() async {
    header = await buildHeader();
    myTheme = await getThemeData();
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

  Future<Widget> buildHeader() async => pw.Image(await networkImage(
      'https://saffoury.com/SaffouryPaper2/print/headers/headerA5IMG.php?color=${printObj.getPrintablePrimaryColor(printCommand)}&darkColor=${printObj.getPrintableSecondaryColor(printCommand)}'));

  Future<Uint8List> generate(PdfPageFormat? format) async {
    myTheme = await getThemeData();
    header = await buildHeader();

    final pdf = Document(
        title: "TEST", pageMode: PdfPageMode.fullscreen, theme: myTheme);
    pdf.addPage(getMultiPage(format));
    return pdf.save();
    // return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  Page getPage(PdfPageFormat? format) {
    return Page(
        pageFormat: format,
        margin: EdgeInsets.zero,
        build: (context) {
          this.contextPDF = context;
          return Column(
            children: [
              Stack(alignment: Alignment.bottomCenter, fit: StackFit.loose,
                  // alignment: ,
                  children: [header, buildTitle()]),
              // header,
              // buildInvoiceMainInfoHeader(),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(flex: 4, child: buildTable()),
                    Expanded(
                        flex: 1,
                        child: buildQrCode<E>(this.context, printObj,
                            printCommandAbstract: printCommand))
                  ])
              // buildInvoiceMainTable(),
            ],
          );
        });
  }

  pw.MultiPage getMultiPage(PdfPageFormat? format) {
    return MultiPage(
      footer: (_) =>
          Container(width: double.infinity, height: 15, color: PdfColors.green),
      pageFormat: format,
      // orientation: PageOrientation.landscape,
      margin: EdgeInsets.zero,

      // pageTheme: ,
      build: (context) {
        this.contextPDF = context;
        return [
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
                Expanded(
                    flex: 1,
                    child: buildQrCode<E>(this.context, printObj,
                        printCommandAbstract: printCommand))
              ])
          // buildInvoiceMainTable(),
        ];
      },
    );
  }

  List<String> getList(List<RecieptHeaderTitleAndDescriptionInfo> list) {
    List<String> stringList = [];
    for (var element in list) {
      stringList.add(element.title);
      stringList.add(element.description);
    }
    return stringList;
  }

  Widget buildTable() {
    return buildInvoiceMainTable2();
    return Column(
        children: [buildInvoiceMainTable2(), buildInvoiceBottomOfQr()]);
  }

  Widget buildInvoiceBottomOfQr() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Table.fromTextArray(
          headers: ["", ""],
          data: [
            // ["iD", "23132"],
            ["paymant amount", "21231"],
            ["balance", "2421"],
            ["served by", "Qussai Al-Saffoury"]
          ],
          border: null,
          oddCellStyle: const TextStyle(color: PdfColors.green),
          cellAlignment: Alignment.centerRight,
          cellAlignments: {0: Alignment.centerLeft, 1: Alignment.centerRight},

          // oddCellStyle: TextStyle(fontWeight: FontWeight.bold),
          cellDecoration: (index, data, rowNum) {
            mt.debugPrint("cellDecoration rownum $rowNum index= $index");
            return const BoxDecoration(

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
              background: const BoxDecoration(color: PdfColors.white)),
          headerDecoration: const BoxDecoration(color: PdfColors.grey300),
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
  Widget buildInvoiceMainTable2() {
    var table = printObj
        .getPrintableRecieptHeaderTitleAndDescription(context, printCommand)
        .values
        .map((e) => Row(children: e.map((e) => buildText(e)).toList()))
        .toList();

    var footers = printObj
        .getPrintableRecieptFooterTitleAndDescription(context, printCommand)
        .values
        .map((e) => Row(children: e.map((e) => buildFooterText(e)).toList()))
        .toList();
    var customWidget =
        printObj.getPrintableRecieptCustomWidget(context, printCommand);
    if (footers.isNotEmpty) {
      table.addAll(footers);
    }

    //  var custom=

    return Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              ...table,
              if (customWidget != null)
                SizedBox(height: 1 * (PdfPageFormat.cm / 2)),
              if (customWidget != null) customWidget
            ]));
  }

  TextDirection getTextDirection(String? value) {
    return isRTL(value) ? TextDirection.rtl : TextDirection.ltr;
  }

  bool isRTL(String? text) {
    if (text == null) return false;
    return intl.Bidi.detectRtlDirectionality(text);
  }

  Widget buildText(
      RecieptHeaderTitleAndDescriptionInfo
          recieptHeaderTitleAndDescriptionInfo) {
    return Expanded(
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
          Text(recieptHeaderTitleAndDescriptionInfo.title),
          SizedBox(width: 1 * (PdfPageFormat.cm / 2)),
          Expanded(
              child: Container(
                  constraints:
                      const BoxConstraints(minHeight: 40, maxHeight: 80),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  // height: 40,
                  decoration: const BoxDecoration(

                      // borderRadius: BorderRadius.circular(1),
                      color: PdfColors.grey200,
                      border: Border(
                          bottom: BorderSide(
                        width: 10,
                        //                    <--- top side
                        color: PdfColors.white,
                        // width: 1.0,
                      ))),
                  child: Text(
                    overflow: TextOverflow.span,
                    textDirection: getTextDirection(
                        recieptHeaderTitleAndDescriptionInfo.description),
                    style: Theme.of(contextPDF).tableHeader.copyWith(
                        fontSize: 14,
                        color: recieptHeaderTitleAndDescriptionInfo.hexColor ==
                                null
                            ? null
                            : PdfColor.fromHex(
                                recieptHeaderTitleAndDescriptionInfo
                                    .hexColor!)),
                    textAlign: TextAlign.left,
                    recieptHeaderTitleAndDescriptionInfo.description,
                    // style: Theme.of(context).tableCell
                  ))),
          SizedBox(width: 1 * (PdfPageFormat.cm / 3)),
        ]));
  }

  Widget buildFooterText(
      RecieptHeaderTitleAndDescriptionInfo
          recieptHeaderTitleAndDescriptionInfo) {
    return Expanded(
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
          Text(recieptHeaderTitleAndDescriptionInfo.title),
          SizedBox(width: 1 * (PdfPageFormat.cm / 2)),
          Expanded(
              child: Container(
                  constraints:
                      const BoxConstraints(minHeight: 40, maxHeight: 80),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  // height: 40,
                  decoration: const BoxDecoration(

                      // borderRadius: BorderRadius.circular(1),
                      color: PdfColors.grey200,
                      border: Border(
                          bottom: BorderSide(
                        width: 10,
                        //                    <--- top side
                        color: PdfColors.white,
                        // width: 1.0,
                      ))),
                  child: Text(
                    overflow: TextOverflow.span,

                    style: Theme.of(contextPDF).tableHeader.copyWith(
                        fontSize: 14,
                        color: recieptHeaderTitleAndDescriptionInfo.hexColor ==
                                null
                            ? null
                            : PdfColor.fromHex(
                                recieptHeaderTitleAndDescriptionInfo
                                    .hexColor!)),
                    textAlign: TextAlign.left,
                    recieptHeaderTitleAndDescriptionInfo.description,
                    // style: Theme.of(context).tableCell
                  ))),
          SizedBox(width: 1 * (PdfPageFormat.cm / 3)),
        ]));
  }

  Widget buildInvoiceMainTable() {
    // PrintableInvoiceInterfaceDetails head = details[0];
    final data = printObj
        .getPrintableRecieptHeaderTitleAndDescription(context, null)
        .entries
        .map((e) => getList(e.value))
        .toList();

    final headerGenerater = List.generate(data[0].length, (index) => "");

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
            headers: headerGenerater,
            data: data,
            // cellStyle: TextStyle(fontSize: 14),
            border: null,
            // oddCellStyle: TextStyle(fontSize: 14),
            cellAlignment: Alignment.centerLeft,
            // oddCellStyle: TextStyle(fontWeight: FontWeight.bold),

            // cellStyle: TextStyle(fontWeight: FontWeight.bold),
            cellDecoration: (index, data, rowNum) {
              mt.debugPrint("cellDecoration rownum $rowNum index= $index");
              return BoxDecoration(

                  // borderRadius: BorderRadius.circular(1),
                  color: index % 2 != 0 ? PdfColors.grey200 : PdfColors.white,
                  border: const Border(
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
                fontWeight: FontWeight.bold,
                background: const BoxDecoration(color: PdfColors.white)),
            headerDecoration: const BoxDecoration(color: PdfColors.grey300),
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

  Widget buildTitle() => Text(
        printObj.getPrintableInvoiceTitle(context, printCommand),
        style: TextStyle(
            fontSize: 20,
            color: PdfColor.fromHex(
                printObj.getPrintablePrimaryColor(printCommand))),
      );
  Widget buildTitleOnInvoice(String title) {
    return Text(title,
        style: TextStyle(fontWeight: FontWeight.bold, color: PdfColors.green));
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
