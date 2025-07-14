// ignore_for_file: use_build_context_synchronously

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_view_controller/globals.dart';
import 'dart:typed_data';
import 'package:flutter_view_controller/interfaces/printable/printable_custom_interface.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:flutter/material.dart' as material;

class PdfCustomFromPDF<T extends PrintableCustomFromPDFInterface,
    E extends PrintLocalSetting> {
  material.BuildContext context;
  T printObj;
  E? printCommand;
  PdfCustomFromPDF(this.context, this.printObj, {this.printCommand});

  Future<pw.ThemeData> getThemeData() async {
    var pathToFile = await rootBundle.load("assets/fonts/materialIcons.ttf");
    final ttf = pw.Font.ttf(pathToFile);
    return ThemeData.withFont(
      icons: ttf,
      base: Font.ttf(await rootBundle.load("assets/fonts/tr.ttf")),
      bold: Font.ttf(await rootBundle.load("assets/fonts/tb.ttf")),
      italic: Font.ttf(await rootBundle.load("assets/fonts/tm.ttf")),
      boldItalic: Font.ttf(await rootBundle.load("assets/fonts/tb.ttf")),
    );
  }

  Future<Uint8List> generate(PdfPageFormat? format) async {
    return (await getDocumentP(format)).save();
  }

  Future<pw.Document> getDocumentP(PdfPageFormat? format) async {
    var myTheme = await getThemeData();
    Widget? watermark = printObj.getPrintableWatermark(format);
    PageTheme pageTheme = PageTheme(
      margin: EdgeInsets.zero,
      pageFormat: format,
      theme: myTheme,
      textDirection:
          Globals.isArabic(context) ? TextDirection.rtl : TextDirection.ltr,
      buildBackground:
          watermark != null ? (Context context) => watermark : null,
      // buildForeground: (Context context) => Align(
      //   alignment: Alignment.bottomLeft,
      //   child: SizedBox(
      //     width: 100,
      //     height: 100,
      //     child: PdfLogo(),
      //   ),
      // ),
    );
    return (await printObj.getPrintableCustomFromPDFPage(context,
        format: format,
        setting: printCommand,
        theme: pageTheme,
        themeData: myTheme));
  }
}
