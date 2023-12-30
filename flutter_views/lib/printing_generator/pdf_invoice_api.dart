import 'dart:typed_data';
import 'package:flutter_view_controller/interfaces/printable/printable_invoice_interface.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/printing_generator/print_master.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:flutter/material.dart' as material;
import 'package:printing/printing.dart';
import 'package:flutter/material.dart' as mt;
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../models/prints/print_local_setting.dart';

class PdfInvoiceApi<T extends PrintableInvoiceInterface,
    E extends PrintLocalSetting> extends PrintMasterPDF<T, E> {
  PdfInvoiceApi(material.BuildContext context, T printObj, {E? printCommand})
      : super(context: context, printObj: printObj, setting: printCommand);

  Future<pw.Document> getDocumentP(PdfPageFormat? format) async {
    var pdf = await getDocument();
    pdf.addPage(getMultiPage(format, header));

    return pdf;
  }

  Future<Uint8List> generate(PdfPageFormat? format) async {
    this.format = format;
    return (await getDocumentP(format)).save();
  }

  pw.MultiPage getMultiPage(PdfPageFormat? format, pw.Widget header) {
    return MultiPage(
      pageFormat: format,
      margin: EdgeInsets.zero,
      build: (context) {
        contextPDF = context;
        return [
          Stack(
              alignment: Alignment.bottomRight,
              fit: StackFit.loose,
              children: [header, buildTitle()]),
          buildInvoiceMainInfoHeader(),
          buildSpaceOnInvoice(cm: .5),
          buildInvoiceMainTable(),
          buildMainTotal(),
        ];
      },
    );
  }

  Widget buildInvoiceMainInfoHeader() {
    List<List<InvoiceHeaderTitleAndDescriptionInfo>> inf =
        printObj.getPrintableInvoiceInfo(context, setting);
    return Container(
        width: double.infinity,
        color: PdfColors.grey200,
        padding: const EdgeInsets.all(20),
        child: getDirections(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: checkListToReverse(inf.map((e) {
                  return Column(
                      crossAxisAlignment: isArabic()
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      mainAxisAlignment: isArabic()
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: e
                          .map((item) => buildInvoiceInfoItem(
                              item, inf.length, inf.indexOf(e)))
                          .toList());
                }).toList()))));
  }

  void checkToSort(
      PrintableInvoiceInterfaceDetails pid, List<List<String>> data) {
    if (!hasSortBy()) return;
    String field = setting!.getPrintableSortByName(context)!;
    bool ascending = setting!.getPrintableHasSortBy() == SortByType.ASC;
    int index = pid
        .getPrintableInvoiceTableHeaderAndContent(context, setting)
        .keys
        .toList()
        .indexOf(field);
    if (index != -1) {
      material.debugPrint("checkToSort field => $field  indexOf =$index");
      data.sort((a, b) => compareDynamic(ascending, a[index], b[index]));
    } else {
      material.debugPrint("checkToSort field => $field  indexOf =$index");
    }
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
      return isArabic() ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    } else if (idx == 0) {
      return isArabic() ? CrossAxisAlignment.end : CrossAxisAlignment.start;
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
                crossAxisAlignment:
                    getCrossAxisAlignmentForHeaderInfo(length, idx),
                mainAxisAlignment: getMainAxisSizeForHeaderInfo(length, idx),
                children: [
                  buildTextWithIcon(item),
                  SizedBox(height: 0.1 * PdfPageFormat.cm),
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
        Text(item.title, textDirection: getTextDirection(item.title)),
      ],
    );
  }

  Widget buildInvoiceMainTable() {
    List<PrintableInvoiceInterfaceDetails> details =
        printObj.getPrintableInvoiceDetailsList();

    PrintableInvoiceInterfaceDetails head = details[0];
    var headers = head
        .getPrintableInvoiceTableHeaderAndContent(context, setting)
        .keys
        .map((e) => e.toUpperCase())
        .toList();
    headers = checkListToReverse(headers);

    final data = details
        .map((e) => checkListToReverse(e
            .getPrintableInvoiceTableHeaderAndContent(context, setting)
            .values
            .toList()))
        .toList();

    checkToSort(head, data);

    // data.addAll(getTotalText(headers.length - 1));
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Directionality(
            textDirection: isArabic() ? TextDirection.rtl : TextDirection.ltr,
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
                        width: 1.25,
                        color: PdfColors.grey,
                      )));
                },
                headerCellDecoration: BoxDecoration(
                    color: PdfColors.white,
                    border: Border(
                        bottom:
                            BorderSide(width: 2, color: getPrimaryColor()))),
                cellStyle: Theme.of(contextPDF).tableCell,
                headerStyle: Theme.of(contextPDF).tableHeader.copyWith(
                    color: getPrimaryColor(),
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
                }))));
  }

  Widget buildInvoiceBottomInfoWithQrCode() {
    var children2 = checkListToReverse(buildInvoiceBottomInfoWithQrCodeList);
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: children2);
  }

  List<pw.Column> get buildInvoiceBottomInfoWithQrCodeList {
    return [
      Column(
          crossAxisAlignment:
              isArabic() ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: printObj
              .getPrintableInvoiceAccountInfoInBottom(context, setting)
              .map((e) =>
                  buildBottomAccountInfo(title: e.title, value: e.description))
              .toList()),
      if (setting?.hideQrCode == false)
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
    ];
  }

  Widget buildInvoiceBottom() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
            crossAxisAlignment:
                isArabic() ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 1 * (PdfPageFormat.cm)),
              buildTitleOnInvoice(AppLocalizations.of(context)!.accountInfo),
              buildInvoiceBottomInfoWithQrCode(),
              buildSpaceOnInvoice(cm: .5),
              buildTitleOnInvoice(
                  AppLocalizations.of(context)!.termsAndConitions),
              buildSpaceOnInvoice(cm: .2),
              buildDescriptionOnInvoice(
                  "1- Please quote invoice number when remitting funds, otherwise no item will be replaced or refunded after 2 days of purchase\n\n2- Please pay before the invoice expiry date mentioned above, @ 14% late interest will be charged on late payments."),
              buildSpaceOnInvoice(cm: .5),
              buildTitleOnInvoice(
                  AppLocalizations.of(context)!.additionalNotes),
              buildSpaceOnInvoice(cm: .2),
              buildDescriptionOnInvoice(
                  "Thank you for your business!\nFor any enquiries, email us on paper@saffoury.com or call us on\n+963 989944381")
            ]));
  }

  Widget buildMainTotal() {
    List<InvoiceTotalTitleAndDescriptionInfo> totals =
        printObj.getPrintableInvoiceTotal(context, setting);
    List<InvoiceTotalTitleAndDescriptionInfo> totalDes =
        printObj.getPrintableInvoiceTotalDescripton(context, setting);

    var children2 = checkListToReverse(buildMainTotalList(totals, totalDes));
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children2,
          ),
        ));
  }

  List<pw.Expanded> buildMainTotalList(
      List<InvoiceTotalTitleAndDescriptionInfo> totals,
      List<InvoiceTotalTitleAndDescriptionInfo> totalDes) {
    return [
      Expanded(flex: 2, child: buildInvoiceBottom()),
      Expanded(
          flex: 1,
          child: Container(
            decoration: const BoxDecoration(color: PdfColors.grey),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...totals
                    .map(
                      (e) => buildTotalText(
                          title: e.title,
                          value: e.description,
                          color: e.getColor(),
                          withDivider: totals.indexOf(e) != totals.length - 1),
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
    ];
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
    var children2 =
        checkListToReverse(buildBottomAccountInfoList(title, color, value));
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: children2,
      ),
    );
  }

  List<pw.SpanningWidget> buildBottomAccountInfoList(
      String title, PdfColor? color, String? value) {
    return [
      Text(title,
          textDirection: TextDirection.rtl,
          style: TextStyle(color: color, fontSize: 8)),
      if (value != null)
        Text(value,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: color, fontSize: 8),
            textDirection: TextDirection.rtl),
      SizedBox(height: .3 * (PdfPageFormat.cm))
    ];
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
        children:
            checkListToReverse(buildtotalTextList(title, color, size, value)),
      ),
    );
  }

  List<pw.Widget> buildtotalTextList(
      String title, PdfColor? color, double? size, String? value) {
    return [
      Expanded(
          child: Text(
        title,
        style: TextStyle(color: color, fontSize: size),
        textDirection: getTextDirection(title),
      )),
      // RichText(text: text)
      if (value != null)
        Text(
          value,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: color, fontSize: size),
          textDirection: getTextDirection(value),
        ),
    ];
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
