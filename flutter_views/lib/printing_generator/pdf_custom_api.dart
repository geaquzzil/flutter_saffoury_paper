import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';
import 'package:flutter_view_controller/interfaces/printable/printable_custom_interface.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:flutter/material.dart' as material;
import 'package:printing/printing.dart';
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
        title: (printObj as ViewAbstract).getMainHeaderTextOnly(context),
        author: AppLocalizations.of(context)!.appTitle,
        creator: AppLocalizations.of(context)!.appTitle,
        subject: (printObj as ViewAbstract).getMainHeaderLabelTextOnly(context),
        pageMode: PdfPageMode.fullscreen,
        theme: myTheme);
    pdf.addPage(await getPage(format));

    return pdf.save();
  }

  Future<pw.Page> getPage(PdfPageFormat? format) async {
    List<Widget> body = await printObj.getPrintableCustomPage(context,
        format: format, setting: printCommand);
    String? watermark = printObj.getPrintableWatermark();
    dynamic pageTheme = PageTheme(
      margin: EdgeInsets.zero,
      pageFormat: format,
      buildBackground: watermark != null
          ? (Context context) => FullPage(
                ignoreMargins: true,
                child: Watermark.text('SAFFOURY',
                    fit: BoxFit.scaleDown,
                    // angle: 0,
                    style: TextStyle.defaultStyle().copyWith(
                      fontSize: 80,
                      color: PdfColors.grey200,
                      fontWeight: FontWeight.bold,
                    )),
              )
          : null,
      // buildForeground: (Context context) => Align(
      //   alignment: Alignment.bottomLeft,
      //   child: SizedBox(
      //     width: 100,
      //     height: 100,
      //     child: PdfLogo(),
      //   ),
      // ),
    );

    return Page(
        pageTheme: pageTheme,
        // pageFormat: format,
        // margin: EdgeInsets.zero,
        build: (context) => Column(children: body));
  }
}
