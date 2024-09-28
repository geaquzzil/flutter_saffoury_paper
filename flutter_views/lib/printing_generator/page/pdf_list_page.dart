// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/printing_generator/pdf_list_api.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

import '../../interfaces/printable/printable_master.dart';
import 'ext.dart';
// import 'package:webcontent_converter/webcontent_converter.dart';

@Deprecated("Use [PdfPageNew]")
class PdfListPage<T extends PrintLocalSetting> extends StatefulWidget {
  List<PrintableMaster<T>> list;

  PdfListPage({super.key, required this.list});

  @override
  State<StatefulWidget> createState() => _PdfListPage();
}

class _PdfListPage<T extends PrintLocalSetting> extends State<PdfListPage<T>> {
  late PrintableMaster<T> firstObj;

  @override
  void initState() {
    super.initState();
    firstObj = widget.list[0];
  }

  @override
  void didUpdateWidget(covariant PdfListPage<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    firstObj = widget.list[0];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    firstObj = widget.list[0];
  }

  @override
  Widget build(BuildContext context) {
    Widget body = getBody(context);
    return body;
  }

  Widget getBody(BuildContext context) {
    // Printing.layoutPdf

    return PdfPreview(
        shareActionExtraEmails: const ["info@saffoury.com"],
        initialPageFormat: PdfPageFormat.a4,
        canChangePageFormat: true,
        canChangeOrientation: true,
        
        // pdfPreviewPageDecoration:
        canDebug: false,
        pageFormats: {
          AppLocalizations.of(context)!.a3ProductLabel: PdfPageFormat.a3,
          AppLocalizations.of(context)!.a4ProductLabel: PdfPageFormat.a4,
          AppLocalizations.of(context)!.a5ProductLabel: PdfPageFormat.a5,
        },
        scrollViewDecoration:
            BoxDecoration(color: Theme.of(context).colorScheme.outline),
        shareActionExtraBody: "shareActionExtraBody",
        dynamicLayout: true,
        loadingWidget: const CircularProgressIndicator(),
        // actions: [Icon(Icons.search), Icon(Icons.ac_unit_sharp)],
        // pdfPreviewPageDecoration: BoxDecoration(color: Colors.green),
        useActions: true,

        // shouldRepaint: ,
        build: (format) async {
          T? setting = await getSetting(context, getFirstObject());
          return await PDFListApi(
                  list: widget.list, context: context, setting: setting)
              .generate(format);
        });
  }

  PrintableMaster getFirstObject() {
    return widget.list[0];
  }
}
