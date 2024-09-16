// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_main_page.dart';
import 'package:flutter_view_controller/new_screens/actions/view/view_view_main_page.dart';
import 'package:flutter_view_controller/new_screens/base_page.dart';
import 'package:flutter_view_controller/new_screens/home/components/drawers/components/language_button.dart';
import 'package:flutter_view_controller/new_screens/home/components/drawers/components/setting_button.dart';
import 'package:flutter_view_controller/new_screens/home/components/notifications/notification_popup.dart';
import 'package:flutter_view_controller/new_screens/home/components/profile/profile_pic_popup_menu.dart';
import 'package:flutter_view_controller/new_screens/lists/components/search_componenets_editable.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_api_master.dart';
import 'package:flutter_view_controller/printing_generator/page/pdf_page_new.dart';
import 'package:flutter_view_controller/providers/actions/action_viewabstract_provider.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';
import 'package:flutter_view_controller/screens/web/setting_and_profile_new.dart';
import 'package:flutter_view_controller/screens/web/views/web_product_view.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';

class ListToDetailsSecoundPaneHelper extends ActionOnToolbarItem {
  ServerActions action;
  ViewAbstract? viewAbstract;
  Widget? customWidget;
  bool isSecoundPaneView;
  bool shouldAddToThirdPaneList;
  ListToDetailsSecoundPaneHelper({
    required this.action,
    this.viewAbstract,
    this.customWidget,
    this.isSecoundPaneView = false,
    this.shouldAddToThirdPaneList = true,
    required super.actionTitle,
    super.icon,
    super.mainObject,
    super.subObject,
    super.onPress,
    super.path,
  });
}

class ListToDetailsPageNew extends StatefulWidget {
  final String title;
  bool buildDrawer;

  ListToDetailsPageNew(
      {super.key, required this.title, this.buildDrawer = true});

  @override
  State<ListToDetailsPageNew> createState() => ListToDetailsPageNewState();
}

class ListToDetailsPageNewState extends BasePageState<ListToDetailsPageNew>
    with
        BasePageActionOnToolbarMixin<ListToDetailsPageNew,
            ListToDetailsSecoundPaneHelper>,
        BasePageWithThirdPaneMixin<ListToDetailsPageNew,
            ListToDetailsSecoundPaneHelper> {
  @override
  List<TabControllerHelper>? initTabBarList(
      {bool? firstPane, TabControllerHelper? tab}) {
    return null;
    if (firstPane == null && tab == null) {
      return [
        TabControllerHelper(
          "HOME",
          // icon: Icon(Icons.home),
        ),
        TabControllerHelper(
          "PAGES",
          // icon: Icon(Icons.pages),
        )
      ];
    }
    return null;
  }

  @override
  void initState() {
    buildDrawer = widget.buildDrawer;
    super.initState();
  }

  @override
  List<Widget>? getBaseBottomSheet() => null;

  @override
  Widget? getBaseFloatingActionButton() => null;

  @override
  Widget? getFirstPaneAppbarTitle({TabControllerHelper? tab}) => null;

  @override
  List<Widget>? getFirstPaneBottomSheet({TabControllerHelper? tab}) => null;
  @override
  Widget? getFirstPaneFloatingActionButton({TabControllerHelper? tab}) => null;

  @override
  List<Widget>? getSecondPaneBottomSheet({TabControllerHelper? tab}) => null;
  @override
  Widget? getSecondPaneFloatingActionButton({TabControllerHelper? tab}) => null;

  @override
  bool isPaneScaffoldOverlayColord(bool firstPane,
          {TabControllerHelper? tab}) =>
      !firstPane;

  @override
  bool isPanesIsSliver(bool firstPane, {TabControllerHelper? tab}) => false;

  @override
  bool setPaneBodyPadding(bool firstPane, {TabControllerHelper? tab}) =>
      firstPane;

  @override
  bool setMainPageSuggestionPadding() => false;

  @override
  bool setHorizontalDividerWhenTowPanes() => false;

  @override
  bool setPaneClipRect(bool firstPane, {TabControllerHelper? tab}) =>
      !firstPane;

  void setSecoundPane(ListToDetailsSecoundPaneHelper? newState) {
    addAction(newState, notifyListener: true);
  }

  @override
  getActionFirstPane(bool isDesktop,
      {TabControllerHelper? tab,
      TabControllerHelper? secoundTab,
      ListToDetailsSecoundPaneHelper? selectedItem}) {
    return Selector<DrawerMenuControllerProvider, ViewAbstract>(
      builder: (context, value, child) {
        return SliverApiMaster(
          viewAbstract: value,
          buildSearchWidgetAsEditText: isDesktop,
        );
      },
      selector: (p0, p1) => p1.getObjectCastViewAbstract,
    );
  }

  @override
  getActionSecondPane(bool isDesktop,
      {TabControllerHelper? tab,
      TabControllerHelper? secoundTab,
      ListToDetailsSecoundPaneHelper? selectedItem}) {
    return FadeInUp(
        duration: Duration(milliseconds: 200),
        curve: Curves.fastOutSlowIn,
        key: Key(selectedItem.toString()),
        child: getWidgetFromListToDetailsSecoundPaneHelper(
            selectedItem: selectedItem, tab: tab));
  }

  @override
  ValueNotifierPane getValueNotifierPane() {
    return ValueNotifierPane.SECOND;
  }

  @override
  ListToDetailsSecoundPaneHelper onActionInitial() =>
      ListToDetailsSecoundPaneHelper(
          action: ServerActions.list,
          actionTitle: context
              .read<DrawerMenuControllerProvider>()
              .getObjectCastViewAbstract
              .getMainHeaderLabelTextOnly(context));

  @override
  Widget? getSecondPaneAppbarTitle({TabControllerHelper? tab}) => null;
}
