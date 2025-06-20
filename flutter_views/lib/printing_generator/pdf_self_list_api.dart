// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart' as mt;
import 'package:flutter/services.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_invoice_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_list_interface.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/printing_generator/pdf_list_api.dart';
import 'package:flutter_view_controller/printing_generator/print_master.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import 'package:supercharged/supercharged.dart';

import '../models/prints/print_local_setting.dart';

class PdfSelfListApi<T extends PrintLocalSetting>
    extends PrintMasterPDFUtils<T> {
  List<PrintableSelfListInterface<T>> list;

  late List<List<InvoiceHeaderTitleAndDescriptionInfo>>? headerInfoList;
  late List<InvoiceTotalTitleAndDescriptionInfo>? totalList;
  late List<InvoiceTotalTitleAndDescriptionInfo>? totalDescriptionList;
  late List<InvoiceHeaderTitleAndDescriptionInfo>? accountInfoList;
  PrintableComparableListInterface? comparapleObject;

  PrintableSelfListInterface printObj;
  PdfSelfListApi(this.list, material.BuildContext context, this.printObj,
      {T? printCommand})
      : super(context: context, setting: printCommand);

  Future<void> init() async {
    headerInfoList =
        await printObj.getPrintableSelfListHeaderInfo(context, list, setting);
    totalList =
        await printObj.getPrintableSelfListTotal(context, list, setting);
    totalDescriptionList = await printObj.getPrintableSelfListTotalDescripton(
        context, list, setting);
    accountInfoList = await printObj.getPrintableSelfListAccountInfoInBottom(
        context, list, setting);

    if (printObj is PrintableComparableListInterface) {
      List? l =
          (printObj as PrintableComparableListInterface).getComparableList();
      comparapleObject = l?.isEmpty == true || l == null
          ? null
          : printObj as PrintableComparableListInterface;
    }

    material.debugPrint("PdfSelfListApi pdfSelf => $list");
    material.debugPrint("PdfSelfListApi hasHeaderInfo => ${hasHeaderInfo()}");
    material.debugPrint("PdfSelfListApi hasTotal => ${hasTotal()}");
    material.debugPrint(
        "PdfSelfListApi hasAccountInfoBottom => ${hasAccountInfoBottom()}");
    material.debugPrint(
        "PdfSelfListApi hasTotalDescription => ${hasTotalDescription()}");
  }

  @override
  Future<Widget> buildHeader() async {
    String url =
        'https://saffoury.com/SaffouryPaper2/print/headers/headerA4IMG.php?color=${getPrimaryColorStringHex()}&darkColor=${getSecondaryColorStringHex()}';
    material.debugPrint("buildHeader $url");
    // return SvgImage(
    //     svg: await rootBundle.loadString("assets/images/vector/a4Header.svg"));
    return Image(await networkImage(url));
  }

  bool hasHeaderInfo() {
    return headerInfoList != null && (headerInfoList?.isNotEmpty ?? false);
  }

  bool hasTotal() {
    return totalList != null && (totalList?.isNotEmpty ?? false);
  }

  bool hasTotalDescription() {
    // return false;
    return totalDescriptionList != null &&
        (totalDescriptionList?.isNotEmpty ?? false);
  }

  bool hasAccountInfoBottom() {
    return accountInfoList != null && (accountInfoList?.isNotEmpty ?? false);
  }

  Future<Uint8List> generate(PdfPageFormat? format,
      {Function(int pagesAddedCount)? pagesAdded, PageRange? pageRange}) async {
    material.debugPrint("generate self_list");
    await init();
    var pdf = await getDocument();

    if (hasGroupBy()) {
      int index = list[0]
          .getPrintableSelfListTableHeaderAndContent(context, list[0], setting)
          .keys
          .toList()
          .indexOf(setting!.getPrintableGroupByName()!);

      final data = list
          .map((e) => checkListToReverse(e
              .getPrintableSelfListTableHeaderAndContent(context, e, setting)
              .values
              .toList()))
          .toList();
      mt.debugPrint(" ssss $data");
      checkToSort(list[0], data);
      var d = data.groupBy((element) => element[index]);
      int idx = 0;

      for (int i = 0; i < d.keys.length - 1; i++) {
        pdf.addPage(await getMultiPageGrouped(format, header,
            d.keys.elementAt(i), d.values.elementAt(i).cast(), i));
      }
    } else {
      pdf.addPage(await getMultiPage(format, header));
    }
    pagesAdded?.call(pdf.document.pdfPageList.pages.length);
    return pdf.save();
  }

  Future<pw.MultiPage> getMultiPageGrouped(
      PdfPageFormat? format,
      pw.Widget header,
      String groupName,
      List<List<String>> data,
      int idx) async {
    //      headerInfoList =
    //     await printObj.getPrintableSelfListHeaderInfo(context, list, setting);
    // totalList =
    //     await printObj.getPrintableSelfListTotal(context, list, setting);
    // totalDescriptionList = await printObj.getPrintableSelfListTotalDescripton(
    //     context, list, setting);
    // accountInfoList = await printObj.getPrintableSelfListAccountInfoInBottom(
    //     context, list, setting);
    setting?.currentGroupNameFromList = groupName;
    setting?.currentGroupList = data;
    setting?.currentGroupNameIndex = idx;
    Widget w = await buildInvoiceMainInfoHeader();
    return MultiPage(
      pageFormat: format,
      margin: EdgeInsets.zero,
      build: (context) {
        contextPDF = context;
        return [
          if (idx == 0)
            Stack(
                alignment: Alignment.bottomRight,
                fit: StackFit.loose,
                children: [header, buildTitle()]),
          if (hasHeaderInfo()) w,
          buildSpaceOnInvoice(cm: .5),
          buildInvoiceMainTable(customData: data),
          // if (hasTotal()) buildMainTotal(),
        ];
      },
    );
  }

  Future<pw.MultiPage> getMultiPage(
      PdfPageFormat? format, pw.Widget header) async {
    Widget widget = await buildInvoiceMainInfoHeader();
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
          if (hasHeaderInfo()) widget,
          buildSpaceOnInvoice(cm: .5),
          // if (hasGroupBy())
          //   ...buildInvoiceMainTableGroupBy()
          // else
          buildInvoiceMainTable(),
          if (hasTotal()) buildMainTotal(),
        ];
      },
    );
  }

  Future<pw.Widget> buildInvoiceMainInfoHeader() async {
    var currentHeaderInfoList = hasGroupBy()
        ? await printObj.getPrintableSelfListHeaderInfo(context, list, setting)
        : headerInfoList;
    return Container(
        width: double.infinity,
        color: PdfColors.grey200,
        padding: const EdgeInsets.all(20),
        child: getDirections(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: checkListToReverse(currentHeaderInfoList!.map((e) {
                  return Column(
                      crossAxisAlignment: isArabic()
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      mainAxisAlignment: isArabic()
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: e
                          .map((item) => buildInvoiceInfoItem(
                              item,
                              headerInfoList!.length,
                              headerInfoList!.indexOf(e)))
                          .toList());
                }).toList()))));
  }

  void checkToSortByGroupField() {}
  void checkToSort(PrintableSelfListInterface pid, List<List<String>> data) {
    if (!hasSortBy()) return;
    String field = setting!.getPrintableSortByName(context)!;
    bool ascending = setting!.getPrintableHasSortBy() == SortByType.ASC;
    int index = pid
        .getPrintableSelfListTableHeaderAndContent(context, list[0], setting)
        .keys
        .toList()
        .indexOf(field);
    if (index != -1) {
      // material.debugPrint("checkToSort field => $field  indexOf =$index");
      data.sort((a, b) => compareDynamic(ascending, a[index], b[index]));
    } else {
      // material.debugPrint("checkToSort field => $field  indexOf =$index");
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

  List<Widget> buildInvoiceMainTableGroupBy() {
    PrintableSelfListInterface head = list[0];
    var headers = head
        .getPrintableSelfListTableHeaderAndContent(
            context, (list[0] as ViewAbstract).getSelfNewInstance(), setting)
        .keys
        .map((e) => e.toUpperCase())
        .toList();

    headers = checkListToReverse(headers);

    final data = list
        .map((e) => checkListToReverse(e
            .getPrintableSelfListTableHeaderAndContent(context, e, setting)
            .values
            .toList()))
        .toList();

    var headerGroupBy = headers.groupBy((element) =>
        element.toLowerCase() ==
        setting?.getPrintableGroupByName()!.toLowerCase());
    mt.debugPrint(
        "groupByField ${setting?.getPrintableGroupByName()}  headerGroupBy $headerGroupBy");
    checkToSort(head, data);
    return [];
  }

//todo customData which means that grouping is enable dose not supports comparableForNow
  Widget buildInvoiceMainTable({dynamic customData}) {
    if (comparapleObject != null) {
      final comparedList = comparapleObject!.getComparableList()!;
      bool startWithCompared = comparedList.length > list.length;
      // final subList = list.toSet().difference(comparedList.toSet()).toList();
      final subList = startWithCompared
          ? comparedList.where((element) => !list.contains(element))
          : list.where((element) => !comparedList.contains(element));
      final finalList = List.from(list);
      finalList.addAll(subList);

      mt.debugPrint(
          "PDFAPI list ${list.length}  =>${list.map((o) => (o as ViewAbstract).iD)}");

      mt.debugPrint(
          "PDFAPI comparedList ${comparedList.length} => ${comparedList.map((o) => (o as ViewAbstract).iD)}");
      mt.debugPrint(
          "PDFAPI subList ${subList.length}=> ${subList.map((o) => (o as ViewAbstract).iD)}");
      mt.debugPrint(
          "PDFAPI finalList ${finalList.length}=> ${finalList.map((o) => (o as ViewAbstract).iD)}");

      PrintableSelfListInterface head = list[0];
      var headers = head
          .getPrintableSelfListTableHeaderAndContent(
              context, (list[0] as ViewAbstract).getSelfNewInstance(), setting)
          .keys
          .map((e) => e.toUpperCase())
          .toList();

      headers = checkListToReverse(headers);

      var comparedHeaders = comparapleObject!
          .getPrintableComparableTableHeaderAndContent(
              context, comparapleObject, comparapleObject, setting)
          .keys
          .map((e) => e.toUpperCase())
          .toList();

      comparedHeaders = checkListToReverse(comparedHeaders);

      final data = finalList
          .map((e) => checkListToReverse(e
              .getPrintableSelfListTableHeaderAndContent(context, e, setting)
              .values
              .toList()))
          .toList();

      checkToSort(head, data.cast());

      final comperedData = finalList
          .map((e) => checkListToReverse(e
              .getPrintableComparableTableHeaderAndContent(
                  context,
                  list.firstWhereOrNull((l) => comparapleObject!.compare(l, e)),
                  comparedList
                      .firstWhereOrNull((c) => comparapleObject!.compare(c, e)),
                  setting)
              .values
              .toList()))
          .toList();

      checkToSort(head, comperedData.cast());

      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    getTableContent(comparedHeaders, comperedData,
                        isComparable: true),
                    getTableContent(headers, data),
                  ])));
    }

    PrintableSelfListInterface head = list[0];
    var headers = head
        .getPrintableSelfListTableHeaderAndContent(
            context, (list[0] as ViewAbstract).getSelfNewInstance(), setting)
        .keys
        .map((e) => e.toUpperCase())
        .toList();

    headers = checkListToReverse(headers);

    final data = customData ??
        list
            .map((e) => checkListToReverse(e
                .getPrintableSelfListTableHeaderAndContent(context, e, setting)
                .values
                .toList()))
            .toList();

    checkToSort(head, data);

    // data.addAll(getTotalText(headers.length - 1));
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Directionality(
            textDirection: TextDirection.rtl,
            child: getTableContent(headers, data)));
  }

  pw.Table getTableContent(List<String> headers, data,
      {bool isComparable = false}) {
    return TableHelper.fromTextArray(

        // columnWidths: {
        //   0: FixedColumnWidth(50),
        //   1: FixedColumnWidth(300)
        // },
        headers: headers,
        border: null,
        data: data,
        // border: isComparable
        //     ? TableBorder.only(width: 2, color: PdfColors.black)
        //     : null,
        cellDecoration: (index, data, rowNum) {
          // mt.debugPrint("cellDecoration rownum $rowNum index= $index");
          return const BoxDecoration(
              color: PdfColors.white,
              border: Border(
                  // left: isComparable
                  //     ? const BorderSide(color: PdfColors.grey)
                  //     : BorderSide.none,
                  // right: isComparable
                  //     ? const BorderSide(color: PdfColors.grey)
                  //     : BorderSide.none,
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
        cellStyle: TextStyle(
            color: PdfColors.black,
            fontSize: isComparable ? 14 : null,
            fontWeight: isComparable ? FontWeight.bold : null),
        headerStyle: TextStyle(
            color: getSecondaryColor(),
            fontWeight: FontWeight.bold,
            background: const BoxDecoration(color: PdfColors.white)),
        headerDecoration: const BoxDecoration(color: PdfColors.grey300),
        cellHeight: 40,
        cellAlignments: Map.fromIterable(headers, key: (e) {
          int idx = headers.indexOf(e);
          return idx;
        }, value: (e) {
          int idx = headers.indexOf(e);
          if (isComparable) {
            return Alignment.center;
          }
          return idx == 0
              ? Alignment.centerLeft
              : (idx == headers.length - 1
                  ? Alignment.centerRight
                  : Alignment.center);
        }));
  }

  PdfColor getSecondaryColor() {
    return PdfColor.fromHex(
        printObj.getPrintableSelfListSecondaryColor(setting));
  }

  PdfColor getPrimaryColor() {
    return PdfColor.fromHex(printObj.getPrintableSelfListPrimaryColor(setting));
  }

  String getPrimaryColorStringHex() {
    return getPrimaryColor().toHex().substring(1, 7);
  }

  String getSecondaryColorStringHex() {
    return getSecondaryColor().toHex().substring(1, 7);
  }

  pw.Widget buildTitle() {
    String title = (printObj)
        .getPrintableSelfListInvoiceTitle(context, setting)
        .toUpperCase();
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 5),
        child: Text(
          title,
          textDirection: getTextDirection(title),
          style: TextStyle(fontSize: 20, color: getPrimaryColor()),
        ));
  }

  Widget buildTitleOnInvoice(String title) {
    return Text(title,
        textDirection: getTextDirection(title),
        style:
            TextStyle(fontWeight: FontWeight.bold, color: getSecondaryColor()));
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
          children: accountInfoList!
              .map((e) =>
                  buildBottomAccountInfo(title: e.title, value: e.description))
              .toList()),
      if (setting?.hideQrCode == false)
        Column(children: [
          BarcodeWidget(
            height: 50,
            width: 50,
            barcode: Barcode.qrCode(),
            data: printObj.getPrintableSelfListQrCode(),
          ),
          SizedBox(height: .1 * (PdfPageFormat.cm)),
          Text(printObj.getPrintableSelfListQrCodeID(),
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
              SizedBox(height: 1 * (PdfPageFormat.cm / 2)),
              buildTitleOnInvoice(
                  AppLocalizations.of(context)!.termsAndConitions),
              Text(
                  "1- Please quote invoice number when remitting funds, otherwise no item will be replaced or refunded after 2 days of purchase\n\n2- Please pay before the invoice expiry date mentioned above, @ 14% late interest will be charged on late payments.",
                  style:
                      const TextStyle(fontSize: 9, color: PdfColors.grey700)),
              SizedBox(height: 1 * (PdfPageFormat.cm / 2)),
              buildTitleOnInvoice(
                  AppLocalizations.of(context)!.additionalNotes),
              Text(
                  "Thank you for your business!\nFor any enquiries, email us on paper@saffoury.com or call us on\n+963 989944381",
                  style: const TextStyle(fontSize: 9, color: PdfColors.grey700))
            ]));
  }

  Widget buildMainTotal() {
    var children2 = checkListToReverse(buildMainTotalList());
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children2,
          ),
        ));
  }

  List<pw.Expanded> buildMainTotalList() {
    return [
      Expanded(flex: 2, child: buildInvoiceBottom()),
      Expanded(
          flex: 1,
          child: Container(
            decoration: const BoxDecoration(color: PdfColors.grey),
            // color: PdfColors.grey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hasTotal())
                  ...totalList!.map(
                    (e) => buildTotalText(
                        title: e.title,
                        value: e.description,
                        color: e.getColor(),
                        withDivider:
                            totalList!.indexOf(e) != totalList!.length - 1),
                  ),
                if (hasTotalDescription())
                  ...totalDescriptionList!.map((e) => buildTotalText(
                      size: e.size,
                      title: e.title,
                      value: e.description,
                      color: e.getColor(),
                      withDivider: totalDescriptionList!.indexOf(e) ==
                          totalDescriptionList!.length - 1))
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
