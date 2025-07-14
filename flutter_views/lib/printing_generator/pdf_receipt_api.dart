// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:flutter/material.dart' as material;
import 'package:flutter_view_controller/globals.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_bill_interface.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/printing_generator/print_master.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

import 'ext.dart' as ext;

class PdfReceipt<T extends PrintableReceiptInterface,
    E extends PrintLocalSetting> extends PrintMasterPDF<T, E> {
  PdfReceipt(material.BuildContext context, T printObj, {E? printCommand})
      : super(context: context, printObj: printObj, setting: printCommand);

  Future<Document> getDocumentP(PdfPageFormat? format) async {
    final pdf = await getDocument();
    pdf.addPage(await getPage(format, header));
    return pdf;
  }

  Future<Uint8List> generate(PdfPageFormat? format) async {
    return (await getDocumentP(format)).save();
  }

  Future<pw.Page> getPage(PdfPageFormat? format, Widget header) async {
    Widget? watermark = printObj.getPrintableWatermark(format);
    PageTheme pageTheme = PageTheme(
      margin: EdgeInsets.zero,
      pageFormat: format,
      theme: await getThemeData(),
      textDirection:
          Globals.isArabic(context) ? TextDirection.rtl : TextDirection.ltr,
      buildBackground:
          watermark != null ? (Context context) => watermark : null,
    );
    return Page(
        // textDirection: getTextDirection("يسش"),

        pageTheme: pageTheme,
        build: (context) {
          contextPDF = context;
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
                  children: checkListToReverse(getMainPageListRow)),
              buildInvoiceBottom(),
              Spacer(),

              Container(
                  width: double.infinity,
                  height: 10,
                  color: PdfColor.fromHex(
                      printObj.getPrintableSecondaryColor(setting))),
              // buildInvoiceMainTable(),
            ],
          );
        });
  }

  List<pw.Widget> get getMainPageListRow {
    return [
      Expanded(flex: 4, child: buildInvoiceMainTable2()),
      Expanded(
          flex: 1,
          child: ext.printableBuildQrCode<E>(context, printObj,
              printCommandAbstract: setting))
    ];
  }

  @override
  Future<Widget> buildHeader() async {
    return Image(await networkImage(
        'https://saffoury.com/SaffouryPaper2/print/headers/headerA5IMG.php?color=${getPrimaryColorStringHex()}&darkColor=${getSecondaryColorStringHex()}'));
  }

  Widget buildInvoiceBottom() {
    return Padding(
        padding: const EdgeInsets.only(left: PdfPageFormat.cm),
        child: Column(
            crossAxisAlignment: getCrossAxis(),
            mainAxisAlignment: getMainAxis(),
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
        .getPrintableRecieptHeaderTitleAndDescription(context, setting)
        .values
        .map((e) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: checkListToReverse(e.map((e) => buildText(e)).toList())))
        .toList();

    var footers = printObj
        .getPrintableRecieptFooterTitleAndDescription(context, setting)
        .values
        .map((e) => Row(
            children:
                checkListToReverse(e.map((e) => buildFooterText(e)).toList())))
        .toList();
    var customWidget =
        printObj.getPrintableRecieptCustomWidget(context, setting, this);
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

  Widget buildText(
      RecieptHeaderTitleAndDescriptionInfo
          recieptHeaderTitleAndDescriptionInfo) {
    return Expanded(
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: checkListToReverse([
              SizedBox(width: 1 * (PdfPageFormat.cm / 2)),
              Text(
                recieptHeaderTitleAndDescriptionInfo.title,
                textDirection: getTextDirection(
                    recieptHeaderTitleAndDescriptionInfo.title),
              ),
              SizedBox(width: 1 * (PdfPageFormat.cm / 2)),
              Expanded(
                  child: Container(
                      constraints:
                          const BoxConstraints(minHeight: 30, maxHeight: 80),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
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
                            color:
                                recieptHeaderTitleAndDescriptionInfo.hexColor ==
                                        null
                                    ? null
                                    : PdfColor.fromHex(
                                        recieptHeaderTitleAndDescriptionInfo
                                            .hexColor!)),
                        textAlign:
                            isArabic() ? TextAlign.center : TextAlign.left,
                        recieptHeaderTitleAndDescriptionInfo.description,
                        // style: Theme.of(context).tableCell
                      ))),
              SizedBox(width: 1 * (PdfPageFormat.cm / 3)),
            ])));
  }

  Widget buildFooterText(
      RecieptHeaderTitleAndDescriptionInfo
          recieptHeaderTitleAndDescriptionInfo) {
    return Expanded(
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            // mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: checkListToReverse(
                getFooterTextList(recieptHeaderTitleAndDescriptionInfo))));
  }

  List<pw.Widget> getFooterTextList(
      RecieptHeaderTitleAndDescriptionInfo
          recieptHeaderTitleAndDescriptionInfo) {
    return [
      Text(
        recieptHeaderTitleAndDescriptionInfo.title,
        textDirection:
            getTextDirection(recieptHeaderTitleAndDescriptionInfo.title),
      ),
      SizedBox(width: 1 * (PdfPageFormat.cm / 2)),
      Expanded(
          child: Container(
              constraints: const BoxConstraints(minHeight: 40, maxHeight: 80),
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
                    color: recieptHeaderTitleAndDescriptionInfo.hexColor == null
                        ? null
                        : PdfColor.fromHex(
                            recieptHeaderTitleAndDescriptionInfo.hexColor!)),
                textAlign: TextAlign.left,
                recieptHeaderTitleAndDescriptionInfo.description,
                // style: Theme.of(context).tableCell
              ))),
      SizedBox(width: 1 * (PdfPageFormat.cm / 3)),
    ];
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
