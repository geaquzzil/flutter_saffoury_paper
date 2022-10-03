import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_view_controller/models/prints/print_commad_abstract.dart';
import 'package:flutter_view_controller/printing_generator/pdf_api.dart';
import 'package:flutter_view_controller/printing_generator/utils.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:flutter/material.dart' as material;
import 'package:printing/printing.dart';

import 'svg/headers/a4.dart';

class TitleAndDescriptionInfo {
  String title;
  String description;
  TitleAndDescriptionInfo(this.title, this.description);
}

abstract class InvoiceGenerator {
  String getInvoiceTitle(
      material.BuildContext context, PrintCommandAbstract? pca);

  ///invoice number ...etc
  ///'Invoice Number:',
  /// 'Invoice Date:',
  /// 'Payment Terms:',
  ///'Due Date:'
  List<TitleAndDescriptionInfo> getInvoiceInfo(
      material.BuildContext context, PrintCommandAbstract? pca);
  List<TitleAndDescriptionInfo> getInvoiceTotal(
      material.BuildContext context, PrintCommandAbstract? pca);
}

class PdfInvoiceApi<T extends InvoiceGenerator> {
  material.BuildContext context;
  T printObj;
  PrintCommandAbstract? printCommand;
  PdfInvoiceApi(this.context, this.printObj, {this.printCommand});

  Future<Uint8List> generate() async {
    final pdf = Document();

    final netImage = await networkImage(
        'https://saffoury.com/SaffouryPaper2/print/headers/headerA4IMG.php?color=434343');
    pdf.addPage(MultiPage(
      build: (context) => [
        // buildHeader(),
        pw.Image(netImage),

        buildInvoiceInfo(),
        // buildSubHeaderInfo(invoice),
        SizedBox(height: 3 * PdfPageFormat.cm),
        buildTitle(),
        // buildInvoiceTable(),
        Divider(),
        // buildTotal(),
      ],
      // footer: (context) => buildFooter(invoice),
    ));
    return pdf.save();
    // return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  // Widget buildHeader() {
  //   return Html(data: "data");
  //   return Column(children: [
  //     SvgPicture.network('https://site-that-takes-a-while.com/image.svg',
  //         semanticsLabel: 'A shark?!')
  //   ]);
  // }
  // static Widget buildHeader() => Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         SizedBox(height: 1 * PdfPageFormat.cm),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             buildSupplierAddress(invoice.supplier),
  //             Container(
  //               height: 50,
  //               width: 50,
  //               child: BarcodeWidget(
  //                 barcode: Barcode.qrCode(),
  //                 data: invoice.info.number,
  //               ),
  //             ),
  //           ],
  //         ),
  //         SizedBox(height: 1 * PdfPageFormat.cm),
  //         Row(
  //           crossAxisAlignment: CrossAxisAlignment.end,
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             buildCustomerAddress(invoice.customer),
  //             buildInvoiceInfo(invoice.info),
  //           ],
  //         ),
  //       ],
  //     );

  // static Widget buildCustomerAddress() => Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(customer.name, style: TextStyle(fontWeight: FontWeight.bold)),
  //         Text(customer.address),
  //       ],
  //     );

  Widget buildInvoiceInfo() {
    List<TitleAndDescriptionInfo> inf =
        printObj.getInvoiceInfo(context, printCommand);
    final titles = inf.map((e) => e.title).toList();
    final description = inf.map((e) => e.description).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = description[index];
        return buildText(title: title, value: value, width: 200);
      }),
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

//    Widget buildInvoiceTable() {
//     final headers = [
//       'Description',
//       'Date',
//       'Quantity',
//       'Unit Price',
//       'VAT',
//       'Total'
//     ];
//     final data = invoice.items.map((item) {
//       final total = item.unitPrice * item.quantity * (1 + item.vat);

//       return [
//         item.description,
//         Utils.formatDate(item.date),
//         '${item.quantity}',
//         '\$ ${item.unitPrice}',
//         '${item.vat} %',
//         '\$ ${total.toStringAsFixed(2)}',
//       ];
//     }).toList();

//     return Table.fromTextArray(
//       headers: headers,
//       data: data,
//       border: null,
//       headerStyle: TextStyle(fontWeight: FontWeight.bold),
//       headerDecoration: BoxDecoration(color: PdfColors.grey300),
//       cellHeight: 30,
//       cellAlignments: {
//         0: Alignment.centerLeft,
//         1: Alignment.centerRight,
//         2: Alignment.centerRight,
//         3: Alignment.centerRight,
//         4: Alignment.centerRight,
//         5: Alignment.centerRight,
//       },
//     );
//   }

//  Widget buildTotal() {
//     final netTotal = invoice.items
//         .map((item) => item.unitPrice * item.quantity)
//         .reduce((item1, item2) => item1 + item2);
//     final vatPercent = invoice.items.first.vat;
//     final vat = netTotal * vatPercent;
//     final total = netTotal + vat;

//     return Container(
//       alignment: Alignment.centerRight,
//       child: Row(
//         children: [
//           Spacer(flex: 6),
//           Expanded(
//             flex: 4,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 buildText(
//                   title: 'Net total',
//                   value: Utils.formatPrice(netTotal),
//                   unite: true,
//                 ),
//                 buildText(
//                   title: 'Vat ${vatPercent * 100} %',
//                   value: Utils.formatPrice(vat),
//                   unite: true,
//                 ),
//                 Divider(),
//                 buildText(
//                   title: 'Total amount due',
//                   titleStyle: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   value: Utils.formatPrice(total),
//                   unite: true,
//                 ),
//                 SizedBox(height: 2 * PdfPageFormat.mm),
//                 Container(height: 1, color: PdfColors.grey400),
//                 SizedBox(height: 0.5 * PdfPageFormat.mm),
//                 Container(height: 1, color: PdfColors.grey400),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}
