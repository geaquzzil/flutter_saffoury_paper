import 'package:flutter/material.dart';
import 'package:flutter_view_controller/interfaces/printable_interface.dart';
import 'package:flutter_view_controller/printing_generator/pdf_invoice_api.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
// import 'package:webcontent_converter/webcontent_converter.dart';

class PdfPage extends StatefulWidget {
  PrintableInterface invoiceObj;

  PdfPage({super.key, required this.invoiceObj});

  @override
  _PdfPageState createState() => _PdfPageState();
}
// void printPage() async {
//   // get the html from the current page
//   String html = await _controller.runJavascriptReturningResult(
//       "encodeURIComponent(document.documentElement.outerHTML)");
//   html = Uri.decodeComponent(html);
//   // there would be `"` at the beginning and the end, so remove it
//   html = html.substring(1, html.length - 1);

//   // get the pdf of the html
//   final pdf = await Printing.convertHtml(
//     format: const PdfPageFormat(
//       100 * PdfPageFormat.mm,
//       50 * PdfPageFormat.mm,
//       // marginLeft: 5 * PdfPageFormat.mm,
//       // marginRight: 5 * PdfPageFormat.mm,
//     ),
//     html: htmlStr,
//   );
//   // the dpi is the resolution of the pdf, it's important if the page size is small, otherwise you can ignore it
//   const dpi = 288.0;

//   // transform pdf to image so you can print it directly
//   await for (var page in Printing.raster(pdf, dpi: dpi)) {
//     final imgData = await page.toPng();
//     // personally I'm using sunmi printer, you'll need to change to your personnel function
//     await SunmiPrinter.printImage(Uint8List.fromList(imgData));
//   }
// }
class _PdfPageState extends State<PdfPage> {
  // Widget getWebContentConverter(BuildContext context) {
  //   return FutureBuilder<Uint8List?>(
  //     builder: (context, snapshot) {
  //       return PdfPreview(build: (format) async {
  //         final pdf = PdfInvoiceApi(context, widget.invoiceObj);
  //         return pdf.generateFromImage(snapshot.data);
  //       }
  //           // await Printing.convertHtml(html: snapshot.data.body)

  //           );
  //     },
  //     future: WebcontentConverter.webUriToImage(
  //         uri: "https://www.saffoury.com/SaffouryPaper2/print/index.php"),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    Widget body = PdfPreview(
        pdfFileName: widget.invoiceObj.getInvoiceQrCodeID(),
        shareActionExtraEmails: ["info@saffoury.com"],
        initialPageFormat: PdfPageFormat.a4,
        canChangePageFormat: true,
        canChangeOrientation: true,
        // shouldRepaint: ,
        build: (format) async {
          final pdf = PdfInvoiceApi(context, widget.invoiceObj);
          return pdf.generate(format);
        });
    // Widget body = EasyWebView(
    //   onLoaded: (controller) {
    //     // controller.postMessageWeb(message, targetOrigin)
    //   },
    //   src: "https://www.saffoury.com/SaffouryPaper2/print/index.php",
    // );

    // Text("DSA");
    // Widget body = getWebContentConverter(context);

    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text("title"),
          centerTitle: true,
        ),
        body: body);
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
