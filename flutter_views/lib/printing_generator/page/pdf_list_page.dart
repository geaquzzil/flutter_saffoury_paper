// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/configrations.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_bill_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_custom_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_invoice_interface.dart';
import 'package:flutter_view_controller/interfaces/settings/ModifiableInterfaceAndPrintingSetting.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/printing_generator/pdf_custom_api.dart';
import 'package:flutter_view_controller/printing_generator/pdf_invoice_api.dart';
import 'package:flutter_view_controller/printing_generator/pdf_list_api.dart';
import 'package:flutter_view_controller/providers/actions/list_multi_key_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:provider/provider.dart';

import '../../interfaces/printable/printable_master.dart';
import '../../models/servers/server_helpers.dart';
import '../pdf_custom_from_pdf_api.dart';
import '../pdf_receipt_api.dart';
// import 'package:webcontent_converter/webcontent_converter.dart';

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

  // bool getBodyWithoutApi() {
  //   bool canGetBody = (widget.invoiceObj as ViewAbstract)
  //           .isRequiredObjectsList()?[ServerActions.view] ==
  //       null;
  //   if (canGetBody) {
  //     debugPrint("BaseEditWidget getBodyWithoutApi skiped");
  //     return true;
  //   }
  //   bool res = (widget.invoiceObj as ViewAbstract).isNew() ||
  //       (widget.invoiceObj as ViewAbstract).isRequiredObjectsListChecker();
  //   debugPrint("BaseEditWidget getBodyWithoutApi result => $res");
  //   return res;
  // }

  // Widget getFutureBody(BuildContext context) {
  //   if (getBodyWithoutApi()) {
  //     return getBody(context);
  //   }
  //   return FutureBuilder(
  //     future: (widget.invoiceObj as ViewAbstract)
  //         .viewCallGetFirstFromList((widget.invoiceObj as ViewAbstract).iD),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.done) {
  //         if (snapshot.data != null) {
  //           widget.invoiceObj = snapshot.data as PrintableMaster;
  //           context
  //               .read<ListMultiKeyProvider>()
  //               .edit(snapshot.data as ViewAbstract);

  //           return getBody(context);
  //         } else {
  //           return EmptyWidget(
  //               lottiUrl:
  //                   "https://assets7.lottiefiles.com/packages/lf20_0s6tfbuc.json",
  //               title: AppLocalizations.of(context)!.cantConnect,
  //               subtitle: AppLocalizations.of(context)!.cantConnectRetry);
  //         }
  //       }
  //       return Center(child: CircularProgressIndicator());
  //     },
  //   );
  // }

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
        loadingWidget: CircularProgressIndicator(),
        // actions: [Icon(Icons.search), Icon(Icons.ac_unit_sharp)],
        // pdfPreviewPageDecoration: BoxDecoration(color: Colors.green),
        useActions: true,

        // shouldRepaint: ,
        build: (format) async {
          T? setting = await getSetting();
          return await PDFListApi(
                  list: widget.list, context: context, setting: setting)
              .generate(format);
        });
  }

  PrintableMaster getFirstObject() {
    return widget.list[0];
  }

  Future<T?> getSetting() async {
    T? pls;
    if (firstObj is ModifiablePrintableInterface) {
      pls = await Configurations.get<T>(
          (firstObj as ModifiablePrintableInterface)
              .getModifibleSettingObject(context),
          customKey: "_printsetting" + firstObj.runtimeType.toString()) as T?;
      if (pls != null) {
        pls = pls.onSavedModiablePrintableLoaded(
            context, firstObj as ViewAbstract);
      }
    }
    return pls;
  }
}
