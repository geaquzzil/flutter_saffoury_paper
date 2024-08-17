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
import 'package:flutter_view_controller/new_screens/setting_page_new.dart';
import 'package:flutter_view_controller/printing_generator/page/pdf_page_new.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:flutter_view_controller/screens/web/setting_and_profile.dart';
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

class ListToDetailsPageNewState extends BasePageState<ListToDetailsPageNew> {
  final ValueNotifier<ListToDetailsSecoundPaneHelper?> _secoundPaneNotifier =
      ValueNotifier<ListToDetailsSecoundPaneHelper?>(null);
  ViewAbstract? secoundPaneViewAbstract;

  @override
  List<TabControllerHelper>? initTabBarListSecondPane(
      {TabControllerHelper? tab}) {
    List<TabControllerHelper>? tabs =
        secoundPaneViewAbstract?.getTabs(context, action: ServerActions.view);
    debugPrint("initTabBarListSecondPane called ${tabs?.length}");
    return tabs;
  }

  @override
  List<TabControllerHelper>? initTabBarList() {
    // TODO: implement initTabBarList
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

  @override
  void initState() {
    buildDrawer = widget.buildDrawer;
    super.initState();
  }

  @override
  Widget? getBaseAppbar() {
    if (getCurrentScreenSize() == CurrentScreenSize.MOBILE) return null;
    // if (!isLargeScreenFromCurrentScreenSize(context)) {
    //   return null;
    // }
    return ListTile(
      title: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Expanded(
            child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: kDefaultPadding,
                ),
                child: Text(
                    context
                        .read<DrawerMenuControllerProvider>()
                        .getObject
                        .getMainHeaderLabelTextOnly(context),
                    style: Theme.of(context).textTheme.headlineMedium)

                // SearchWidgetComponent(onSearchTextChanged: (text) {
                //   debugPrint("search for $text");
                // }),
                ),
          ),
          const Spacer(),

          // IconButton(
          //     onPressed: () {
          //       getExtrasCast(tab: tab).printPage(context);
          //     },
          //     icon: const Icon(Icons.print)),
          // IconButton(onPressed: () {}, icon: const Icon(Icons.safety_check)),
          // IconButton(
          //     onPressed: () {}, icon: const Icon(Icons.baby_changing_station)),
          // IconButton(
          //     onPressed: () {}, icon: const Icon(Icons.notification_add)),
          NotificationPopupWidget(),
          const SizedBox(
            width: kDefaultPadding / 2,
          ),
          const DrawerLanguageButton(),
          const SizedBox(
            width: kDefaultPadding / 2,
          ),
          const ProfilePicturePopupMenu(),
          const SizedBox(
            width: kDefaultPadding / 2,
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              context.read<DrawerMenuControllerProvider>().change(
                  context,
                  // SettingPageNew(),
                  SettingAndProfileWeb(),
                  DrawerMenuControllerProviderAction.custom_widget);
            },
          )
          // const DrawerSettingButton(),
        ],
      ),
    );
  }

  @override
  List<Widget>? getBaseBottomSheet() => null;

  @override
  Widget? getBaseFloatingActionButton() => null;

  @override
  getDesktopFirstPane({TabControllerHelper? tab}) => getFirstPane(tab: tab);

  @override
  getDesktopSecondPane(
          {TabControllerHelper? tab, TabControllerHelper? secoundTab}) =>
      getSecoundPane(tab: tab, secoundTab: secoundTab);

  @override
  getFirstPane({TabControllerHelper? tab}) {
    return SliverApiMaster(
      onSelectedCardChangeValueNotifier:
          getCurrentScreenSize() == CurrentScreenSize.MOBILE
              ? null
              : _secoundPaneNotifier,
      // buildAppBar: false,
      buildSearchWidgetAsEditText: isDesktop(context),
    );
  }

  @override
  getSecoundPane({TabControllerHelper? tab, TabControllerHelper? secoundTab}) {
    return ValueListenableBuilder(
      valueListenable: _secoundPaneNotifier,
      builder: (context, value, child) {
        int iD = value?.viewAbstract?.iD ?? -1;
        String tableName = value?.viewAbstract?.getTableNameApi() ?? "";
        Widget currentWidget;
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
  Widget? getFirstPaneAppbar({TabControllerHelper? tab}) => null;

  @override
  List<Widget>? getFirstPaneBottomSheet({TabControllerHelper? tab}) => null;
  @override
  Widget? getFirstPaneFloatingActionButton({TabControllerHelper? tab}) => null;

  @override
  Widget? getSecondPaneAppbar({TabControllerHelper? tab}) {
    return null;
    return const ListTile(
      title: Text("Dasdas"),
    );
  }

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
  bool setBodyPadding(bool firstPane, {TabControllerHelper? tab}) => firstPane;

  @override
  bool setPaddingWhenTowPane(CurrentScreenSize currentScreenSize,
          {TabControllerHelper? tab}) =>
      false;

  @override
  bool setPaneClipRect(bool firstPane, {TabControllerHelper? tab}) =>
      !firstPane;

  void setSecoundPane(ListToDetailsSecoundPaneHelper? newState) {
    _secoundPaneNotifier.value = newState;
  }
}
