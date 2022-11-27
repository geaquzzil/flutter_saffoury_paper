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
import 'package:flutter_gen/gen_l10n/app_localization.dart';
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
      title: "TEST",
      pageMode: PdfPageMode.fullscreen,
      theme: myTheme,
    );
    pdf.addPage(getPage(format));
    return pdf.save();
    // return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  Page getPage(PdfPageFormat? format) {
    
    return Page(
        // textDirection: getTextDirection("يسش"),
        pageFormat: format,
        margin: EdgeInsets.zero,
        build: (context) {
          this.contextPDF = context;
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                  alignment: Alignment.bottomCenter,
                  fit: StackFit.loose,
                  children: [header, buildTitle()]),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(flex: 4, child: buildInvoiceMainTable2()),
                    Expanded(
                        flex: 1,
                        child: buildQrCode<E>(this.context, printObj,
                            printCommandAbstract: printCommand))
                  ]),
              buildInvoiceBottom(),
              Spacer(),

              Container(
                  width: double.infinity,
                  height: 10,
                  color: PdfColor.fromHex(
                      printObj.getPrintableSecondaryColor(printCommand))),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: buildInvoiceMainTable2()),
                Expanded(
                    flex: 1,
                    child: buildQrCode<E>(this.context, printObj,
                        size: getQrCodeSize(format),
                        printCommandAbstract: printCommand))
              ])
          // buildInvoiceMainTable(),
        ];
      },
    );
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

  Widget buildInvoiceBottom() {
    return Padding(
        padding: const EdgeInsets.only(left: PdfPageFormat.cm),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 1 * (PdfPageFormat.cm / 2)),
              buildTitleOnInvoice("Terms and conditions"),
              Text(
                  "1- Please receipt invoice number when remitting funds, otherwise no item will be replaced or refunded after 2 days of receipt date\n\n2- Please pay before the invoice expiry date mentioned above, @ 14% late interest will be charged on late payments.",
                  style:
                      const TextStyle(fontSize: 9, color: PdfColors.grey700)),
              SizedBox(height: 1 * (PdfPageFormat.cm / 2)),
              buildTitleOnInvoice("Additional notes"),
              Text(
                  "Thank you for your business!\nFor any enquiries, email us on paper@saffoury.com or call us on\n+963 989944381",
                  style: const TextStyle(fontSize: 9, color: PdfColors.grey700))
            ]));
  }

  List<String> getList(List<RecieptHeaderTitleAndDescriptionInfo> list) {
    List<String> stringList = [];
    for (var element in list) {
      stringList.add(element.title);
      stringList.add(element.description);
    }
    return stringList;
  }

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
        padding: const EdgeInsets.only(
            top: PdfPageFormat.cm,
            bottom: PdfPageFormat.cm,
            left: PdfPageFormat.cm),
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
          Text(
            recieptHeaderTitleAndDescriptionInfo.title,
            textDirection:
                getTextDirection(recieptHeaderTitleAndDescriptionInfo.title),
          ),
          SizedBox(width: 1 * (PdfPageFormat.cm / 2)),
          Expanded(
              child: Container(
                  constraints:
                      const BoxConstraints(minHeight: 30, maxHeight: 80),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
          Text(
            recieptHeaderTitleAndDescriptionInfo.title,
            textDirection:
                getTextDirection(recieptHeaderTitleAndDescriptionInfo.title),
          ),
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

  PdfColor getSecondaryColor() {
    return PdfColor.fromHex(printObj.getPrintableSecondaryColor(printCommand));
  }

  PdfColor getPrimaryColor() {
    return PdfColor.fromHex(printObj.getPrintablePrimaryColor(printCommand));
  }

  Widget buildTitle() {
    String title = printObj.getPrintableInvoiceTitle(context, printCommand);
    return Text(
      title,
      textDirection: getTextDirection(title),
      style: TextStyle(
          fontSize: 20,
          color: PdfColor.fromHex(
              printObj.getPrintablePrimaryColor(printCommand))),
    );
  }

  Widget buildTitleOnInvoice(String title) {
    return Text(title,
        textDirection: getTextDirection(title),
        style:
            TextStyle(fontWeight: FontWeight.bold, color: getSecondaryColor()));
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
