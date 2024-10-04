// ignore_for_file: use_build_context_synchronously

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_view_controller/globals.dart';
import 'dart:typed_data';
import 'package:flutter_view_controller/interfaces/printable/printable_custom_interface.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class PdfCustom<T extends PrintableCustomInterface,
    E extends PrintLocalSetting> {
  material.BuildContext context;
  T printObj;
  E? printCommand;
  PdfCustom(this.context, this.printObj, {this.printCommand});

  Future<pw.ThemeData> getThemeData() async {
    var pathToFile = await rootBundle.load("assets/fonts/materialIcons.ttf");
    final ttf = pw.Font.ttf(pathToFile);
    // PageTheme(theme: )
    return ThemeData.withFont(
      icons: ttf,
      base: Font.ttf(await rootBundle.load("assets/fonts/tr.ttf")),
      bold: Font.ttf(await rootBundle.load("assets/fonts/tb.ttf")),
      italic: Font.ttf(await rootBundle.load("assets/fonts/tm.ttf")),
      boldItalic: Font.ttf(await rootBundle.load("assets/fonts/tb.ttf")),
    );
  }

  Future<Document> getDocumentP(PdfPageFormat? format) async {
    var myTheme = await getThemeData();
    Widget? footer =
        await printObj.getPrintableCustomFooter(context, format: format);
    Widget? header =
        await printObj.getPrintableCustomHeader(context, format: format);

    final pdf = Document(
        title: (printObj as ViewAbstract).getMainHeaderTextOnly(context),
        author: AppLocalizations.of(context)!.appTitle,
        creator: AppLocalizations.of(context)!.appTitle,
        subject: (printObj as ViewAbstract).getMainHeaderLabelTextOnly(context),
        pageMode: PdfPageMode.fullscreen,
        theme: myTheme);
    pdf.addPage(await getPage(format));

    return pdf;
  }

  Future<Uint8List> generate(PdfPageFormat? format) async {
    return (await getDocumentP(format)).save();
  }

  Future<pw.Page> getPage(PdfPageFormat? format) async {
    List<Widget> body = await printObj.getPrintableCustomPage(context,
        format: format, setting: printCommand);
    Widget? watermark = printObj.getPrintableWatermark(format);
    PageTheme pageTheme = PageTheme(
      margin: EdgeInsets.zero,
      pageFormat: format,
      theme: await getThemeData(),
      textDirection:
          Globals.isArabic(context) ? TextDirection.rtl : TextDirection.ltr,
      buildBackground:
          watermark != null ? (Context context) => watermark : null,
    );

    return Page(
        pageTheme: pageTheme,
        // pageFormat: format,
        // margin: EdgeInsets.zero,
        build: (context) => Column(children: body));
  }
}
