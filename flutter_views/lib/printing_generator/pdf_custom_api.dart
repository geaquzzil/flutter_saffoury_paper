import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';
import 'package:flutter_view_controller/interfaces/printable/printable_custom_interface.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:flutter/material.dart' as material;
import 'package:printing/printing.dart';

class PdfCustom<T extends PrintableCustomInterface,
    E extends PrintLocalSetting> {
  material.BuildContext context;
  T printObj;
  E? printCommand;
  PdfCustom(this.context, this.printObj, {this.printCommand});

  Future<pw.ThemeData> getThemeData() async {
    var pathToFile = await rootBundle.load("assets/fonts/materialIcons.ttf");
    final ttf = pw.Font.ttf(pathToFile);
    return ThemeData.withFont(
        icons: ttf,
        base: await PdfGoogleFonts.tajawalRegular(),
        bold: await PdfGoogleFonts.tajawalBold(),
        italic: await PdfGoogleFonts.tajawalMedium(),
        boldItalic: await PdfGoogleFonts.tajawalBold());
  }

  Future<Uint8List> generate(PdfPageFormat? format) async {
    var myTheme = await getThemeData();
    Widget? footer =
        await printObj.getPrintableCustomFooter(context, format: format);
    Widget? header =
        await printObj.getPrintableCustomHeader(context, format: format);

    final pdf = Document(
        title: "TEST", pageMode: PdfPageMode.fullscreen, theme: myTheme);
    pdf.addPage(await getPage(format));
    return pdf.save();
  }

  Future<pw.Page> getPage(PdfPageFormat? format) async {
    List<Widget> body =
        await printObj.getPrintableCustomPage(context, format: format);
    return Page(
      pageFormat: format,
      margin: EdgeInsets.zero,
      build: (context) => Column(children: body),
    );
  }
}
