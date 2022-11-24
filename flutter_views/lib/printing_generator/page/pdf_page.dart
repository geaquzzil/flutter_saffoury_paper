import 'package:flutter/material.dart';
import 'package:flutter_view_controller/configrations.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_bill_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_custom_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_invoice_interface.dart';
import 'package:flutter_view_controller/interfaces/settings/ModifiableInterfaceAndPrintingSetting.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/printing_generator/pdf_custom_api.dart';
import 'package:flutter_view_controller/printing_generator/pdf_invoice_api.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../../interfaces/printable/printable_master.dart';
import '../pdf_custom_from_pdf_api.dart';
import '../pdf_receipt_api.dart';
// import 'package:webcontent_converter/webcontent_converter.dart';

class PdfPage<T extends PrintLocalSetting> extends StatefulWidget {
  PrintableMaster<T> invoiceObj;

  PdfPage({super.key, required this.invoiceObj});

  @override
  _PdfPageState createState() => _PdfPageState();
}

class _PdfPageState<T extends PrintLocalSetting> extends State<PdfPage> {
  @override
  Widget build(BuildContext context) {
    Widget body = PdfPreview(
        pdfFileName: widget.invoiceObj.getPrintableQrCodeID(),
        shareActionExtraEmails: const ["info@saffoury.com"],
        initialPageFormat: PdfPageFormat.a4,
        canChangePageFormat: true,
        canChangeOrientation: true,
        // pdfPreviewPageDecoration:
        canDebug: false,
        scrollViewDecoration:
            BoxDecoration(color: Theme.of(context).colorScheme.outline),
        shareActionExtraBody: "shareActionExtraBody",
        dynamicLayout: true,
        // actions: [Icon(Icons.search), Icon(Icons.ac_unit_sharp)],
        // pdfPreviewPageDecoration: BoxDecoration(color: Colors.green),
        useActions: true,

        // shouldRepaint: ,
        build: (format) async {
          if (widget.invoiceObj is PrintableInvoiceInterface) {
            T? pls;
            if (widget.invoiceObj is ModifiablePrintableInterface) {
              pls = await Configurations.get<T>(
                  (widget.invoiceObj as ModifiablePrintableInterface)
                      .getModifibleSettingObject(context),
                  customKey: "_printsetting") as T;
            }
            final pdf = PdfInvoiceApi<PrintableInvoiceInterface, T>(
                context, widget.invoiceObj as PrintableInvoiceInterface,
                printCommand: pls);
            return pdf.generate(format);
          } else if (widget.invoiceObj is PrintableCustomInterface) {
            final pdf = PdfCustom<PrintableCustomInterface, T>(
                context, widget.invoiceObj as PrintableCustomInterface);
            return pdf.generate(format);
          } else if (widget.invoiceObj is PrintableCustomFromPDFInterface) {
            T? pls;
            if (widget.invoiceObj is ModifiablePrintableInterface) {
              pls = await Configurations.get<T>(
                  (widget.invoiceObj as ModifiablePrintableInterface)
                      .getModifibleSettingObject(context),
                  customKey: "_printsetting") as T;
            }
            final pdf = PdfCustomFromPDF<PrintableCustomFromPDFInterface, T>(
                context, widget.invoiceObj as PrintableCustomFromPDFInterface,
                printCommand: pls);
            return pdf.generate(format);
          } else {
            final pdf = PdfReceipt<PrintableReceiptInterface, T>(
                context, widget.invoiceObj as PrintableReceiptInterface);
            return pdf.generate(format);
          }
        });
    return body;
  }
  //   Container(
  //     padding: EdgeInsets.all(32),
  //     child: Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           TitleWidget(
  //             icon: Icons.picture_as_pdf,
  //             text: 'Generate Invoice',
  //           ),
  //           const SizedBox(height: 48),
  //           ButtonWidget(
  //             text: 'Invoice PDF',
  //             onClicked: () async {
  //               final date = DateTime.now();
  //               final dueDate = date.add(Duration(days: 7));
  //               final pdfInvoice =
  //                   PdfInvoiceApi(context, widget.invoiceObj);

  //               final pdfFile = await pdfInvoice.generate();

  //             },
  //           ),
  //         ],
  //       ),
  //     ),
  //   ),
  // );
}

class TitleWidget extends StatelessWidget {
  final IconData icon;
  final String text;

  const TitleWidget({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Icon(icon, size: 100, color: Colors.white),
          const SizedBox(height: 16),
          Text(
            text,
            style: const TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
}

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    Key? key,
    required this.text,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(40),
        ),
        onPressed: onClicked,
        child: FittedBox(
          child: Text(
            text,
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      );
}
