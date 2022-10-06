import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_view_controller/interfaces/printable_interface.dart';
import 'package:flutter_view_controller/models/prints/print_commad_abstract.dart';
import 'package:flutter_view_controller/printing_generator/pdf_api.dart';
import 'package:flutter_view_controller/printing_generator/utils.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:flutter/material.dart' as material;
import 'package:printing/printing.dart';
import 'package:flutter/material.dart' as mt;
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class PdfInvoiceApi<T extends PrintableInterface> {
  material.BuildContext context;
  T printObj;
  PrintCommandAbstract? printCommand;
  PdfInvoiceApi(this.context, this.printObj, {this.printCommand});
  Future<Uint8List> generateFromImage(Uint8List? list) {
    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        // buildHeader(),
        if (list != null) pw.Image(MemoryImage(list)),

        buildInvoiceMainInfoHeader(),
        // buildSubHeaderInfo(invoice),
        SizedBox(height: 3 * PdfPageFormat.cm),
        buildTitle(),
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
return ThemeData.withFont(
        icons: await PdfGoogleFonts.materialIcons(),
        base: await PdfGoogleFonts.tajawalRegular(),
        bold: await PdfGoogleFonts.tajawalBold(),
        italic: await PdfGoogleFonts.tajawalMedium(),
        boldItalic: await PdfGoogleFonts.tajawalBold());
  }
  Future<Widget> buildHeader()async=>
  pw.Image( await networkImage(
        'https://saffoury.com/SaffouryPaper2/print/headers/headerA4IMG.php?color=${printObj.getInvoicePrimaryColor()}&darkColor=${printObj.getInvoiceSecondaryColor()}'));

  Future<Uint8List> generate(PdfPageFormat? format) async {
    var myTheme = await getThemeData();
    final header = await buildHeader();

    final pdf = Document(theme: myTheme);
    pdf.addPage(MultiPage(
      
      pageFormat: format,
      margin: EdgeInsets.zero,
      // pageTheme: ,
      build: (context) => [
      header,
        buildInvoiceMainInfoHeader(),
        buildInvoiceMainTable(),
        buildMainTotal()
      ],
      // footer: (context) => buildFooter(invoice),
    ));
    return pdf.save();
    // return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  Widget buildInvoiceMainInfoHeader() {
    List<List<TitleAndDescriptionInfoWithIcon>> inf =
        printObj.getInvoiceInfo(context, printCommand);
    return Container(
        width: double.infinity,
        color: PdfColors.grey50,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: inf.map((e) {
              // inf.firs==
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:
                      e.map((item) => buildInvoiceInfoItem(item)).toList());
            }).toList()));
  }

  pw.Padding buildInvoiceInfoItem(TitleAndDescriptionInfoWithIcon item) {
    return Padding(
        padding: EdgeInsets.all(5),
        child: Container(
            width: 200,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                // crossAxisAlignment: ,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildTextWithIcon(item),
                  Text(
                    item.description,
                    textDirection: TextDirection.rtl,
                  ),
                ])));
  }

  pw.Row buildTextWithIcon(TitleAndDescriptionInfoWithIcon item) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          color: PdfColors.grey,
          size: 15,
          IconData(item.icon.codePoint),
        ),
        SizedBox(width: 0.2 * PdfPageFormat.cm),
        Text(item.title),
      ],
    );
  }

  Widget buildTitle() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            printObj.getInvoiceTitle(context, printCommand),
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          // Text(invoice.info.description),
          // SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );
  // List<String> getTotalText(int colCount) {
  //  return List.generate(colCount, (index) =>

  //  );
  // }
  Widget buildInvoiceMainTable() {
    List<PrintableInterfaceDetails> details = printObj.getInvoiceDetailsList();

    PrintableInterfaceDetails head = details[0];
    final headers = head
        .getInvoiceTableHeaderAndContent(context, printCommand)
        .keys
        .toList();

    final data = details
        .map((e) => e
            .getInvoiceTableHeaderAndContent(context, printCommand)
            .values
            .toList())
        .toList();

    // data.addAll(getTotalText(headers.length - 1));
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Table.fromTextArray(
            headers: headers,
            data: data,
            border: null,
            cellDecoration: (index, data, rowNum) => BoxDecoration(
                color: PdfColors.white,
                border: Border(
                    bottom: BorderSide(
                  //                    <--- top side
                  color: PdfColors.grey,
                  // width: 1.0,
                ))),
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
        style: TextStyle(fontWeight: FontWeight.bold, color: PdfColors.green));
  }

  Widget buildInvoiceBottomInfoWithQrCode() {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(children: [
            Text("${AppLocalizations.of(context)!.name}
              
              "abou wael labalaidi : 21321321"),
            Text("abou number labalaidi : 231iD"),
          ]),
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
                width: 50,
                height: 50,
                child: BarcodeWidget(
                  barcode: Barcode.qrCode(),
                  data: printObj.getInvoiceQrCode(),
                )),
            Text("INV-823-2022")
          ])
        ]);
  }

  Widget buildInvoiceBottom() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildTitleOnInvoice("ACCOUNT INFO"),
              buildInvoiceBottomInfoWithQrCode(),
              SizedBox(height: 1 * (PdfPageFormat.cm / 2)),
              buildTitleOnInvoice("Terms and conditions"),
              Text(
                  "1- Please quote invoice number when remitting funds, otherwise no item will be replaced or refunded after 2 days of purchase\n\n2- Please pay before the invoice expiry date mentioned above, @ 14% late interest will be charged on late payments.",
                  style: TextStyle(fontSize: 8, color: PdfColors.grey700)),
              SizedBox(height: 1 * (PdfPageFormat.cm / 2)),
              buildTitleOnInvoice("Additional notes"),
              Text(
                  "Thank you for your business!\nFor any enquiries, email us on paper@saffoury.com or call us on\n+963 989944381",
                  style: TextStyle(fontSize: 8, color: PdfColors.grey700))
            ]));
  }

  Widget buildMainTotal() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Expanded(flex: 2, child: buildInvoiceBottom()),
          Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(color: PdfColors.grey),
                // color: PdfColors.grey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...printObj
                        .getInvoiceTotal(context, printCommand)
                        .map(
                          (e) => buildTotalText(
                            title: e.title,
                            value: e.description,
                            unite: true,
                          ),
                        )
                        .toList(),
                    buildTotalText(
                      title: 'Net total',
                      value: " ",
                      unite: true,
                    ),
                    buildTotalText(
                      title: 'Vat ${3 * 100} %',
                      value: "V",
                      unite: true,
                    ),
                    Divider(),
                    buildTotalText(
                      title: 'Total amount due',
                      titleStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      value: Utils.formatPrice(2321),
                      unite: true,
                    ),
                    SizedBox(height: 2 * PdfPageFormat.mm),
                    Container(height: 1, color: PdfColors.grey400),
                    SizedBox(height: 0.5 * PdfPageFormat.mm),
                    Container(height: 1, color: PdfColors.grey400),
                  ],
                ),
              )),
        ],
      ),
    );
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

  static buildTotalText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      height: 25,
      decoration: getDividerBetweenContent(),
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          // RichText(text: text)
          Text(
            value,
            style: unite ? style : null,
            textDirection: TextDirection.rtl,
          ),
          // Html.fromDom(data: "<b>$value</b>")
        ],
      ),
    );
  }

  static pw.BoxDecoration getDividerBetweenContent() {
    return const BoxDecoration(
        color: PdfColors.white,
        border: Border(
            bottom: BorderSide(
          //                    <--- top side
          color: PdfColors.grey,
          width: 1.0,
        )));
  }
}

class _Block extends pw.StatelessWidget {
  _Block({
    required this.title,
    this.icon,
  });

  final String title;

  final pw.IconData? icon;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: <pw.Widget>[
          pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: <pw.Widget>[
                pw.Container(
                  width: 6,
                  height: 6,
                  margin: const pw.EdgeInsets.only(top: 5.5, left: 2, right: 5),
                  decoration: const pw.BoxDecoration(
                    color: PdfColors.grey,
                    shape: pw.BoxShape.circle,
                  ),
                ),
                pw.Text(title,
                    style: pw.Theme.of(context)
                        .defaultTextStyle
                        .copyWith(fontWeight: pw.FontWeight.bold)),
                pw.Spacer(),
                if (icon != null)
                  pw.Icon(icon!, color: PdfColors.grey, size: 18),
              ]),
          pw.Container(
            decoration: const pw.BoxDecoration(
                border: pw.Border(
                    left: pw.BorderSide(color: PdfColors.grey, width: 2))),
            padding: const pw.EdgeInsets.only(left: 10, top: 5, bottom: 5),
            margin: const pw.EdgeInsets.only(left: 5),
            child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: <pw.Widget>[
                  pw.Lorem(length: 20),
                ]),
          ),
        ]);
  }
}
