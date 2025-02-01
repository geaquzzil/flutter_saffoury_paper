// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart' as material;
import 'package:flutter/services.dart' show Uint8List, rootBundle;
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/printing_generator/ext.dart';
import 'package:flutter_view_controller/printing_generator/pdf_custom_api.dart';
import 'package:flutter_view_controller/printing_generator/pdf_invoice_api.dart';
import 'package:flutter_view_controller/printing_generator/pdf_receipt_api.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../interfaces/printable/printable_bill_interface.dart';
import '../interfaces/printable/printable_custom_interface.dart';
import '../interfaces/printable/printable_invoice_interface.dart';
import '../interfaces/printable/printable_master.dart';
import '../models/prints/print_local_setting.dart';

class PageRange {
  int from;
  int to;
  PageRange({
    required this.from,
    required this.to,
  });
}

class PDFListApi<T extends PrintLocalSetting> {
  List<PrintableMaster<T>> list;
  material.BuildContext context;
  T? setting;
  PageRange? pageRange;

  ///TODO we should update the header when setting is changed;
  Widget? header;
  PDFListApi(
      {required this.list,
      required this.context,
      this.setting,
      this.pageRange});
  Future<ThemeData> getThemeData() async {
    var pathToFile = await rootBundle.load("assets/fonts/materialIcons.ttf");
    final ttf = Font.ttf(pathToFile);
    return ThemeData.withFont(
      icons: ttf,
      base: Font.ttf(await rootBundle.load("assets/fonts/tr.ttf")),
      bold: Font.ttf(await rootBundle.load("assets/fonts/tb.ttf")),
      italic: Font.ttf(await rootBundle.load("assets/fonts/tm.ttf")),
      boldItalic: Font.ttf(await rootBundle.load("assets/fonts/tb.ttf")),
    );
  }

  Future<Uint8List> generate(PdfPageFormat? format,
      {PageRange? pageRange}) async {
    material.debugPrint("generate listApi $format");
    final pdf = Document(
        title:
            "${(list[0] as ViewAbstract).getMainHeaderLabelTextOnly(context)} ${AppLocalizations.of(context)!.list}",
        author: AppLocalizations.of(context)!.appTitle,
        creator: AppLocalizations.of(context)!.appTitle,
        subject: (list[0] as ViewAbstract).getMainHeaderLabelTextOnly(context),
        pageMode: PdfPageMode.fullscreen,
        theme: await getThemeData());

    List<PrintableMaster<T>> l;
    if (pageRange != null) {
      material.debugPrint(
          "generateListOfPage printable List from = ${pageRange.from} to = ${pageRange.to}");
      l = [...list.sublist(pageRange.from, pageRange.to)];
    } else {
      l = [...list];
    }
    material.debugPrint("PDFListApi ${l.length} ");

    await Future.forEach<PrintableMaster<T>>(l, (obj) async {
      if (obj is PrintableInvoiceInterface) {
        final itemPdf = PdfInvoiceApi<PrintableInvoiceInterface, T>(
            context, obj as PrintableInvoiceInterface,
            printCommand: setting);
        header ??= await itemPdf.buildHeader();
        if (printableIsLabel(format: format)) {
          itemPdf.getPageIfLabel(pdf, format).forEach((p) => pdf.addPage(p));
        } else {
          pdf.addPage(itemPdf.getMultiPage(format, header!));
        }
      } else if (obj is PrintableCustomInterface) {
        final itemPdf = PdfCustom<PrintableCustomInterface, T>(
            context, obj as PrintableCustomInterface,
            printCommand: setting);
        pdf.addPage(await itemPdf.getPage(format));
      }
      // else if (obj is PrintableCustomFromPDFInterface) {
      //   final itemPdf = PdfCustomFromPDF<PrintableCustomFromPDFInterface, T>(
      //       context, obj as PrintableCustomFromPDFInterface,
      //       printCommand: setting);

      //   return pdf.generate(format);

      // }
      else {
        final itemPdf = PdfReceipt<PrintableReceiptInterface, T>(
            context, obj as PrintableReceiptInterface,
            printCommand: setting);
        header ??= await itemPdf.buildHeader();
        pdf.addPage(await itemPdf.getPage(format, header!));
      }
    });
    // list.forEach((obj) {});

    return pdf.save();
  }
}
