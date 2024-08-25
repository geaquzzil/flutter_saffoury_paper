// ignore_for_file: public_member_api_docs, sort_constructors_first
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

class ListToDetailsSecoundPaneHelper {
  ServerActions action;
  ViewAbstract? viewAbstract;
  Widget? customWidget;
  ListToDetailsSecoundPaneHelper(
      {required this.action, this.viewAbstract, this.customWidget});
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
    with BasePageActionOnToolbarMixin {
  final ValueNotifier<ListToDetailsSecoundPaneHelper?> _secoundPaneNotifier =
      ValueNotifier<ListToDetailsSecoundPaneHelper?>(null);
  ViewAbstract? secoundPaneViewAbstract;
  bool isInitialization = true;

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
  Widget? getFirstPaneAppbar({TabControllerHelper? tab}) => null;

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
  bool setPaneBodyPadding(bool firstPane, {TabControllerHelper? tab}) => true;

  @override
  bool setMainPageSuggestionPadding() => false;

  @override
  bool setHorizontalDividerWhenTowPanes() => false;

  @override
  bool setPaneClipRect(bool firstPane, {TabControllerHelper? tab}) =>
      !firstPane;

  void setSecoundPane(ListToDetailsSecoundPaneHelper? newState) {
    if (newState != null) {
      context.read<ActionViewAbstractProvider>().add(newState);
    }
    _secoundPaneNotifier.value = newState;
  }

  @override
  getActionFirstPane(bool isDesktop,
      {TabControllerHelper? tab,
      TabControllerHelper? secoundTab,
      ActionOnToolbarItem? selectedItem}) {
    return SliverApiMaster(
      // onSelectedCardChangeValueNotifier:
      //     getCurrentScreenSize() == CurrentScreenSize.MOBILE
      //         ? null
      //         : _secoundPaneNotifier,
      // buildAppBar: false,
      buildSearchWidgetAsEditText: isDesktop,
    );
  }

  @override
  getActionSecondPane(bool isDesktop,
      {TabControllerHelper? tab,
      TabControllerHelper? secoundTab,
      ActionOnToolbarItem? selectedItem}) {
        
    return ValueListenableBuilder(
      valueListenable: _secoundPaneNotifier,
      builder: (context, value, child) {
        if (selectedItem != null &&
            selectedItem.mainObject is ListToDetailsSecoundPaneHelper?) {
          value = selectedItem.mainObject as ListToDetailsSecoundPaneHelper? ??
              value;
        }
        int iD = value?.viewAbstract?.iD ?? -1;
        String tableName = value?.viewAbstract?.getTableNameApi() ?? "";
        Widget currentWidget;
        if (!isInitialization) {
          addAction(
            ActionOnToolbarItem(
                title: value?.action.toString() ?? "__", mainObject: value),
          );
          isInitialization = false;
        }
        if (value == null) {
          currentWidget = Container();
          return currentWidget;
        }
        switch (value.action) {
          case ServerActions.custom_widget:
            currentWidget = value.customWidget!;
            break;
          case ServerActions.add:
            currentWidget = BaseEditNewPage(
                viewAbstract: context
                    .read<DrawerMenuControllerProvider>()
                    .getObjectCastViewAbstract
                    .getNewInstance());
            break;
          case ServerActions.edit:
            currentWidget = BaseEditNewPage(
              viewAbstract: value.viewAbstract!,
            );
            break;
          case ServerActions.view:
            currentWidget = BaseViewNewPage(
              actionOnToolbarItem: onActionAdd,
              // key: widget.key,
              viewAbstract: value.viewAbstract!,
            );
            break;
          case ServerActions.print:
            currentWidget = PdfPageNew(
              iD: iD,
              tableName: tableName,
              invoiceObj: value.viewAbstract! as PrintableMaster,
            );
            break;
          case ServerActions.delete_action:
          case ServerActions.call:
          case ServerActions.file:
          case ServerActions.list_reduce_size:
          case ServerActions.search:
          case ServerActions.search_by_field:
          case ServerActions.search_viewabstract_by_field:
          case ServerActions.notification:
          case ServerActions.file_export:
          case ServerActions.file_import:
          case ServerActions.list:
            currentWidget = Container();
        }
        secoundPaneViewAbstract = value.viewAbstract;
        if (secoundPaneViewAbstract != null && tab?.widget != null) {
          return tab!.widget!;
        }
        return currentWidget;
      },
    );
  }

  @override
  ValueNotifierPane getValueNotifierPane() {
    return ValueNotifierPane.SECOND;
  }

  @override
  ActionOnToolbarItem onActionInitial() => ActionOnToolbarItem(
      title: context
          .read<DrawerMenuControllerProvider>()
          .getObjectCastViewAbstract
          .getMain(context));

  @override
  Widget? getSecondPaneAppbar({TabControllerHelper? tab}) => null;
}
