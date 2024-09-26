// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/globals.dart';
import 'package:flutter_view_controller/interfaces/excelable_reader_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_list_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/lists/headers/filter_icon.dart';
import 'package:flutter_view_controller/new_components/lists/headers/sort_icon.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_main_page.dart';
import 'package:flutter_view_controller/new_screens/controllers/controller_dropbox_list.dart';
import 'package:flutter_view_controller/new_screens/controllers/controller_dropbox_list_icon.dart';
import 'package:flutter_view_controller/new_screens/file_reader/exporter/base_file_exporter_page.dart';
import 'package:flutter_view_controller/new_screens/filterables/horizontal_selected_filterable.dart';
import 'package:flutter_view_controller/new_screens/home/list_to_details_widget_new.dart';
import 'package:flutter_view_controller/new_screens/routes.dart';
import 'package:flutter_view_controller/printing_generator/page/ext.dart';
import 'package:flutter_view_controller/printing_generator/page/pdf_list_page.dart';
import 'package:flutter_view_controller/printing_generator/page/pdf_self_list_page.dart';
import 'package:flutter_view_controller/printing_generator/pdf_list_api.dart';
import 'package:flutter_view_controller/providers/actions/action_viewabstract_provider.dart';
import 'package:flutter_view_controller/providers/actions/list_multi_key_provider.dart';
import 'package:flutter_view_controller/providers/filterables/filterable_provider.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

class FiltersAndSelectionListHeader extends StatelessWidget {
  ViewAbstract viewAbstract;
  String customKey;
  ListMultiKeyProvider listProvider;

  FiltersAndSelectionListHeader(
      {super.key,
      required this.viewAbstract,
      required this.listProvider,
      required this.customKey});

  String findCustomKey() {
    return customKey;
  }

  @override
  Widget build(BuildContext context) {
    Widget? printButton = kIsWeb
        ? null
        : (context
                    .watch<ListMultiKeyProvider>()
                    .getList(findCustomKey())
                    .length >
                2)
            ? getPrintWidget(context)
            : null;

    Widget? filterButton = kIsWeb ? null : getFilterWidget(context);

    Widget? exportButton = kIsWeb
        ? null
        : (context
                    .watch<ListMultiKeyProvider>()
                    .getList(findCustomKey())
                    .length >
                2)
            ? getExportButton(context)
            : null;
    return Container(
      color: kIsWeb ? null : Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                // bottom: kDefaultPadding * .25,
                top: kDefaultPadding * .25,
                left: kDefaultPadding / 2,
                right: kDefaultPadding / 2),
            child: Row(
              children: [
                if (filterButton != null) filterButton,
                SortIcon(
                  viewAbstract: viewAbstract,
                ),
                const Spacer(),
                if (!kIsWeb) getAddBotton(context),
                getRefreshWidget(context),
                if (exportButton != null) exportButton,
                if (printButton != null) printButton
              ],
            ),
          ),
          Selector<FilterableProvider, int>(
            builder: (context, value, child) {
              debugPrint("FiltersAndSelectionListHeader $value");
              if (kIsWeb) return const SizedBox();
              if (value == 0) return const SizedBox();

              return HorizontalFilterableSelectedList(
                onFilterable: const {},
              );
            },
            selector: (p0, p1) => p1.getCount(),
          )
        ],
      ),
    );
  }

  List getList() {
    return listProvider.getList(findCustomKey());
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

  dynamic getFirstObject() {
    List list = listProvider.getList(findCustomKey());
    dynamic first = list[0];
    return first;
  }

  void _refresh(BuildContext context) {
    listProvider.refresh(findCustomKey(), viewAbstract, context: context);
  }

  Widget getRefreshWidget(BuildContext context) => IconButton(
      onPressed: () {
        _refresh(context);
      },
      icon: const Icon(Icons.refresh));

  Widget getAddBotton(BuildContext context) => IconButton(
      onPressed: () {
        viewAbstract.onDrawerLeadingItemClicked(context);
      },
      icon: const Icon(Icons.add));
  Widget? getFilterWidget(BuildContext context) {
    return FilterIcon(
      viewAbstract: viewAbstract,
      onDoneClickedPopResults: (value) {},
    );
  }

  Widget? getExportButton(BuildContext context) {
    var first = getFirstObject();
    if (first is! ExcelableReaderInterace && first is! PrintableMaster) {
      return null;
    }
    return DropdownStringListControllerListenerByIcon(
      icon: Icons.file_upload_outlined,
      hint: AppLocalizations.of(context)!.exportAll,
      showSelectedValueBeside: false,
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
          if (isLargeScreenFromCurrentScreenSize(context)) {
            Globals.keyForLargeScreenListable.currentState
                ?.setSecoundPane(ListToDetailsSecoundPaneHelper(
                    actionTitle: AppLocalizations.of(context)!.exportFile,
                    action: ServerActions.custom_widget,
                    customWidget: FileExporterPage(
                      viewAbstract: viewAbstract,
                      list: listProvider.getList(findCustomKey()).cast(),
                    )));
          } else {
            context.goNamed(exportRouteName, pathParameters: {
              "tableName": viewAbstract.getTableNameApi()!,
              "type": FileExporterPageType.LIST.toString(),
            }, queryParameters: {
              "data": viewAbstract.toJsonViewAbstractList(
                  listProvider.getList(findCustomKey()).cast())
            });
          }
        } else {
          ViewAbstract first = getFirstObject();

          var pdfList = PDFListApi(
              list: listProvider
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
          "${AppLocalizations.of(context)!.printAllAs(viewAbstract.getMainHeaderLabelTextOnly(context))} ${AppLocalizations.of(context)!.action_settings.toLowerCase()}";
      return DropdownStringListControllerListenerByIcon(
        icon: Icons.print,
        showSelectedValueBeside: false,
        hint: AppLocalizations.of(context)!.printType,
        list: [
          DropdownStringListItem(
              icon: Icons.print,
              label: AppLocalizations.of(context)!
                  .printAllAs(AppLocalizations.of(context)!.list)),
          DropdownStringListItem(
              icon: Icons.print,
              label: AppLocalizations.of(context)!.printAllAs(viewAbstract
                  .getMainHeaderLabelTextOnly(context)
                  .toLowerCase())),
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
          } else if (object?.label == printListSetting ||
              object?.label == printSelfListSetting) {
            context.read<ActionViewAbstractProvider>().changeCustomWidget(Card(
                  child: Container(
                      key: UniqueKey(),
                      color: Theme.of(context).colorScheme.surface,
                      child: BaseEditNewPage(
                        // isTheFirst: true,
                        onFabClickedConfirm: (obj) {
                          debugPrint("onFabClickedConfirm $obj");
                          context
                              .read<ActionViewAbstractProvider>()
                              .changeCustomWidget(PdfSelfListPage(
                                  setting: obj as PrintLocalSetting,
                                  list: getList()
                                      .cast<PrintableSelfListInterface>()));
                        },
                        viewAbstract:
                            (viewAbstract as PrintableSelfListInterface)
                                .getModifiablePrintableSelfPdfSetting(context),
                      )),
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
        list: listProvider
            .getList(findCustomKey())
            .whereType<PrintableMaster>()
            .toList()));
  }

  void changeToPrintPdfSelfList(BuildContext context) {
    context
        .read<ActionViewAbstractProvider>()
        .changeCustomWidget(PdfSelfListPage(
          list: listProvider
              .getList(findCustomKey())
              .whereType<PrintableSelfListInterface>()
              .toList(),
        ));
  }
}
