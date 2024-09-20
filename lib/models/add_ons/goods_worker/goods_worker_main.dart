import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/add_ons/goods_worker/goods_inventory_list_card.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_saffoury_paper/models/products/warehouse.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/extensions.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/new_components/lists/headers/filter_icon.dart';
import 'package:flutter_view_controller/new_components/qr_code_widget.dart';
import 'package:flutter_view_controller/new_components/today_text.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_main_page.dart';
import 'package:flutter_view_controller/new_screens/base_page.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/new_screens/controllers/controller_dropbox_api_list.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/components/chart_card_item_custom.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/my_files.dart';
import 'package:flutter_view_controller/new_screens/file_reader/base_file_reader_page.dart';
import 'package:flutter_view_controller/new_screens/filterables/base_filterable_main.dart';
import 'package:flutter_view_controller/new_screens/home/components/drawers/drawer_large_screen.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_api_master_new.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_static_list_new.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_view_abstract_request_from_card.dart';
import 'package:flutter_view_controller/new_screens/routes.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

enum GoodsType implements ViewAbstractEnum<GoodsType> {
  INVERTORY,
  PURCHASES;

  @override
  IconData getMainIconData() => Icons.format_size_outlined;
  @override
  String getMainLabelText(BuildContext context) =>
      AppLocalizations.of(context)!.type;

  @override
  String getFieldLabelString(BuildContext context, GoodsType field) {
    switch (field) {
      case GoodsType.INVERTORY:
        //todo translate
        return "invertory";
      case GoodsType.PURCHASES:
        //todo translate
        return "PURCH";
    }
  }

  @override
  IconData getFieldLabelIconData(BuildContext context, GoodsType field) {
    switch (field) {
      case GoodsType.INVERTORY:
        return Icons.checklist_outlined;
      case GoodsType.PURCHASES:
        return Icons.checklist_outlined;
    }
  }

  @override
  List<GoodsType> getValues() {
    return GoodsType.values;
  }
}

class GoodsInventoryPage extends StatefulWidget {
  const GoodsInventoryPage({super.key});

  @override
  State<GoodsInventoryPage> createState() => _GoodsInventoryPageState();
}

class _GoodsInventoryPageState extends BasePageState<GoodsInventoryPage>
    with BasePageWithDraggablePage {
  int testId = 0;
  double testQuantity = 100;
  int testBarCode = 1000;
  final keyInventory =
      GlobalKey<SliverApiWithStaticMixin>(debugLabel: 'invontery');
  final keyToImportFrom =
      GlobalKey<SliverApiWithStaticMixin>(debugLabel: 'import');
  final keyToExportTo =
      GlobalKey<SliverApiWithStaticMixin>(debugLabel: 'export');
  Warehouse? _selectedWarehouse;
  final ValueNotifier<List<ViewAbstract>?> _notifier =
      ValueNotifier<List<ViewAbstract>?>(null);
  Function(List<ViewAbstract<dynamic>>?)? onDone;

  final ValueNotifier<List<ViewAbstract>?> _notifierOnImportAndExport =
      ValueNotifier<List<ViewAbstract>?>(null);

  final qrCode = ValueNotifier<QrCodeNotifierState?>(null);

  List<ViewAbstract>? _importedList;
  List<ViewAbstract> exportedList = [];

  List<Product>? allProducts;

  late Product inventoryProduct;
  @override
  void initState() {
    super.initState();
    _notifier.addListener(whenFileReaderImportList);
    inventoryProduct = Product();
    inventoryProduct.requireObjcetsResquest = false;
    inventoryProduct.setCustomMap({"requireInventory": "yes"});
  }

  @override
  Widget? getCustomEndDrawer() {
    // TODO: implement getCustomEndDrawer
    return BaseEditNewPage(
      onFabClickedConfirm: (v) {
        if (v != null) {
          keyToExportTo.currentState?.addAnimatedListItem(v);
          // keyToImportFrom.currentState?.removeByValue(t);
          setState(() {});
        }
      },
      viewAbstract: Product(),
    );
  }

  @override
  void dispose() {
    super.dispose();

    _notifier.removeListener(whenFileReaderImportList);
  }

  void whenFileReaderImportList() {
    debugPrint("whenFileReaderImportList called");
    setState(() {
      _importedList =
          _notifier.value == null ? null : List.empty(growable: true)
            ?..addAll(_notifier.value!.cast());
    });
  }

  @override
  double getCustomPaneProportion() {
    return .5;
  }

  @override
  Map<String, List<DrawerMenuItem>>? getCustomDrawer() {
    return {
      //todo translate
      "Details": [
        DrawerMenuItem(title: "INVENTORY", icon: Icons.inventory),
        DrawerMenuItem(title: "Purchases", icon: Icons.document_scanner),
      ]
    };
  }

  ListTile getHeaderWidgetForPurchuses() {
    return ListTile(
      leading: const Icon(Icons.import_export_sharp),
      title: const Text("Start by importing product from xsl formal "),
      trailing: ElevatedButton(
          onPressed: () async {
            final p = Product();
            List<ViewAbstract<dynamic>>? l = await context.pushNamed(
                importRouteName,
                pathParameters: {"tableName": p.getTableNameApi()!},
                extra: p);
            debugPrint("list is $l");
            if (l != null) {
              if (mounted) {
                final scaffold = ScaffoldMessenger.of(context);
                scaffold.showSnackBar(SnackBar(
                    action: SnackBarAction(
                        label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
                    content: Text("${l.length} items imported successfully")));

                // scaffold.showMaterialBanner(MaterialBanner(

                //     content: const Text('Hello, I am Material Banner!'),
                //     contentTextStyle: const TextStyle(
                //         color: Colors.black, fontSize: 30),
                //     backgroundColor: Colors.yellow,
                //     leadingPadding: const EdgeInsets.only(right: 30),
                //     leading: const Icon(
                //       Icons.info,
                //       size: 32,
                //     ),
                //     actions: [
                //       TextButton(
                //           onPressed: () {},
                //           child: const Text('Dismiss')),
                //       TextButton(
                //           onPressed: () {},
                //           child: const Text('Continue')),
                //     ]));
              }
            }
          },
          child: const Text("IMPORT")),
    );
  }

  @override
  Widget? getAppbarTitle(
      {bool? firstPane,
      TabControllerHelper? tab,
      TabControllerHelper? secoundTab}) {
    if (firstPane == null) {
      return findCurrentScreenSize(context) == CurrentScreenSize.MOBILE
          ? null
          : getHeaderForInventory();
    } else {
      if (isPurchuses()) {
        return const Text("Purhuses");
      }
      return const Text("INVINTORY");
    }
    return null;
  }

  @override
  List<Widget>? getAppbarActions(
      {bool? firstPane, TabControllerHelper? tab, TabControllerHelper? sec}) {
    if (isMobile(context) && firstPane == true) {
      return [
        FilterIcon(
          useDraggableWidget: true,
          viewAbstract: Product(),
          onDoneClickedPopResults: () {},
        )
      ];
    }
    if (firstPane == null) {
      return findCurrentScreenSize(context) == CurrentScreenSize.MOBILE
          ? null
          : [
              FilterIcon(
                useDraggableWidget: true,
                viewAbstract: Product(),
                onDoneClickedPopResults: () {},
              )
            ];
    }
    if (!firstPane) return [const Icon(Icons.refresh)];
    return null;
  }

  Widget getHeaderForInventory() {
    if (isMobile(context)) {
      return Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          children: [...getHeaderInvonteryControlls],
        ),
      );
    }
    return TodayTextTicker(
      requireTime: true,
    );
  }

  List<Widget> get getHeaderInvonteryControlls {
    return [
      Expanded(
        child: DropdownFromViewAbstractApi(
          byIcon: true,
          initialValue: _selectedWarehouse,
          onChanged: (selectedViewAbstract) {
            Warehouse? selected = selectedViewAbstract;
            setState(() {
              _selectedWarehouse = selected;
            });
          },
          viewAbstract: Warehouse(),
        ),
      ),
    ];
  }

  @override
  getPane(
      {required bool firstPane,
      TabControllerHelper? tab,
      TabControllerHelper? secoundTab}) {
    return firstPane
        ? getDesktopFirstPane(tab: tab)
        : getDesktopSecondPane(secoundTab: secoundTab);
  }

  getDesktopFirstPane({TabControllerHelper? tab}) {
    debugPrint(
        "getDesktopFirstPane lastDrawerItem ${lastDrawerItemSelected?.title}");
    return [
      if (!isPurchuses())
        SliverApiMixinViewAbstractCardApiWidget(
          key: keyInventory,
          isSliver: true,
          toListObject: Product(),
          hasCustomCardBuilder: (idx, item) {
            return GoodsInventoryListCard(
              product: item as Product,
              selectedWarehouse: _selectedWarehouse,
            );
          },
        )
      else
        SliverApiMixinStaticList(
          listKey: "exportTo",
          key: keyToExportTo,
          isSliver: true,
          list: exportedList,
          hasCustomCardBuilder: (idx, item) {
            return getListItemForPurchasesCheck(idx, item, context);
          },
        )
    ];
  }

  Center getMobileFirstPaneWidget(TabControllerHelper tab) {
    return Center(
      child: Text(tab.text!),
    );
  }

  getDesktopSecondPane(
      {TabControllerHelper? tab, TabControllerHelper? secoundTab}) {
    if (isPurchuses()) {
      return [
        if (_importedList != null)
          SliverToBoxAdapter(
            child: ListTile(
              title: Text("ReImport xsl file "),
              trailing: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _importedList = null;
                  });
                },
                child: Text(AppLocalizations.of(context)!.improterInfo),
              ),
            ),
          ),
        if (_importedList != null)
          SliverToBoxAdapter(
            child: getSummary(),
          ),
        if (_importedList != null)
          SliverToBoxAdapter(
            child: Text(AppLocalizations.of(context)!.details,
                    style: Theme.of(context).textTheme.titleMedium)
                .padding(),
          ),
        if (_importedList == null)
          SliverFillRemaining(
            child: FileReaderPage(
              onDone: (p0) {
                debugPrint("onDone FileReaderPage=> $p0");
                _notifier.value = p0;
              },
              viewAbstract: Product(),
            ),
          )
        else
          SliverApiMixinStaticList(
            listKey: "emportFrom",
            list: _importedList!,
            isSliver: true,
            enableSelection: false,
            key: keyToImportFrom,
            hasCustomCardBuilder: (i, v) =>
                getListItemForPurchasesCheck(i, v, context),
          ),
      ];
    }

    return [
      SliverToBoxAdapter(
        child: Text(""),
      )
      // FutureBuilder(
      //     future: inventoryProduct.listCall(count: 1, page: 0),
      //     builder: (context, snapshot) {
      //       if (snapshot.connectionState == ConnectionState.done) {
      //         if (snapshot.hasData) {
      //           allProducts = snapshot.data!;
      //           return Text("allProducts ${allProducts?.length}");
      //           return SliverApiMixinStaticList(
      //             listKey: "emportFrom",
      //             list: snapshot.data!,
      //             isSliver: true,
      //             enableSelection: false,
      //             hasCustomCardBuilder: (i, v) =>
      //                 getListItemForPurchasesCheck(i, v, context),
      //           );
      //         } else {
      //           return const SliverFillRemaining(
      //             child: Center(
      //               child: Column(
      //                 children: [
      //                   Text("Error no data available"),
      //                   Text("Error no data available")
      //                 ],
      //               ),
      //             ),
      //           );
      //         }
      //       }
      //       return const SliverFillRemaining(
      //         child: Center(
      //           child: Column(
      //             children: [
      //               Text(
      //                   "We are doing a backgorund works analysis your products"),
      //               Text("Please wait for the task to finish")
      //             ],
      //           ),
      //         ),
      //       );
      //     })
    ];
  }

  Widget getListItemForPurchasesCheck(
      int i, ViewAbstract<dynamic> v, BuildContext context) {
    return Card(
      child: ExpansionTile(
        leading: Text("${i + 1}"),
        trailing: Text(
          (v as Product)
              .qrQuantity
              .toCurrencyFormat(symbol: AppLocalizations.of(context)!.kg),
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Theme.of(context).colorScheme.tertiary),
        ),
        title: (v.getMainHeaderText(context)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            v.gsms?.getLabelWithTextWidget(
                    context: context,
                    AppLocalizations.of(context)!.gsm,
                    v.gsms?.gsm.toNonNullable().toString() ?? "") ??
                const Text(""),
            v.getLabelWithTextWidget(
                context: context,
                AppLocalizations.of(context)!.barcode,
                color: Theme.of(context).colorScheme.tertiary,
                v.barcode ?? "-"),
          ],
        ),
        children: [v.getFullDescription()],
      ),
    );
  }

  Widget getSummary() {
    List<Product>? productList = _importedList?.cast<Product>();
    debugPrint("productList size ${productList?.length}");
    double getTotalImportedFromFile = productList == null
        ? 0
        : productList
                .map((e) => e.qrQuantity)
                .reduce((value, element) => (value ?? 0) + (element ?? 0)) ??
            0;
    productList = keyToExportTo.currentState?.getList<Product>();
    double getTotalImportedFromBarcode = productList == null ||
            productList.isEmpty
        ? 0
        : productList
                .map((e) => e.qrQuantity)
                .reduce((value, element) => (value ?? 0) + (element ?? 0)) ??
            0;
    double getTotalRemainingImported =
        getTotalImportedFromFile - getTotalImportedFromBarcode;

    int totalImportedLength =
        keyToImportFrom.currentState?.getList().length ?? 0;
    int totalImportedBarcodeLength =
        keyToExportTo.currentState?.getList().length ?? 0;
    int totalRemainingLength = totalImportedLength - totalImportedBarcodeLength;
    return FileInfoStaggerdGridView(
      childAspectRatio: 16 / 9,
      builder: (crossAxisCount, crossCountFundCalc, crossAxisCountMod) {
        return [
          StaggeredGridTile.count(
              crossAxisCellCount: 2,
              mainAxisCellCount: 1,
              child: ChartCardItemCustom(
                color: Colors.blue,
                icon: Icons.list,
                title: "TOTAL ITEMS IMPORTED",
                description: getTotalImportedFromFile.toCurrencyFormat(
                    symbol: AppLocalizations.of(context)!.kg),
                footer: totalImportedLength.toCurrencyFormat(),

                // footer: incomes?.length.toString(),
                // footerRightWidget: incomesAnalysis.getGrowthRateText(context),
              )),
          StaggeredGridTile.count(
              crossAxisCellCount: 2,
              mainAxisCellCount: 1,
              child: ChartCardItemCustom(
                color: const Color.fromARGB(255, 243, 82, 33),
                icon: Icons.barcode_reader,
                title: "TOTAL ITEMS SCANED",
                description: getTotalImportedFromBarcode.toCurrencyFormat(
                    symbol: AppLocalizations.of(context)!.kg),
                footer: totalImportedBarcodeLength.toCurrencyFormat(),
                // footerRightWidget: incomesAnalysis.getGrowthRateText(context),
              )),
          StaggeredGridTile.count(
              crossAxisCellCount: crossAxisCount + crossAxisCountMod,
              mainAxisCellCount: 1,
              child: ChartCardItemCustom(
                color: Colors.blue,
                // icon: Icons.today,
                title: "TOTAL REMAINING",
                description: getTotalRemainingImported.toCurrencyFormat(
                    symbol: AppLocalizations.of(context)!.kg),
                footer: totalRemainingLength.toCurrencyFormat(),
                // footer: incomes?.length.toString(),
                // footerRightWidget: incomesAnalysis.getGrowthRateText(context),
              )),
        ];
      },
      wrapWithCard: false,
      // crossAxisCount: getCrossAxisCount(getWidth),

      // width < 1400 ? 1.1 : 1.4,
    );
  }

  @override
  bool isPaneScaffoldOverlayColord(bool firstPane,
          {TabControllerHelper? tab}) =>
      false;

  @override
  bool isPanesIsSliver(bool firstPane, {TabControllerHelper? tab}) => false;

  @override
  bool setHorizontalDividerWhenTowPanes() => false;

  @override
  bool setMainPageSuggestionPadding() => false;

  @override
  bool setPaneBodyPadding(bool firstPane, {TabControllerHelper? tab}) => false;

  @override
  bool setPaneClipRect(bool firstPane, {TabControllerHelper? tab}) => false;

  @override
  ValueNotifier<QrCodeNotifierState?>? getValueNotifierQrState(bool firstPane) {
    return firstPane ? qrCode : null;
  }

  @override
  Widget? getDraggableHeaderExpandedWidget(bool firstPane) {
    return isDesktopPlatform()
        ? null
        : QrCodeReader(
            getViewAbstract: true,
            currentHeight: 20,
            valueNotifierQrState: getValueNotifierQrState(firstPane),
          );
  }

  @override
  Widget? getDraggableHeaderWidget(bool firstPane) {
    if (isLargeScreenFromCurrentScreenSize(context)) {
      return null;
    }
    if (isPurchuses()) {
      return getHeaderWidgetForPurchuses();
    }
    return getHeaderForInventory();
  }

  bool isPurchuses() {
    return lastDrawerItemSelected?.icon == Icons.document_scanner;
  }

  @override
  Widget? getDraggableBottomExpandedWidget(bool firstPane) {
    return null;
  }

  @override
  Widget? getFloatingActionButton(
      {bool? firstPane,
      TabControllerHelper? tab,
      TabControllerHelper? secoundTab}) {
    if (firstPane != null) {
      if (firstPane) {
        return FloatingActionButton.extended(
            onPressed: () {
              if (!isPurchuses()) {
                Product p = Product();
                p.qrQuantity = testQuantity + 100;
                p.iD = 2405 + testId;
                testId = testId + 1;
                testQuantity = testQuantity + 100;
                keyInventory.currentState?.addAnimatedListItem(p);
              } else {
                Product? t =
                    keyToImportFrom.currentState?.searchForItem<Product>((t) {
                  debugPrint(
                      "found product barcode: ${t.barcode} testBarcode: ${testBarCode.toString()}");
                  return t.barcode == ((testBarCode)).toString();
                });

                debugPrint("found product founded $t");
                if (t != null) {
                  testBarCode = testBarCode + 1;
                  keyToExportTo.currentState?.addAnimatedListItem(t);
                  keyToImportFrom.currentState?.removeByValue(t);
                  setState(() {});
                } else {
                  context
                      .read<DrawerMenuControllerProvider>()
                      .controlEndDrawerMenu();
                }
              }
            },
            label: const Icon(Icons.add));
      }
    }
    return null;
  }
}
