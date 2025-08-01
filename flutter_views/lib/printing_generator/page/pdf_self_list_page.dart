// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/configrations.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_list_interface.dart';
import 'package:flutter_view_controller/interfaces/settings/ModifiableInterfaceAndPrintingSetting.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/printing_generator/pdf_self_list_api.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

// import 'package:webcontent_converter/webcontent_converter.dart';

@Deprecated("Use [PdfPageNew]")
class PdfSelfListPage<T extends PrintLocalSetting> extends StatefulWidget {
  List<PrintableSelfListInterface<T>> list;
  T? setting;

  PdfSelfListPage({super.key, required this.list, this.setting});

  @override
  State<StatefulWidget> createState() => _PdfSelfListPage();
}

class _PdfSelfListPage<T extends PrintLocalSetting>
    extends State<PdfSelfListPage<T>> {
  late PrintableSelfListInterface firstObj;

  @override
  void initState() {
    super.initState();
    firstObj = widget.list[0];
  }

  @override
  void didUpdateWidget(covariant PdfSelfListPage<T> oldWidget) {
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
          // PrintLocalSetting? setting = await getSetting();
          return await PdfSelfListApi<T>(widget.list, context, firstObj,
                  printCommand: widget.setting)
              .generate(format);
        });
  }

  PrintableSelfListInterface getFirstObject() {
    return widget.list[0];
  }

  Future<T?> getSetting() async {
    T? pls;
    if (firstObj is ModifiableInterface) {
      pls = await Configurations.get<T>(await (firstObj as ModifiableInterface)
          .getModifibleSettingObject(context) as T);
      if (pls != null) {
        pls = pls.onSavedModiablePrintableLoaded(
            context, firstObj as ViewAbstract);
      }
    }
    return pls;
  }
}
