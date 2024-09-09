import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/add_ons/goods_worker/goods_inventory_list_card.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_saffoury_paper/models/products/warehouse.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/new_components/edit_listeners/controller_dropbox_enum.dart';
import 'package:flutter_view_controller/new_components/edit_listeners/controller_dropbox_enum_icon.dart';
import 'package:flutter_view_controller/new_components/today_text.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/edit_controllers_utils.dart';
import 'package:flutter_view_controller/new_screens/base_page.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
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
  GoodsType _type = GoodsType.INVERTORY;
  Warehouse? _selectedWarehouse;

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

                _selectedWarehouse = selected.isNew() ? null : selected;
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
  getDesktopFirstPane({TabControllerHelper? tab}) =>
      SliverApiMixinViewAbstractCardApiWidget(
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
  @override
  getDesktopSecondPane(
          {TabControllerHelper? tab, TabControllerHelper? secoundTab}) =>
      const Center(
        child: Text("Second"),
      );
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
  @override
  Widget? getFirstPaneFloatingActionButton({TabControllerHelper? tab}) =>
      FloatingActionButton.extended(
          onPressed: () {
            Product p = Product();
            p.iD = 2405 + testId;
            testId = testId + 1;
            key.currentState?.addAnimatedListItem(p);
          },
          label: Icon(Icons.add));
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
