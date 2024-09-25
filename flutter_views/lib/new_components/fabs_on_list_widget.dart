// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_view_controller/interfaces/excelable_reader_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_list_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_main_page.dart';
import 'package:flutter_view_controller/new_screens/controllers/controller_dropbox_list.dart';
import 'package:flutter_view_controller/new_screens/controllers/controller_dropbox_list_icon.dart';
import 'package:flutter_view_controller/new_screens/file_reader/exporter/base_file_exporter_page.dart';
import 'package:flutter_view_controller/printing_generator/page/ext.dart';
import 'package:flutter_view_controller/printing_generator/page/pdf_list_page.dart';
import 'package:flutter_view_controller/printing_generator/page/pdf_self_list_page.dart';
import 'package:flutter_view_controller/printing_generator/pdf_list_api.dart';
import 'package:flutter_view_controller/providers/actions/action_viewabstract_provider.dart';
import 'package:flutter_view_controller/providers/actions/list_multi_key_provider.dart';
import 'package:flutter_view_controller/providers/filterables/filterable_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../providers/drawer/drawer_controler.dart';

class FabsOnListWidget extends StatefulWidget {
  String customKey;
  ListMultiKeyProvider listProvider;

  FabsOnListWidget(
      {super.key, required this.listProvider, required this.customKey});

  @override
  State<FabsOnListWidget> createState() => FabsOnListWidgetState();
}

class FabsOnListWidgetState extends State<FabsOnListWidget> {
  late DrawerMenuControllerProvider drawerViewAbstractObsever;

  var isDialOpen = ValueNotifier<bool>(false);

  var extend = false;

  String findCustomKey() {
    return widget.customKey;
  }

  @override
  Widget build(BuildContext context) {
    drawerViewAbstractObsever =
        Provider.of<DrawerMenuControllerProvider>(context, listen: false);
    Widget? printButton =
        (context.watch<ListMultiKeyProvider>().getList(findCustomKey()).length >
                2)
            ? getPrintWidget(context)
            : null;

    Widget? filterButton =
        (context.watch<ListMultiKeyProvider>().getList(findCustomKey()).length >
                2)
            ? getFilterWidget(context)
            : null;

    Widget? exportButton =
        (context.watch<ListMultiKeyProvider>().getList(findCustomKey()).length >
                2)
            ? getExportButton(context)
            : null;

    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close,
      spacing: 3,
      mini: false,
      openCloseDial: isDialOpen,
      childPadding: const EdgeInsets.all(5),
      spaceBetweenChildren: 4,

      buttonSize: const Size(
          56.0, 56.0), // it's the SpeedDial size which defaults to 56 itself
      // iconTheme: IconThemeData(size: 22),
      label:
          extend ? const Text("Open") : null, // The label of the main button.
      /// The active label of the main button, Defaults to label if not specified.
      activeLabel: extend ? const Text("Close") : null,
      tooltip: 'Open Speed Dial',
      heroTag: 'speed-dial-hero-tag',
      elevation: 8.0,
      animationCurve: Curves.elasticInOut,
      isOpenOnStart: false,
      // direction: SpeedDialDirection.left,
      // shape: const RoundedRectangleBorder(),
      children: [
        getAddBotton(context),
        SpeedDialChild(
          child: const Icon(Icons.brush),
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.white,
          label: 'Second',
          onTap: () => debugPrint('SECOND CHILD'),
        ),
        SpeedDialChild(
          child: const Icon(Icons.margin),
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          label: 'Show Snackbar',
          visible: true,
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(("Third Child Pressed")))),
          onLongPress: () => debugPrint('THIRD CHILD LONG PRESS'),
        ),
      ],
      // : const StadiumBorder(),
    );
    // return Column(
    //   children: [
    //     Padding(
    //       padding: const EdgeInsets.only(
    //           bottom: kDefaultPadding / 2,
    //           left: kDefaultPadding / 2,
    //           right: kDefaultPadding / 2),
    //       child: Row(
    //         children: [
    //           if (filterButton != null) filterButton,
    //           DropdownStringListControllerListenerByIcon(
    //               icon: Icons.sort_by_alpha,
    //               hint: AppLocalizations.of(context)!.sortBy,
    //               list: drawerViewAbstractObsever.getObject
    //                   .getMainFieldsIconsAndValues(context),
    //               onSelected: (obj) {
    //                 debugPrint("is selected ${obj.runtimeType}");
    //                 if (obj == null) {
    //                   removeFilterableSelected(
    //                       context, drawerViewAbstractObsever.getObject);
    //                 } else {
    //                   listProvider.clear(findCustomKey());
    //                   addFilterableSortField(
    //                       context, obj.value.toString(), obj.label);
    //                 }
    //                 notifyListApi(context);
    //                 debugPrint("is selected $obj");
    //               }),
    //           DropdownEnumControllerListenerByIcon<SortByType>(
    //             viewAbstractEnum: SortByType.ASC,
    //             onSelected: (object) {
    //               // listProvider.clear(findCustomKey());
    //               addFilterableSort(context, object as SortByType);
    //               notifyListApi(context);
    //             },
    //           ),
    //           const Spacer(),
    //           getAddBotton(context),
    //           getRefreshWidget(),
    //           if (exportButton != null) exportButton,
    //           if (printButton != null) printButton
    //         ],
    //       ),
    //     ),
    //     if (hasFilterable(context)) HorizontalFilterableSelectedList(),
    //   ],
    // );
  }

  List getList() {
    return widget.listProvider.getList(findCustomKey());
  }

  bool hasItems() {
    List l = getList();
    return l.isNotEmpty && l.length > 2;
  }

  bool hasPrintWidget() {
    if (!hasItems()) return false;
    var first = getFirstObject();

    return first is PrintableSelfListInterface || first is PrintableMaster;
  }

  bool hasFilterable(BuildContext context) {
    return context
        .watch<FilterableProvider>()
        .getList
        .values
        .toList()
        .isNotEmpty;
  }

  dynamic getFirstObject() {
    List list = widget.listProvider.getList(findCustomKey());
    dynamic first = list[0];
    return first;
  }

  void _refresh() {
    widget.listProvider.refresh(
        findCustomKey(), drawerViewAbstractObsever.getObjectCastViewAbstract);
  }

  Widget getRefreshWidget() => IconButton(
      onPressed: () {
        _refresh();
      },
      icon: const Icon(Icons.refresh));

  SpeedDialChild getAddBotton(BuildContext context) {
    return SpeedDialChild(
      child: const Icon(Icons.add),
      backgroundColor:
          drawerViewAbstractObsever.getObjectCastViewAbstract.getMainColor(),
      foregroundColor: Colors.white,
      label: drawerViewAbstractObsever.getObjectCastViewAbstract
          .getBaseTitle(context, serverAction: ServerActions.add),
      onTap: () {
        drawerViewAbstractObsever.getObjectCastViewAbstract
            .onDrawerLeadingItemClicked(context);
      },
      onLongPress: () => debugPrint('FIRST CHILD LONG PRESS'),
    );
  }

  Widget? getFilterWidget(BuildContext context) {
    return null;
  }

  Widget? getExportButton(BuildContext context) {
    var first = getFirstObject();
    if (first is! ExcelableReaderInterace && first is! PrintableMaster) {
      return null;
    }
    return DropdownStringListControllerListenerByIcon(
      icon: Icons.file_upload_outlined,
      hint: AppLocalizations.of(context)!.exportAll,
      list: [
        DropdownStringListItem(
            icon: Icons.picture_as_pdf,
            label: AppLocalizations.of(context)!
                .exportAllAs(AppLocalizations.of(context)!.pdf)),
        DropdownStringListItem(
            icon: Icons.source,
            label: AppLocalizations.of(context)!
                .exportAllAs(AppLocalizations.of(context)!.excel)),
      ],
      onSelected: (object) async {
        if (object?.label ==
            AppLocalizations.of(context)!
                .exportAllAs(AppLocalizations.of(context)!.excel)) {
          context
              .read<ActionViewAbstractProvider>()
              .changeCustomWidget(FileExporterPage(
                viewAbstract:
                    drawerViewAbstractObsever.getObjectCastViewAbstract,
                list: widget.listProvider.getList(findCustomKey()).cast(),
              ));
        } else {
          ViewAbstract first = getFirstObject();

          var pdfList = PDFListApi(
              list: widget.listProvider
                  .getList(findCustomKey())
                  .whereType<PrintableMaster>()
                  .toList(),
              context: context,
              setting: await getSetting(context, getFirstObject()));
          Printing.sharePdf(
              emails: ["paper@saffoury.com"],
              filename: first.getMainHeaderLabelTextOnly(context),
              subject: first.getMainHeaderLabelTextOnly(context),
              bytes: await pdfList.generate(PdfPageFormat.a4));
        }
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
  }

  Widget? getPrintWidget(BuildContext context) {
    var first = getFirstObject();
    if (first is PrintableSelfListInterface && first is PrintableMaster) {
      String? printListSetting =
          "${AppLocalizations.of(context)!.printAllAs(AppLocalizations.of(context)!.list)} ${AppLocalizations.of(context)!.action_settings.toLowerCase()}";

      String? printSelfListSetting =
          "${AppLocalizations.of(context)!.printAllAs(drawerViewAbstractObsever.getObjectCastViewAbstract.getMainHeaderLabelTextOnly(context))} ${AppLocalizations.of(context)!.action_settings.toLowerCase()}";
      return DropdownStringListControllerListenerByIcon(
        icon: Icons.print,
        hint: AppLocalizations.of(context)!.printType,
        list: [
          DropdownStringListItem(
              icon: Icons.print,
              label: AppLocalizations.of(context)!
                  .printAllAs(AppLocalizations.of(context)!.list)),
          DropdownStringListItem(
              icon: Icons.print,
              label: AppLocalizations.of(context)!.printAllAs(
                  drawerViewAbstractObsever.getObjectCastViewAbstract
                      .getMainHeaderLabelTextOnly(context))),
          DropdownStringListItem(
              icon: Icons.settings,
              enabled: false,
              label: AppLocalizations.of(context)!.printerSetting),
          DropdownStringListItem(icon: Icons.settings, label: printListSetting),
          DropdownStringListItem(
              icon: Icons.settings, label: printSelfListSetting),
        ],
        onSelected: (object) {
          if (object?.label ==
              AppLocalizations.of(context)!
                  .printAllAs(AppLocalizations.of(context)!.list)) {
            changeToPrintPdfSelfList(context);
          } else if (object?.label == printListSetting) {
            context
                .read<ActionViewAbstractProvider>()
                .changeCustomWidget(BaseEditNewPage(
                  onFabClickedConfirm: (obj) {
                    context
                        .read<ActionViewAbstractProvider>()
                        .changeCustomWidget(PdfSelfListPage(
                            setting: obj as PrintLocalSetting,
                            list:
                                getList().cast<PrintableSelfListInterface>()));
                  },
                  viewAbstract:
                      (drawerViewAbstractObsever.getObjectCastViewAbstract
                              as PrintableSelfListInterface)
                          .getModifiablePrintableSelfPdfSetting(context),
                ));
          } else if (object?.label == printSelfListSetting) {
          } else {
            changeToPrintPdfList(context);
          }
        },
      );
    }
    if (first is PrintableMaster) {
      return IconButton(
          onPressed: () {
            changeToPrintPdfList(context);
          },
          icon: const Icon(Icons.print));
    } else if (first is PrintableSelfListInterface) {
      return IconButton(
          onPressed: () {
            changeToPrintPdfSelfList(context);
          },
          icon: const Icon(Icons.print));
    } else {
      return null;
    }
  }

  void changeToPrintPdfList(BuildContext context) {
    context.read<ActionViewAbstractProvider>().changeCustomWidget(PdfListPage(
        list: widget.listProvider
            .getList(findCustomKey())
            .whereType<PrintableMaster>()
            .toList()));
  }

  void changeToPrintPdfSelfList(BuildContext context) {
    context
        .read<ActionViewAbstractProvider>()
        .changeCustomWidget(PdfSelfListPage(
          list: widget.listProvider
              .getList(findCustomKey())
              .whereType<PrintableSelfListInterface>()
              .toList(),
        ));
  }
}
