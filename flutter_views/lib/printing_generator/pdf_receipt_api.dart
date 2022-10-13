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
      pageFormat: format,
      orientation: PageOrientation.landscape,
      margin: EdgeInsets.zero,

      // pageTheme: ,
      build: (context) => [
        Stack(alignment: Alignment.bottomCenter, fit: StackFit.loose,
            // alignment: ,
            children: [header, buildTitle()]),
        // header,
        buildInvoiceMainInfoHeader(),
        buildInvoiceMainTable(),
      ],
    ));
    return pdf.save();
    // return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  Widget buildInvoiceMainInfoHeader() {
    Map<int, List<RecieptHeaderTitleAndDescriptionInfo>> inf = printObj
        .getPrintableRecieptHeaderTitleAndDescription(context, printCommand);

    return Container(
        child: Column(
            // mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          Row(children: [
            Expanded(
                flex: 2,
                child: Container(
                    color: PdfColors.grey,
                    child: Column(children: [
                      ...inf.entries
                          .map((e) => _buildListItem(e.value))
                          .toList()
                    ]))),
            Expanded(
                flex: 1,
                child: Container(color: PdfColors.green, child: buildQrCode()))
          ]),
          // Text("TEST"),
          // ...inf.entries.map((e) => _buildListItem(e.value)).toList()
        ]));
    return Expanded(
        child: Container(
            // width: double.infinity,
            color: PdfColors.grey,
            // padding: const EdgeInsets.all(20),
            child: SizedBox(
                width: 20,
                height: 20,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("")
                      // Column(children: [
                      //   Row(children: [Text("12113"), Text("213123")]),
                      //   ...inf.entries.map((e) => _buildListItem(e.value)).toList(),
                      // ]),

                      // Column(children: [Text("TEST")])
                    ]))
            // child:
            // Column(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: inf.entries.map((e) {
            //     int idx = e.key;
            //     if (idx == 0) {
            //       return Column(
            //           children: inf[idx]!.map((e) => _buildItem(e)).toList());
            //     } else {
            //       return Expanded(
            //           child: Column(children: [
            //         Row(children: [
            //           // Expanded(flex: 2, child: _buildListItem(e.value)),
            //           // Expanded(flex: 1, child: buildQrCode())
            //         ])
            //       ]));
            //       // Column(children: inf[idx].map((e) => _buildItem(item)).toList());
            //     }
            //   }).toList(),
            // ))
            ));
  }

  Widget _buildListItem(List<RecieptHeaderTitleAndDescriptionInfo> items) {
    return
        // Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     mainAxisAlignment: MainAxisAlignment.start,
        //     children: [

        Container(
            width: double.infinity,
            height: 30,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: items.map((e) => _buildItem(e)).toList(),
            ));
    // ]
    // );
  }

  Widget _buildItem(RecieptHeaderTitleAndDescriptionInfo item) {
    return Row(
      // mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(item.title, style: TextStyle(fontSize: 14)),
        // SizedBox(
        //     height: 29,
        //     width: 29,
        //     child:
        Container(
          width: 100,
          height: 20,
          color: PdfColors.grey200,
          child: Text(item.description,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ),
        // SizedBox(width: 3 * PdfPageFormat.cm)
        // )
      ],
    );
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
        padding: EdgeInsets.all(5),
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
                          ? EdgeInsets.symmetric()
                          : EdgeInsets.symmetric(horizontal: 15),
                      child: Text(item.description,
                          textDirection: getTextDirection(item.description),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: item.getColor()))),
                ])));
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
    // PrintableInvoiceInterfaceDetails head = details[0];
    final data = printObj
        .getPrintableRecieptHeaderTitleAndDescription(context, null)
        .entries
        .map((e) => e.value.map((e) => e.title).toList())
        .toList();

    // data.addAll(getTotalText(headers.length - 1));
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Table.fromTextArray(
          data: data,
          border: null,
          cellDecoration: (index, data, rowNum) {
            mt.debugPrint("cellDecoration rownum $rowNum index= $index");
            return BoxDecoration(
                color: PdfColors.white,
                border: Border(
                    bottom: BorderSide(
                  //                    <--- top side
                  color: PdfColors.grey,
                  // width: 1.0,
                )));
          },
          headerCellDecoration: const BoxDecoration(
              color: PdfColors.white,
              border: Border(
                  bottom: BorderSide(
                //                    <--- top side
                color: PdfColors.green,
                // width: 2.0,
              ))),
          //this is content table text color
          cellStyle: TextStyle(color: PdfColors.black),
          headerStyle: TextStyle(
              color: PdfColors.green,
              fontWeight: FontWeight.bold,
              background: BoxDecoration(color: PdfColors.white)),
          headerDecoration: BoxDecoration(color: PdfColors.grey300),
          cellHeight: 30,
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
    return Column(children: [
      BarcodeWidget(
        height: 50,
        width: 50,
        barcode: Barcode.qrCode(),
        data: printObj.getPrintableQrCode(),
      ),
      SizedBox(height: .1 * (PdfPageFormat.cm)),
      Text(printObj.getPrintableQrCodeID(), style: TextStyle(fontSize: 9))
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
