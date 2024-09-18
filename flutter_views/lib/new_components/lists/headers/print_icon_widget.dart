import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/controllers/controller_dropbox_list.dart';
import 'package:flutter_view_controller/new_screens/controllers/controller_dropbox_list_icon.dart';
import 'package:flutter_view_controller/providers/actions/list_multi_key_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class PrintListIconWidget extends StatelessWidget {
  String listKey;
  Function() onPressed;
  bool returnNillIfNull;
  PrintListIconWidget(
      {super.key,
      required this.onPressed,
      this.returnNillIfNull = true,
      required this.listKey});

  @override
  Widget build(BuildContext context) {
    return Selector<ListMultiKeyProvider, List<ViewAbstract>>(
      builder: (context, value, child) {
        return DropdownStringListControllerListenerByIcon(
          icon: Icons.file_upload_outlined,
          hint: AppLocalizations.of(context)!.exportAll,
          list: getListMenuItems(context),
          onSelected: (object) async {
            // if (object?.label ==
            //     AppLocalizations.of(context)!
            //         .exportAllAs(AppLocalizations.of(context)!.excel)) {
            //           Navigator.of(context).pushNamed("/export_files")
            //   context
            //       .read<ActionViewAbstractProvider>()
            //       .changeCustomWidget(FileExporterPage(
            //         viewAbstract: drawerViewAbstractObsever.getObject,
            //         list: listProvider.getList(findCustomKey()).cast(),
            //       ));
            // } else {
            //   ViewAbstract first = getFirstObject();

            //   var pdfList = PDFListApi(
            //       list: listProvider
            //           .getList(findCustomKey())
            //           .whereType<PrintableMaster>()
            //           .toList(),
            //       context: context,
            //       setting: await getSetting(context, getFirstObject()));
            //   Printing.sharePdf(
            //       emails: ["paper@saffoury.com"],
            //       filename: first.getMainHeaderLabelTextOnly(context),
            //       subject: first.getMainHeaderLabelTextOnly(context),
            //       bytes: await pdfList.generate(PdfPageFormat.a4));
            // }

            // if (object?.label ==
            //     AppLocalizations.of(context)!
            //         .printAllAs(AppLocalizations.of(context)!.list)) {
            //   changeToPrintPdfSelfList(context);
            // } else if (object?.label == printListSetting) {
            //   context
            //       .read<ActionViewAbstractProvider>()
            //       .changeCustomWidget(BaseEditNewPage(
            //         onFabClickedConfirm: (obj) {
            //           context.read<ActionViewAbstractProvider>().changeCustomWidget(
            //               PdfSelfListPage(
            //                   setting: obj as PrintLocalSetting,
            //                   list: getList().cast<PrintableSelfListInterface>()));
            //         },
            //         viewAbstract: (drawerViewAbstractObsever.getObject
            //                 as PrintableSelfListInterface)
            //             .getModifiablePrintableSelfPdfSetting(context),
            //       ));
            // } else if (object?.label == printSelfListSetting) {
            // } else {
            //   changeToPrintPdfList(context);
            // }
          },
        );
      },
      selector: (p0, p1) => p1.getList(listKey),
    );
  }

  List<DropdownStringListItem?> getListMenuItems(BuildContext context) {
    return [
      DropdownStringListItem(
          icon: Icons.picture_as_pdf,
          label: AppLocalizations.of(context)!
              .exportAllAs(AppLocalizations.of(context)!.pdf)),
      DropdownStringListItem(
          icon: Icons.source,
          label: AppLocalizations.of(context)!
              .exportAllAs(AppLocalizations.of(context)!.excel)),
    ];
  }
}
