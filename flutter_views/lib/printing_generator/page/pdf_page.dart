import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/prints/print_commad_abstract.dart';
import 'package:flutter_view_controller/printing_generator/pdf_invoice_api.dart';
import 'package:printing/printing.dart';

import '../pdf_api.dart';

class PdfPage extends StatefulWidget {
  InvoiceGenerator invoiceObj;

  PdfPage({super.key, required this.invoiceObj});

  @override
  _PdfPageState createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("title"),
        centerTitle: true,
      ),
      body: PdfPreview(build: (format) async {
        final pdf = PdfInvoiceApi(context, widget.invoiceObj);
        return pdf.generate();
      }
          // await Printing.convertHtml(html: snapshot.data.body)

          ));

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
            style: TextStyle(
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
          minimumSize: Size.fromHeight(40),
        ),
        child: FittedBox(
          child: Text(
            text,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
        onPressed: onClicked,
      );
}
