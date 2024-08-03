import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/new_screens/base_page.dart';
import 'package:flutter_view_controller/new_screens/home/components/profile/profile_pic_popup_menu.dart';
import 'package:flutter_view_controller/new_screens/lists/components/search_componenets_editable.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_api_master.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:flutter_view_controller/screens/web/views/web_product_view.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListToDetailsPageNew extends StatefulWidget {
  final String title;
  bool buildDrawer;

  ListToDetailsPageNew(
      {super.key, required this.title, this.buildDrawer = true});

  @override
  State<ListToDetailsPageNew> createState() => _ListToDetailsPageNewState();
}

class _ListToDetailsPageNewState extends BasePageState<ListToDetailsPageNew> {
  ValueNotifier<ViewAbstract?> dsada = ValueNotifier<ViewAbstract?>(null);

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
    if (!isLargeScreenFromCurrentScreenSize(context)) {
      return null;
    }
    return ListTile(
      title: Row(
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

          // IconButton(
          //     onPressed: () {
          //       getExtrasCast(tab: tab).printPage(context);
          //     },
          //     icon: const Icon(Icons.print)),
          // IconButton(onPressed: () {}, icon: const Icon(Icons.safety_check)),
          // IconButton(
          //     onPressed: () {}, icon: const Icon(Icons.baby_changing_station)),
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.notification_add)),
          const ProfilePicturePopupMenu()
        ],
      ),
      // subtitle: Row(
      //   children: [
      //     Expanded(child: DashboardHeader()),
      //     DateSelector(),
      //     Spacer()
      //   ],
      // ),
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
      onSelectedCardChangeValueNotifier: dsada,
      // buildAppBar: false,
      buildSearchWidgetAsEditText: isDesktop(context),
    );
  }

  @override
  getSecoundPane({TabControllerHelper? tab, TabControllerHelper? secoundTab}) {
    return ValueListenableBuilder(
      valueListenable: dsada,
      builder: (context, value, child) {
        if (value == null) {
          return Text("NULL");
        }
        return WebProductView(
          onHorizontalItemClick: dsada,
          iD: int.parse(value.getIDString()),
          buildFooter: false,
          usePagePadding: false,
          buildHeader: false,
          tableName: value.getTableNameApi()!,
          extras: value,
        );
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
  Widget? getSecondPaneAppbar({TabControllerHelper? tab}) => null;

  @override
  List<Widget>? getSecondPaneBottomSheet({TabControllerHelper? tab}) => null;
  @override
  Widget? getSecondPaneFloatingActionButton({TabControllerHelper? tab}) => null;

  @override
  bool isPaneScaffoldOverlayColord(bool firstPane,
          {TabControllerHelper? tab}) =>
      false;

  @override
  bool isPanesIsSliver(bool firstPane, {TabControllerHelper? tab}) => false;

  @override
  bool setBodyPadding(bool firstPane, {TabControllerHelper? tab}) => !firstPane;

  @override
  bool setPaddingWhenTowPane(CurrentScreenSize currentScreenSize,
          {TabControllerHelper? tab}) =>
      false;

  @override
  bool setPaneClipRect(bool firstPane, {TabControllerHelper? tab}) => false;
}
