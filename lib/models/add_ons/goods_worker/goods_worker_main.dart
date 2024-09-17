import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_saffoury_paper/models/add_ons/goods_worker/goods_inventory_list_card.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_saffoury_paper/models/products/warehouse.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/new_components/edit_listeners/controller_dropbox_api_list.dart';
import 'package:flutter_view_controller/new_components/edit_listeners/controller_dropbox_enum.dart';
import 'package:flutter_view_controller/new_components/edit_listeners/controller_dropbox_enum_icon.dart';
import 'package:flutter_view_controller/new_components/qr_code_widget.dart';
import 'package:flutter_view_controller/new_components/today_text.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/edit_controllers_utils.dart';
import 'package:flutter_view_controller/new_screens/base_page.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/components/chart_card_item_custom.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/my_files.dart';
import 'package:flutter_view_controller/new_screens/edit/controllers/edit_controller_dropdown_api.dart';
import 'package:flutter_view_controller/new_screens/file_reader/base_file_reader_page.dart';
import 'package:flutter_view_controller/new_screens/home/components/drawers/drawer_large_screen.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_api_master_new.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_static_list_new.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_view_abstract_new.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_view_abstract_request_from_card.dart';
import 'package:flutter_view_controller/new_screens/routes.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:go_router/go_router.dart';

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
  double testBarCode = 1000;
  final key = GlobalKey<SliverApiWithStaticMixin>(debugLabel: 'invontery');
  final keyToImportFrom =
      GlobalKey<SliverApiWithStaticMixin>(debugLabel: 'import');
  final keyToExportTo =
      GlobalKey<SliverApiWithStaticMixin>(debugLabel: 'export');
  GoodsType _type = GoodsType.INVERTORY;
  Warehouse? _selectedWarehouse;
  final ValueNotifier<List<ViewAbstract>?> _notifier =
      ValueNotifier<List<ViewAbstract>?>(null);
  Function(List<ViewAbstract<dynamic>>?)? onDone;

  final ValueNotifier<List<ViewAbstract>?> _notifierOnImportAndExport =
      ValueNotifier<List<ViewAbstract>?>(null);

  final qrCode = ValueNotifier<QrCodeNotifierState?>(null);

  @override
  Map<String, List<DrawerMenuItem>>? getCustomDrawer() {
    return {
      "": [
        DrawerMenuItem(title: "INVENTORY", icon: Icons.inventory),
        DrawerMenuItem(title: "Purchases", icon: Icons.document_scanner),
      ]
    };
  }

  @override
  List<TabControllerHelper>? initTabBarList(
      {bool? firstPane, TabControllerHelper? tab}) {
    if (isMobile(context)) {
      if (firstPane == true) {
        return [
          TabControllerHelper(
            "INVONTERY",
            draggableHeaderWidget: getHeaderForInventory(),
            slivers: getFirstPane(),
          ),
          TabControllerHelper(
            "PURCHASES CHECK",
            draggableHeaderWidget: ListTile(
              leading: Icon(Icons.import_export_sharp),
              title: Text("Start by importing product from xsl formal "),
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
                                label: 'OK',
                                onPressed: scaffold.hideCurrentSnackBar),
                            content: Text(
                                "${l.length} items imported successfully")));

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
                  child: Text("IMPORT")),
            ),
          )
        ];
      }
    }
    return super.initTabBarList(firstPane: firstPane, tab: tab);
  }

  @override
  Widget? getBaseAppbar() {
    if (findCurrentScreenSize(context) == CurrentScreenSize.MOBILE) {
      return null;
    }
    return getHeaderForInventory();
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
    return ListTile(
        leading: TodayTextTicker(
          requireTime: true,
        ),
        title: Row(
          children: getHeaderInvonteryControlls,
        )

        //  Card(
        //   child: SearchWidgetComponentEditable(
        //     initialSearch: _searchQuery,
        //     trailingIsCart: false,
        //     notiferSearchVoid: (value) {
        //       setState(() {
        //         _searchQuery = value;
        //       });
        //     },
        //   ),
        // ),
        );
  }

  List<Widget> get getHeaderInvonteryControlls {
    return [
      Expanded(
          child: DropdownEnumControllerListenerByIcon(
        viewAbstractEnum: _type,
        initialValue: _type,
        onSelected: (object) {
          setState(() {
            _type = object ?? GoodsType.INVERTORY;
          });
        },
      )),
      Expanded(
        child: DropdownFromViewAbstractApi(
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
  List<Widget>? getBaseBottomSheet() => null;
  @override
  Widget? getBaseFloatingActionButton() => null;

  @override
  getDesktopFirstPane({TabControllerHelper? tab}) {
    debugPrint(
        "getDesktopFirstPane lastDrawerItem ${lastDrawerItemSelected?.title}");
    return [
      SliverApiMixinViewAbstractCardApiWidget(
        key: key,
        isSliver: true,
        toListObject: Product(),
        hasCustomCardBuilder: (idx, item) {
          return GoodsInventoryListCard(
            product: item as Product,
            selectedWarehouse: _selectedWarehouse,
          );
        },
      )
    ];
    if (tab != null) {
      ///this means that is mobile View
      return getMobileFirstPaneWidget(tab);
    }
    return getLargeScreenFirstWidget();
  }

  SliverApiMixinWithStaticStateful getLargeScreenFirstWidget() {
    if (_type == GoodsType.INVERTORY) {
      return SliverApiMixinViewAbstractCardApiWidget(
        key: key,
        isSliver: false,
        toListObject: Product(),
        hasCustomCardBuilder: (idx, item) {
          return GoodsInventoryListCard(
            product: item as Product,
            selectedWarehouse: _selectedWarehouse,
          );
        },
      );
    } else {
      return SliverApiMixinStaticList(
        listKey: "exportTo",
        key: keyToExportTo,
        isSliver: false,
        list: const [],
        hasCustomCardBuilder: (idx, item) {
          return getListItemForPurchasesCheck(idx, item, context);
        },
      );
    }
  }

  Center getMobileFirstPaneWidget(TabControllerHelper tab) {
    return Center(
      child: Text(tab.text!),
    );
  }

  @override
  getDesktopSecondPane(
      {TabControllerHelper? tab, TabControllerHelper? secoundTab}) {
    return [SliverToBoxAdapter(child: Text("SADA"))];
    if (_type == GoodsType.PURCHASES) {
      return ValueListenableBuilder(
          valueListenable: _notifier,
          builder: (context, v, o) {
            if (v != null) {
              return SliverApiMixinStaticList(
                listKey: "emportFrom",
                list: v,
                isSliver: false,
                enableSelection: false,
                key: keyToImportFrom,
                hasCustomCardBuilder: (i, v) =>
                    getListItemForPurchasesCheck(i, v, context),
              );
            } else {
              return FileReaderPage(
                onDone: (p0) {
                  debugPrint("onDone FileReaderPage=> $p0");
                  _notifier.value = p0;
                },
                viewAbstract: Product(),
              );
            }
          });
    }
    return Center(
      child: Text("TODO"),
    );
  }

  ExpansionTile getListItemForPurchasesCheck(
      int i, ViewAbstract<dynamic> v, BuildContext context) {
    return ExpansionTile(
      leading: Text("${i + 1}"),
      trailing: Text(
        (v as Product).qrQuantity.toCurrencyFormat(),
      ),
      title: (v.sizes?.getMainHeaderText(context))!,
      subtitle: v.gsms?.getMainHeaderText(context),
      children: [v.getFullDescription()],
    );
  }

  @override
  Widget? getThirdPane() {
    if (_type == GoodsType.INVERTORY) {
      return null;
    }
    return FileInfoStaggerdGridView(
      childAspectRatio: 16 / 9,
      list: [
        StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: .75,
            child: ChartCardItemCustom(
              color: Colors.blue,
              icon: Icons.today,
              title: "TOTAL ITEMS IMPORTED",
              description: "getTotalTodayBalance()",
              // footer: incomes?.length.toString(),
              // footerRightWidget: incomesAnalysis.getGrowthRateText(context),
            )),
        StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: .75,
            child: ChartCardItemCustom(
              color: Colors.blue,
              // icon: Icons.today,
              title: "TOTAL QUANTITY IMPORTED",
              description: "getTotalTodayBalance()",
              // footer: incomes?.length.toString(),
              // footerRightWidget: incomesAnalysis.getGrowthRateText(context),
            )),
        StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: .75,
            child: ChartCardItemCustom(
              color: Colors.blue,
              // icon: Icons.today,
              title: "TOTAL ITEMS SCANED",
              description: "getTotalTodayBalance()",
              // footer: incomes?.length.toString(),
              // footerRightWidget: incomesAnalysis.getGrowthRateText(context),
            )),
        StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: .75,
            child: ChartCardItemCustom(
              color: Colors.blue,
              // icon: Icons.today,
              title: "TOTAL ITEMS SCANNED QUANTITY",
              description: "getTotalTodayBalance()",
              // footer: incomes?.length.toString(),
              // footerRightWidget: incomesAnalysis.getGrowthRateText(context),
            )),
        StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 1,
            child: ChartCardItemCustom(
              color: Colors.blue,
              // icon: Icons.today,
              title: "TOTAL ",
              description: "getTotalTodayBalance()",
              // footer: incomes?.length.toString(),
              // footerRightWidget: incomesAnalysis.getGrowthRateText(context),
            ))
      ],
      wrapWithCard: true,
      // crossAxisCount: getCrossAxisCount(getWidth),

      // width < 1400 ? 1.1 : 1.4,
    );
  }

  @override
  getFirstPane({TabControllerHelper? tab}) => getDesktopFirstPane(tab: tab);

  @override
  List<Widget>? getFirstPaneBottomSheet({TabControllerHelper? tab}) => null;

  @override
  Widget? getFirstPaneFloatingActionButton({TabControllerHelper? tab}) {
    return FloatingActionButton.extended(
        onPressed: () {
          if (_type == GoodsType.INVERTORY) {
            Product p = Product();
            p.qrQuantity = testQuantity + 100;
            p.iD = 2405 + testId;
            testId = testId + 1;
            testQuantity = testQuantity + 100;
            key.currentState?.addAnimatedListItem(p);
          } else {
            debugPrint("$keyToImportFrom");
            Product? t =
                keyToImportFrom.currentState?.searchForItem<Product>((t) {
              debugPrint("found product barcode: ${t.barcode}");
              return t.barcode == testBarCode.toString();
            });

            debugPrint("found product $t");
            if (t != null) {
              testBarCode = testBarCode + 1;
              keyToExportTo.currentState?.addAnimatedListItem(t);
            }
          }
        },
        label: Icon(Icons.add));
  }

  @override
  Widget? getSecondPaneAppbarTitle({TabControllerHelper? tab}) =>
      Text("INVINTORY");
  @override
  Widget? getFirstPaneAppbarTitle({TabControllerHelper? tab}) => Text("FIRST");

  @override
  List<Widget>? getSecondPaneBottomSheet({TabControllerHelper? tab}) => null;

  @override
  Widget? getSecondPaneFloatingActionButton({TabControllerHelper? tab}) => null;
  @override
  getSecoundPane({TabControllerHelper? tab, TabControllerHelper? secoundTab}) =>
      getDesktopSecondPane(tab: tab, secoundTab: secoundTab);

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
}