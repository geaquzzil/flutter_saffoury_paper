import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/components/prints/paper_list_controller.dart';
import 'package:flutter_view_controller/components/prints/paper_oriantation_controller.dart';
import 'package:flutter_view_controller/configrations.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/new_components/cards/clipper_card.dart';
import 'package:flutter_view_controller/new_components/fabs/floating_action_button_extended.dart';
import 'package:flutter_view_controller/new_components/lists/skeletonizer/stylings.dart';
import 'package:flutter_view_controller/new_components/lists/skeletonizer/widgets.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_main_page.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_new.dart';
import 'package:flutter_view_controller/new_screens/base_page.dart';
import 'package:flutter_view_controller/new_screens/file_reader/exporter/base_file_exporter_page.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/new_screens/theme.dart';
import 'package:flutter_view_controller/printing_generator/page/base_pdf_page.dart';
import 'package:flutter_view_controller/printing_generator/page/ext.dart';
import 'package:flutter_view_controller/printing_generator/pdf_list_api.dart';
import 'package:flutter_view_controller/printing_generator/pdf_self_list_api.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:flutter_view_controller/utils/dialogs.dart';
import 'package:go_router/go_router.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:tuple/tuple.dart';

class PrintNew<T extends PrintLocalSetting> extends BasePageApi {
  bool buildBaseHeader;
  List<PrintableMaster>? asList;
  PrintPageType? type;
  T? customSetting;

  PrintNew(
      {super.key,
      super.iD,
      super.extras,
      super.tableName,
      this.buildBaseHeader = false,
      this.asList,
      this.type,
      this.customSetting,
      super.buildSecondPane,
      super.isFirstToSecOrThirdPane,
      super.buildDrawer = false});

  @override
  State<PrintNew> createState() => _PrintNewState();
}

class LoadedPrint {
  String viewAbstract;
  String setting;
  PdfPageFormat format;
  LoadedPrint(
      {required this.viewAbstract,
      required this.setting,
      required this.format});
  @override
  bool operator ==(Object other) {
    return other is LoadedPrint &&
        other.setting == setting &&
        other.viewAbstract == viewAbstract &&
        other.format == format;
  }

  @override
  String toString() {
    return "LoadedPrint $viewAbstract\n$setting\n$format";
  }

  @override
  int get hashCode => Object.hash(setting, viewAbstract, format);
}

class _PrintNewState extends BasePageWithApi<PrintNew>
    with BasePageSecoundPaneNotifierState<PrintNew> {
  late Future<Uint8List> loadedFile;
  Uint8List? loadedFileBytes;
  late PrintSettingLargeScreenProvider printSettingListener;
  late List<Printer> localPrinters;
  LoadedPrint? _lastLoaded;
  List<Printer>? _loadedPrinters;

  Printer? defaultPrinter;

  Widget getPrintShareFloating(BuildContext context) {
    return FloatingActionButton.small(
        heroTag: UniqueKey(),
        child: const Icon(Icons.share),
        onPressed: () async {
          await Printing.sharePdf(bytes: loadedFileBytes!);
        });
  }

  Widget getPrintFloating(BuildContext context) {
    return FloatingActionButton(
        heroTag: UniqueKey(),
        child: const Icon(Icons.print),
        onPressed: () async {
          if (await getExtrasCast().directPrint(
              format: context
                  .read<PrintSettingLargeScreenProvider>()
                  .getSelectedFormat,
              context: context,
              printer: defaultPrinter,
              onLayout: (PdfPageFormat format) async => loadedFile)) {
            await Printing.layoutPdf(
                onLayout: (PdfPageFormat format) async => loadedFile);
          }
        });
  }

  @override
  Future<void>? getPaneIsRefreshIndicator({required bool firstPane}) {
    return null;
  }

  Widget getPrintAdvancedFloating() {
    return FloatingActionButton(
        heroTag: UniqueKey(),
        child: const Icon(Icons.settings),
        onPressed: () async {
          var v = await getSettingFuture();
          await showFullScreenDialogExt<ViewAbstract?>(
              barrierDismissible: true,
              anchorPoint: const Offset(1000, 1000),
              context: context,
              builder: (p0) {
                return BaseEditNewPage(
                  viewAbstract: v as ViewAbstract,
                  onFabClickedConfirm: (viewAbstract) {
                    if (viewAbstract != null) {
                      debugPrint(
                          "BasePdfPageConsumer newViewAbstract $viewAbstract");
                      // notifyNewViewAbstract(viewAbstract.getCopyInstance());
                      Configurations.saveViewAbstract(viewAbstract);
                      printSettingListener.setViewAbstract = viewAbstract;
                      context.pop();
                    }
                  },
                );
              }).then((value) {
            {
              if (value != null) {}
              debugPrint("getEditDialog result $value");
            }
          });
        });
  }

  void notifyToggleFloatingButton(BuildContext context, {bool? isExpaned}) {
    if (isExpaned != null) {
      printSettingListener.setFloatActionIsExpanded = isExpaned;
    }
    printSettingListener.toggleFloatingActionIsExpanded();
  }

  void notifyNewSelectedFormat(
      BuildContext context, PdfPageFormat selectedFormat) {
    printSettingListener.setSelectedFormat = selectedFormat;
  }

  double getSizeOfController() {
    return getWidth * .4;
  }

  FloatingActionButtonExtended getPrintPageOptions() {
    return FloatingActionButtonExtended(
        colapsed: Icons.note_add,
        onExpandIcon: Icons.arrow_forward_ios_rounded,
        onPress: () {},
        onToggle: () {
          notifyToggleFloatingButton(context);
        },
        expandedWidget: Row(
          children: [
            IconButton(
              onPressed: () {
                notifyNewSelectedFormat(
                    context, printSettingListener.getSelectedFormat.portrait);
              },
              icon: Transform.rotate(
                angle: -math.pi / 2,
                child: Icon(
                  Icons.note_outlined,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                notifyNewSelectedFormat(
                    context, printSettingListener.getSelectedFormat.landscape);
              },
              icon: Icon(
                Icons.note_outlined,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            SizedBox(
                width: getSizeOfController(),
                child: PaperListController(
                  supportsLabelPrinting: supportsLabelPrinting(),
                  initialValue: _lastLoaded?.format ?? PdfPageFormat.a4,
                  onValueSelectedFunction: (value) {
                    notifyNewSelectedFormat(context, value ?? PdfPageFormat.a4);
                  },
                )),
          ],
        ));
  }

  @override
  void initState() {
    printSettingListener =
        Provider.of<PrintSettingLargeScreenProvider>(context, listen: false);
    if (hasFromTo()) {
      printSettingListener.init(widget.asList!.length);
    }
    // printSettingListener.addListener(() => debugPrint("isChanggggg"));
    super.initState();
  }

  @override
  void didUpdateWidget(covariant PrintNew<PrintLocalSetting> oldWidget) {
    if (hasFromTo()) {
      printSettingListener.init(widget.asList!.length);
    } else {
      printSettingListener.init(-1);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  List<Widget>? getAppbarActionsWhenThirdPane() {
    debugPrint("getAppbarActionsWhenThirdPane");
    return [const Icon(Icons.settings)];
  }

  @override
  List<Widget>? getAppbarActions(
      {bool? firstPane, TabControllerHelper? tab, TabControllerHelper? sec}) {
    return null;
  }

  // @override
  // Widget? getAppbarTitle(
  //     {bool? firstPane,
  //     TabControllerHelper? tab,
  //     TabControllerHelper? secoundTab}) {
  //   return firstPane == null
  //       ? Text(AppLocalizations.of(context)!.printerSetting)
  //       : isFirstPane(firstPane: firstPane)
  //           ? widget.viewAbstract.getMainHeaderText(context)
  //           : Text(lastSecondPaneItem?.title ?? "TO FIX");
  // }
  @override
  Widget? getAppbarTitle(
      {bool? firstPane,
      TabControllerHelper? tab,
      TabControllerHelper? secoundTab}) {
    if (firstPane == true) {
      return Text(
          "${AppLocalizations.of(context)!.print} ${getExtrasCast().getMainHeaderLabelTextOnly(context)}");
    }
    return null;
  }

  @override
  Widget? getFloatingActionButton(
      {bool? firstPane,
      TabControllerHelper? tab,
      TabControllerHelper? secoundTab}) {
    if (getCurrentScreenSize() != CurrentScreenSize.MOBILE) {
      if (firstPane == true) {
        return getFloatingActionButtonConsomer(context,
            builder: (_, isExpanded) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (!isExpanded) getPrintShareFloating(context),
              if (!isExpanded)
                const SizedBox(
                  width: kDefaultPadding,
                ),
              if (!isExpanded) getPrintFloating(context),
            ],
          );
        });
      }
    }
    if (getCurrentScreenSize() == CurrentScreenSize.MOBILE &&
        firstPane == true) {
      return getFloatingActionButtonConsomer(context, builder: (_, isExpanded) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (!isExpanded) getPrintShareFloating(context),
            if (!isExpanded)
              const SizedBox(
                width: kDefaultPadding,
              ),
            if (!isExpanded) getPrintFloating(context),
            if (!isExpanded)
              const SizedBox(
                width: kDefaultPadding,
              ),
            if (!isExpanded) getPrintAdvancedFloating(),
            if (!isExpanded)
              const SizedBox(
                width: kDefaultPadding,
              ),
            getPrintPageOptions()
          ],
        );
      });
    }
    return null;
  }

  Future getSettingFuture() {
    dynamic extra = getExtras();
    return widget.type == PrintPageType.self_list
        ? getSettingLoadDefaultIfNullSelfList(context, extra)
        : getSettingLoadDefaultIfNull(context, extra);
  }

  Widget getSettingWidget() {
    Widget setting = const Center(
      child: Text("getFirstPane"),
    );

    return FutureBuilder(
      future: getSettingFuture(),
      builder: (_, snapshot) {
        if (snapshot.hasError) {
          debugPrint(
              "getSettingLoadDefaultIfNull=>hasError ${snapshot.error.toString()}");
          return setting;
        }
        debugPrint("getSettingLoadDefaultIfNull=>data ${snapshot.data}");
        if (snapshot.hasData == false) {
          return setting;
        }
        return Scaffold(
          body: BaseEditWidget(
            isTheFirst: true,
            viewAbstract: snapshot.data as ViewAbstract,
            onValidate: (viewAbstract) {
              debugPrint("BasePdfPageConsumer new viewAbstract $viewAbstract");

              if (viewAbstract != null) {
                // notifyNewViewAbstract(viewAbstract.getCopyInstance());
                Configurations.saveViewAbstract(viewAbstract);
              }
            },
          ),
        );
      },
    );
  }

  Widget getFloatingActionButtonConsomer(BuildContext context,
      {required Widget Function(BuildContext, bool) builder}) {
    return Selector<PrintSettingLargeScreenProvider, bool>(
      builder: (v, isExpanded, __) {
        debugPrint(
            "BasePdfPageConsumer Selector =>  getFloatingActionButtonConsomer");
        return builder(v, isExpanded);
      },
      selector: (ctx, provider) => provider.getFloatActionIsExpanded,
    );
  }

  bool supportsLabelPrinting() {
    return (getExtras() as PrintableMaster).getPrintableSupportsLabelPrinting();
  }

  bool hasFromTo() {
    return widget.type == PrintPageType.list;
  }

  bool hasFromToSelfList() {
    return widget.type == PrintPageType.self_list;
  }

  int getMinPage() {
    return 1;
  }

  int getMaxPage() {
    return widget.asList!.length;
  }

  PageRange? getPageRange() {
    int? from = printSettingListener.fromPage;
    int? to = printSettingListener.toPage;
    if (from != null && to != null) {
      return PageRange(from: from, to: to - 1);
    }
    return null;
  }

  LoadedPrint? shouldSkipLoad(
      {required PdfPageFormat format,
      required String setting,
      required String viewAbstract}) {
    LoadedPrint newPrint = LoadedPrint(
        format: format, setting: setting, viewAbstract: viewAbstract);
    if (newPrint == _lastLoaded) {
      return _lastLoaded;
    } else {
      return null;
    }
  }

  Widget getPdfPreview(PdfPageFormat fomat) {
    return PdfPreview(
        // shouldRepaint: true,
        // key: UniqueKey(),
        // pages: hasFromTo() ? printSettingListener.generateListOfPage() : null,
        pdfFileName: getExtras()!.getPrintableQrCodeID(),
        shareActionExtraEmails: const [
          "info@saffoury.com"
        ], //TODO should rename
        maxPageWidth: getWidth,
        initialPageFormat: fomat,
        canChangePageFormat: true,
        canDebug: false,
        scrollViewDecoration:
            BoxDecoration(color: Theme.of(context).colorScheme.surface),
        dynamicLayout: true,
        loadingWidget: SkeletonPage(
            // style: SkeletonParagraphStyle(lines: 1),
            ),
        useActions: false,
        shareActionExtraBody: "Share",
        onError: (context, error) {
          getConnectionState.value = ConnectionStateExtension.error;
          return EmptyWidget.error(
            context,
            onSubtitleClicked: () => setState(() {}),
          );
        },
        // shouldRepaint: ,
        build: (format) async {
          debugPrint("dsada $fomat");
          dynamic setting = await getSettingFuture();
          if (widget.type == PrintPageType.list) {
            if (loadedFileBytes != null) {
              LoadedPrint? c = shouldSkipLoad(
                  format: fomat,
                  setting: setting.toString(),
                  viewAbstract: widget.asList!.toString());
              if (c != null) {
                debugPrint("dsada LoadedPrint isLoadedBefore");
                getConnectionState.value = ConnectionStateExtension.done;
                return loadedFileBytes!;
              }
              debugPrint("dsada LoadedPrint  is not !!!!!!!isLoadedBefore");
            }

            loadedFile = PDFListApi<PrintLocalSetting>(
                    list: widget.asList!.cast(),
                    context: context,
                    setting: setting)
                .generate(fomat, pageRange: getPageRange());

            loadedFileBytes = await loadedFile;
            getConnectionState.value = ConnectionStateExtension.done;
            _lastLoaded = LoadedPrint(
                format: format,
                setting: setting.toString(),
                viewAbstract: widget.asList!.toString());

            return loadedFileBytes!;
          } else if (widget.type == PrintPageType.self_list) {
            // PrintLocalSetting? setting = await getSetting();
            loadedFile = PdfSelfListApi<PrintLocalSetting>(
                    widget.asList!.cast(), context, getExtras(),
                    printCommand: setting)
                .generate(fomat, pagesAdded: (pagesAddedCount) {
              printSettingListener.init(pagesAddedCount);
            }, pageRange: getPageRange());

            loadedFileBytes = await loadedFile;

            getConnectionState.value = ConnectionStateExtension.done;
            return loadedFileBytes!;
          } else {
            loadedFile = getExcelFileUinit(context, getExtras()!, fomat,
                hasCustomSetting: setting as PrintLocalSetting);
            loadedFileBytes = await loadedFile;

            getConnectionState.value = ConnectionStateExtension.done;
            return loadedFileBytes!;
          }
        });
  }

  //    else {
  //     if (widget.type == PrintPageType.list) {
  //       return PdfPreview(
  //           shareActionExtraEmails: const ["info@saffoury.com"],
  //           initialPageFormat: fomat,
  //           canChangePageFormat: true,
  //           canChangeOrientation: true,

  //           // pdfPreviewPageDecoration:
  //           canDebug: false,
  //           pageFormats: {
  //             AppLocalizations.of(context)!.a3ProductLabel: PdfPageFormat.a3,
  //             AppLocalizations.of(context)!.a4ProductLabel: PdfPageFormat.a4,
  //             AppLocalizations.of(context)!.a5ProductLabel: PdfPageFormat.a5,
  //           },
  //           scrollViewDecoration:
  //               BoxDecoration(color: Theme.of(context).colorScheme.outline),
  //           shareActionExtraBody: "shareActionExtraBody",
  //           dynamicLayout: true,
  //           loadingWidget: const CircularProgressIndicator(),
  //           // actions: [Icon(Icons.search), Icon(Icons.ac_unit_sharp)],
  //           // pdfPreviewPageDecoration: BoxDecoration(color: Colors.green),
  //           useActions: true,

  //           // shouldRepaint: ,
  //           build: (format) async {
  //             dynamic setting =
  //                 await getSetting(context, getExtras() as PrintableMaster);
  //             return await PDFListApi(
  //                     list: widget.asList!.cast(),
  //                     context: context,
  //                     setting: setting)
  //                 .generate(format);
  //           });
  //     } else {
  //       ///self list
  //       ///
  //       ///

  //       return PdfPreview(
  //           shareActionExtraEmails: const ["info@saffoury.com"],
  //           initialPageFormat: fomat,
  //           canChangePageFormat: true,
  //           canChangeOrientation: true,
  //           // pdfPreviewPageDecoration:
  //           canDebug: false,
  //           pageFormats: {
  //             AppLocalizations.of(context)!.a3ProductLabel: PdfPageFormat.a3,
  //             AppLocalizations.of(context)!.a4ProductLabel: PdfPageFormat.a4,
  //             AppLocalizations.of(context)!.a5ProductLabel: PdfPageFormat.a5,
  //           },
  //           scrollViewDecoration:
  //               BoxDecoration(color: Theme.of(context).colorScheme.outline),
  //           shareActionExtraBody: "shareActionExtraBody",
  //           dynamicLayout: true,
  //           loadingWidget: const CircularProgressIndicator(),
  //           // actions: [Icon(Icons.search), Icon(Icons.ac_unit_sharp)],
  //           // pdfPreviewPageDecoration: BoxDecoration(color: Colors.green),
  //           useActions: true,

  //           // shouldRepaint: ,
  //           build: (format) async {
  //             // PrintLocalSetting? setting = await getSetting();
  //             return await PdfSelfListApi(
  //                     widget.asList!.cast(), context, getExtras(),
  //                     printCommand: widget.customSetting)
  //                 .generate(format);
  //           });
  //     }
  //   }
  // }

  Widget getPdfPreviewWidget() {
    return SliverFillRemaining(
      child: Selector<PrintSettingLargeScreenProvider,
          Tuple3<ViewAbstract?, PdfPageFormat, int>>(
        builder: (_, provider, __) {
          debugPrint(
              "BasePdfPageConsumer Selector =>  getPdfPageConsumer format ${provider.item2}");
          return getPdfPreview(provider.item2);
        },
        selector: (ctx, provider) => Tuple3(provider.getViewAbstract,
            provider.getSelectedFormat, provider.hasho),
      ),
    );
  }

  @override
  bool isPaneScaffoldOverlayColord(bool firstPane) => firstPane;

  @override
  bool setPaneBodyPaddingHorizontal(bool firstPane) => true;

  @override
  bool setMainPageSuggestionPadding() => false;

  @override
  bool setHorizontalDividerWhenTowPanes() => false;

  @override
  bool setClipRect(bool? firstPane) => firstPane == true;

  @override
  Future getCallApiFunctionIfNull(BuildContext context,
      {TabControllerHelper? tab}) {
    debugPrint("getCallApiFunctionIfNull");
    return (getExtras() as ViewAbstract).viewCallGetFirstFromList(
        (getExtras() as ViewAbstract).iD,
        context: context) as Future<PrintableMaster?>;
  }

  @override
  ServerActions getServerActions() {
    return ServerActions.view;
  }

  @override
  Widget? getPaneDraggableExpandedHeader(
      {required bool firstPane, TabControllerHelper? tab}) {
    return null;
  }

  @override
  Widget? getPaneDraggableHeader(
      {required bool firstPane, TabControllerHelper? tab}) {
    return null;
  }

  // @override
  // List<Widget>? getPane(
  //     {required bool firstPane,
  //     ScrollController? controler,
  //     TabControllerHelper? tab}) {
  //   if (getCurrentScreenSize() == CurrentScreenSize.MOBILE && firstPane) {
  //     return [getPdfPreviewWidget()];
  //   }
  //   return [getPdfPreviewWidget()];
  // }
  @override
  bool enableAutomaticFirstPaneNullDetector() {
    return false;
  }

  @override
  ConnectionStateExtension? overrideConnectionState(
      BasePageWithApiConnection type) {
    // if (type == BasePageWithApiConnection.build) {
    if (_lastLoaded != null) {
      return ConnectionStateExtension.done;
    }
    return ConnectionStateExtension.waiting;
    // }
    return super.overrideConnectionState(type);
  }

  @override
  List<Widget>? getPaneNotifier(
      {required bool firstPane,
      ScrollController? controler,
      TabControllerHelper? tab,
      SecondPaneHelper? valueNotifier}) {
    // TODO: implement getPaneNotifier
    debugPrint("PrintNew getPaneNiotifer");
    if (isLargeScreenFromScreenSize(getCurrentScreenSize())) {
      if (firstPane) {
        return [
          ValueListenableBuilder(
            valueListenable: getConnectionState,
            builder: (context, value, child) {
              return MultiSliver(
                children: [
                  if (value == ConnectionStateExtension.error)
                    EmptyWidget.error(context)
                  else if (value != ConnectionStateExtension.done)
                    SliverToBoxAdapter(
                      child: SkeletonParagraph(
                        style: SkeletonParagraphStyle(
                            padding: EdgeInsets.symmetric(
                                horizontal: kDefaultPadding / 2,
                                vertical: kDefaultPadding),
                            lineStyle: SkeletonLineStyle(
                                randomLength: true,
                                maxLength: firstPaneWidth,
                                minLength: firstPaneWidth * .7),
                            lines: 10,
                            spacing: kDefaultPadding),
                      ),
                    )
                  else
                    ..._getFirstPaneLargeScreen()
                ],
              );
            },
          ),
        ];
      } else {
        return [getPdfPreviewWidget()];
      }
    }
    return [getPdfPreviewWidget()];
  }

  List<Widget> _getFirstPaneLargeScreen() {
    return [
      SliverToBoxAdapter(
          child: ListTile(
              leading: Text(getAppLocal(context)?.copies ?? ""),
              title: InputQty(
                qtyFormProps: getQtyFormProps(context),
                decoration: getQtyPlusDecoration(context),
                maxVal: 50,
                initVal: 1,
                minVal: 1,
                steps: 1,
                onQtyChanged: (val) {
                  // debugPrint(val);
                },
              ))),
      // SliverToBoxAdapter(
      //   child: PrinterListControllerDropdown(),
      // ),
      SliverToBoxAdapter(
        child: ListTileSameSizeOnTitle(
          leading: Text("Paper Oriantaion"),
          title: PaperOriantaionController(),
        ),
      ),
      if (hasFromTo())
        SliverToBoxAdapter(
          child: Row(
            children: [
              Expanded(
                child: ListTileSameSizeOnTitle(
                  leading: Text(getAppLocal(context)?.startEndPage ?? ""),
                  title: InputQty(
                    validator: (value) {
                      if (value == null) {
                        return "";
                      }

                      num s = 2;
                      debugPrint(
                          "compareToValues ${s.compareIsBetweenTowValues(1, 3)}");

                      return value.toNonNullable() <=
                              printSettingListener.toPage.toNonNullable()
                          ? null
                          : "";
                    },
                    qtyFormProps: getQtyFormProps(context),
                    decoration: getQtyPlusDecoration(context),
                    maxVal: getMaxPage(),
                    initVal: printSettingListener.fromPage.toNonNullable() == 0
                        ? 1
                        : printSettingListener.fromPage.toNonNullable(),
                    minVal: getMinPage(),
                    steps: 1,
                    onQtyChanged: (val) {
                      debugPrint("BBBB ${val.toInt()}");
                      printSettingListener.setFromToPage(from: val.toInt() - 1);
                    },
                  ),
                ),
              ),
              Expanded(
                child: ListTileSameSizeOnTitle(
                  leading: Text(getAppLocal(context)?.to ?? ""),
                  title: InputQty(
                    validator: (value) {
                      if (value == null) {
                        return "";
                      }

                      return value.toNonNullable() >=
                              printSettingListener.fromPage.toNonNullable()
                          ? null
                          : "";
                    },
                    qtyFormProps: getQtyFormProps(context),
                    decoration: getQtyPlusDecoration(context),
                    maxVal: getMaxPage(),
                    initVal: printSettingListener.toPage.toNonNullable(),
                    minVal: getMinPage(),
                    steps: 1,
                    onQtyChanged: (val) {
                      debugPrint("BBBB ${val.toInt()}");
                      printSettingListener.setFromToPage(to: val.toInt());
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      // SliverToBoxAdapter(
      //   child: ListTileSameSizeOnTitle(
      //       leading: Text(getAppLocal(context)?.ok ?? ""),
      //       title: PaperListController(
      //         supportsLabelPrinting: supportsLabelPrinting(),
      //         initialValue: _lastLoaded?.format ?? PdfPageFormat.a4,
      //         onValueSelectedFunction: (value) {
      //           notifyNewSelectedFormat(context, value ?? PdfPageFormat.a4);
      //         },
      //       )),
      // ),
      SliverFillRemaining(
        child: FutureBuilder(
          future: getSettingFuture(),
          builder: (c, a) {
            if (a.data == null) {
              return EmptyWidget.loading();
            }
            return BaseEditWidget(
              isTheFirst: true,
              viewAbstract: a.data as ViewAbstract,
              onValidate: (viewAbstract) async {
                if (viewAbstract != null) {
                  debugPrint(
                      "BasePdfPageConsumer newViewAbstract $viewAbstract");
                  // notifyNewViewAbstract(viewAbstract.getCopyInstance());
                  await Configurations.saveViewAbstract(viewAbstract);
                  printSettingListener.setViewAbstract = viewAbstract;
                  // context.pop();
                }
              },
            );
          },
        ),
      )
    ];
  }

  Printer? getDefaultPrinter(List<Printer> printers) {
    return printers.firstWhereOrNull((o) => o.isDefault == true);
  }

  @override
  String onActionInitial() {
    return "TODO On API is null";
  }

  Future<void> setPrinters() async {
    localPrinters = await Printing.listPrinters();
  }

  String getLabelFromPDF(PdfPageFormat format) {
    if (format == PdfPageFormat.a4) {
      return AppLocalizations.of(context)!.a4ProductLabel;
    } else if (format == PdfPageFormat.a3) {
      return AppLocalizations.of(context)!.a3ProductLabel;
    } else if (format == PdfPageFormat.a5) {
      return AppLocalizations.of(context)!.a5ProductLabel;
    } else {
      return AppLocalizations.of(context)!.productLabel;
    }
  }
}
