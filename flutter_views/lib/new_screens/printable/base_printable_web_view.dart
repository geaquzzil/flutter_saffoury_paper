import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/prints/print_commad_abstract.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

class BasePrintableViewWidget extends StatelessWidget {
  ViewAbstract printObject;
  PrintCommandAbstract printCommand;
  BasePrintableViewWidget(
      {super.key, required this.printCommand, required this.printObject});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            color: Colors.black,
            icon: const Icon(Icons.arrow_back_ios),
            iconSize: 20.0,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
        ),
        body: FutureBuilder(
            future: printObject.printCall(printCommand,context: context),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                
                // return TextButton(
                //     onPressed: () => {generatePdf(snapshot.data)},
                //     child: const Text("dsa"));
                return PdfPreview(
                    build: (format) async => snapshot.data.bodyBytes
                    // await Printing.convertHtml(html: snapshot.data.body)

                    );

                //  snapshot.data.bodyBytes);
              }
              return Center(
                child: Lottie.network(
                    "https://assets7.lottiefiles.com/packages/lf20_vy250I.json"),
              );
            }));
  }

  void generatePdf(Response response) async {
    debugPrint("Generating ${response.body}");
    var pdfData = response.bodyBytes;
    await Printing.layoutPdf(
        onLayout: (format) async => Printing.convertHtml(
            baseUrl: URLS.getBaseUrlPrint(),
            html: response.body,
            format: PdfPageFormat.a4));
  }

//   Future<Uint8List> _generatePdf(PdfPageFormat format, Response response) async {

//     final doc = pw.Document();
//     doc.document
//   await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdfData);
// }
}


//   Future<Uint8List> _generatePdf(PdfPageFormat format, String data) async {
// var dir = await getApplicationDocumentsDirectory();
// var savedPath = join(dir.path, "sample.pdf");
// var result = await WebcontentConverter.contentToPDF(
//     content: data,
//     savedPath: savedPath,
//     format: PaperFormat.a4,
//     margins: PdfMargins.px(top: 55, bottom: 55, right: 55, left: 55),
// );

// final pdf = await rootBundle.load('document.pdf');
// await Printing.layoutPdf(onLayout: (_) => pdf.buffer.asUint8List());

// var result = await WebcontentConverter.webUriToImage(
//     uri: "http://127.0.0.1:5500/example/assets/invoice.html",
//     savedPath: savedPath,
//     format: PaperFormat.a4,
//     margins: PdfMargins.px(top: 35, bottom: 35, right: 35, left: 35),
// );
//      var result = await WebcontentConverter.contentToImage(
//     content: data,
// );
//     final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);

//     final font = await PdfGoogleFonts.nunitoExtraLight();

//     // await Printing.layoutPdf(
//     //     onLayout: (PdfPageFormat format) async => await Printing.convertHtml(
//     //           format: format,
//     //           html: '<html><body><p>Hello!</p></body></html>',
//     //         ));
//   pdf.addPage(pw.Page(
//     build: (pw.Context context) {
//       return pw.Center(
//         child: pw.Image(result),
//       ); // Center
//     }));

//     return pdf.save();
//   }
// }
