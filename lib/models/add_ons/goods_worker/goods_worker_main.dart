import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_saffoury_paper/models/add_ons/goods_worker/goods_inventory_list_card.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_saffoury_paper/models/products/warehouse.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/new_components/edit_listeners/controller_dropbox_enum.dart';
import 'package:flutter_view_controller/new_components/edit_listeners/controller_dropbox_enum_icon.dart';
import 'package:flutter_view_controller/new_components/today_text.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/edit_controllers_utils.dart';
import 'package:flutter_view_controller/new_screens/base_page.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/new_screens/file_reader/base_file_reader_page.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_static_list_new.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_view_abstract_new.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_view_abstract_request_from_card.dart';

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
    with BasePageWithThirdPaneMixinStatic {
  final key = GlobalKey<SliverApiMixinAutoRestState>();
  final keyToImportFrom = GlobalKey<SliverApiMixinAutoRestState>();
  final keyToExportTo = GlobalKey<SliverApiMixinAutoRestState>();
  GoodsType _type = GoodsType.INVERTORY;
  Warehouse? _selectedWarehouse;
  final ValueNotifier<List<ViewAbstract>?> _notifier =
      ValueNotifier<List<ViewAbstract>?>(null);
  Function(List<ViewAbstract<dynamic>>?)? onDone;

  @override
  Widget? getBaseAppbar() {
    return ListTile(
        leading: TodayTextTicker(
          requireTime: true,
        ),
        title: Row(
          children: [
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
              child: getControllerEditTextViewAbstractAutoComplete(context,
                  viewAbstract: Warehouse(),
                  field: "name", onSelected: (selectedViewAbstract) {
                Warehouse selected = selectedViewAbstract as Warehouse;
                setState(() {
                  _selectedWarehouse = selected.isNew() ? null : selected;
                });
              }, controller: TextEditingController()),
            ),
          ],
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

  @override
  List<Widget>? getBaseBottomSheet() => null;
  @override
  Widget? getBaseFloatingActionButton() => null;

  @override
  getDesktopFirstPane({TabControllerHelper? tab}) {
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

  @override
  getDesktopSecondPane(
      {TabControllerHelper? tab, TabControllerHelper? secoundTab}) {
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
    return _type == GoodsType.INVERTORY
        ? null
        : Card(child: const Center(child: Text("Third")));
  }

  @override
  getFirstPane({TabControllerHelper? tab}) => getDesktopFirstPane(tab: tab);

  @override
  Widget? getFirstPaneAppbar({TabControllerHelper? tab}) => null;
  @override
  List<Widget>? getFirstPaneBottomSheet({TabControllerHelper? tab}) => null;
  int testId = 0;
  double testQuantity = 100;
  double testBarCode = 1;
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
            int bar = 1000;
            Product? t =
                keyToImportFrom.currentState?.searchForItem<Product>((t) {
              debugPrint("found product barcode: ${t.barcode}");
              return t.barcode == bar.toString();
            });
            bar = bar + 1;
            debugPrint("found product $t");
            if (t != null) {
              keyToExportTo.currentState?.addAnimatedListItem(t);
            }
          }
        },
        label: Icon(Icons.add));
  }

  @override
  Widget? getSecondPaneAppbar({TabControllerHelper? tab}) => null;

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
}
