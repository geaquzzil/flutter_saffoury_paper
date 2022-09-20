import 'package:easy_web_view/easy_web_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:flutter_view_controller/models/prints/print_commad_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:lottie/lottie.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

class BasePrintableViewWidget extends StatelessWidget {
  ViewAbstract printObject;
  PrintCommandAbstract printCommand;
  BasePrintableViewWidget(
      {Key? key, required this.printCommand, required this.printObject})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: printObject.printCall(printCommand),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // return EasyWebView(
                //   width: double.infinity,
                //   height: double.infinity,
                //   isMarkdown: false,
                //   onLoaded: ((controller) {}),
                //   src: snapshot.data.toString(),
                //   // options: WebViewOptions(
                //   //   crossWindowEvents: [
                //   //     CrossWindowEvent(
                //   //       name: 'ParentChannel',
                //   //       eventAction: (eventMessage) async {
                //   //         if (eventMessage is Map) {
                //   //           final id = eventMessage['id'];
                //   //           if (id == 'htmltopdf') {
                //   //             final res = eventMessage['result'];
                //   //             // log(res.runtimeType.toString());
                //   //             if (res is Uint8List) {
                //   //               // final pdfResult = utf8.decode(res);
                //   //               if (kIsWeb) {
                //   //                 //   await FileSaver.instance.saveFile(
                //   //                 //     'easy_web_view_invoice',
                //   //                 //     res,
                //   //                 //     'pdf',
                //   //                 //     mimeType: MimeType.PDF,
                //   //                 //   );
                //   //                 // } else {
                //   //                 //   await FileSaver.instance.saveAs(
                //   //                 //     'easy_web_view_invoice',
                //   //                 //     res,
                //   //                 //     'pdf',
                //   //                 //     MimeType.PDF,
                //   //                 //   );
                //   //                 // }

                //   //                 // log(res.runtimeType.toString());
                //   //               }
                //   //             }
                //   //           }
                //   //           // log('Event message: $eventMessage');
                //   //         }
                //   //       },
                //   //     ),
                //   //   ],
                //   // )

                //   //  Uri.dataFromString(snapshot.data.toString(),
                //   //         mimeType: 'text/html',
                //   //         encoding: Encoding.getByName('utf-8'))
                //   //     .toString(),
                // );
                // // return Html(data: snapshot.data.toString());
                // FlutterHtmlToPdf.convertFromHtmlContent(
                //     '<html><body><p>Hello!</p></body></html>', "", "s.pdf");
                return PdfPreview(
                    build: (format) async => await Printing.convertHtml(
                          format: format,
                          html: '<html><body><p>Hello!</p></body></html>',
                        ));
              }
              return Lottie.network(
                  "https://assets3.lottiefiles.com/packages/lf20_mr1olA.json");
            }));
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, String data) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);

    final font = await PdfGoogleFonts.nunitoExtraLight();

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => await Printing.convertHtml(
              format: format,
              html: '<html><body><p>Hello!</p></body></html>',
            ));
    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            children: [
              pw.SizedBox(
                width: double.infinity,
                child: pw.FittedBox(
                  child: pw.Text("title", style: pw.TextStyle(font: font)),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Flexible(child: pw.FlutterLogo())
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}
