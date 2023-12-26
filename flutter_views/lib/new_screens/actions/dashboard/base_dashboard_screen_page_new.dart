import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/interfaces/dashable_interface.dart';
import 'package:flutter_view_controller/models/apis/date_object.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/new_screens/actions/dashboard/base_dashboard_screen_page.dart';
import 'package:flutter_view_controller/new_screens/actions/dashboard/compontents/header.dart';
import 'package:flutter_view_controller/new_screens/base_page.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/my_files.dart';
import 'package:flutter_view_controller/new_screens/home/components/profile/profile_pic_popup_menu.dart';
import 'package:flutter_view_controller/new_screens/lists/components/search_components.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

const mediumPane = 0.65;
const largePane = 0.75;

class BaseDashboardMainPage extends StatefulWidget {
  final String title;
  BaseDashboardMainPage({
    super.key,
    required this.title,
  });

  @override
  State<BaseDashboardMainPage> createState() => _BaseDashboardMainPageState();
}

class _BaseDashboardMainPageState
    extends BasePageWithApi<BaseDashboardMainPage> {
  //  late DashableInterface dashboard;
  @override
  List<TabControllerHelper>? initTabBarList() {
    return context
        .read<AuthProvider<AuthUser>>()
        .getListableOfDashablesInterface()
        .map((e) {
      debugPrint("getTabBarList ${(e as ViewAbstract).getCustomAction()}");
      ViewAbstract v = e as ViewAbstract;
      return TabControllerHelper(
        v.getCustomAction() ?? "sda",
        extras: v,
        // icon: Icon(v.getMainIconData()),
      );
    }).toList();
  }

  @override
  List<TabControllerHelper>? initTabBarListSecondPane(
      {TabControllerHelper? tab}) {
    return getExtrasCastDashboard(tab: tab)
        .getDashboardTabbarSectionSecoundPaneList(context);
  }

  @override
  double getCustomPaneProportion() {
    {
      if (SizeConfig.isMediumFromScreenSize(context)) {
        return mediumPane;
      } else {
        CurrentScreenSize s = getCurrentScreenSize();
        double defualtWidth = 0;
        if (s case CurrentScreenSize.DESKTOP) {
          defualtWidth = kDesktopWidth;
          return largePane;
        } else if (s case CurrentScreenSize.LARGE_TABLET) {
          defualtWidth = kLargeTablet;
        } else if (s case CurrentScreenSize.MOBILE) {
          return mediumPane;
        }

        // double sss = max(
        //   defualtWidth - _width,
        //   _width - defualtWidth,
        // );
        // debugPrint(
        //     " current width $_width  defualt width $defualtWidth   VALUE=${sss}  ");

        return mediumPane;
      }
    }
  }

  bool isPrintable({TabControllerHelper? tab}) {
    return (getExtrasCast(tab: tab)).isPrintableMaster();
  }

  @override
  Widget? getBaseAppbar({TabControllerHelper? tab}) {
    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: kDefaultPadding,
                ),
                child: Text(AppLocalizations.of(context)!.dashboard_and_rep,
                    style: Theme.of(context).textTheme.headlineMedium)

                // SearchWidgetComponent(onSearchTextChanged: (text) {
                //   debugPrint("search for $text");
                // }),
                ),
          ),
          if (isPrintable(tab: tab))
            IconButton(
                onPressed: () {
                  getExtrasCast(tab: tab).printPage(context);
                },
                icon: const Icon(Icons.print)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.safety_check)),
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.baby_changing_station)),
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
  Widget? getBaseBottomSheet() => null;

  @override
  Widget? getBaseFloatingActionButton({TabControllerHelper? tab}) {
    // TODO: implement getBaseFloatingActionButton
    return null;
  }

  ///cross axis count is from width how many items
  int getCrossAxisCount(double width) {
    ///1000/6
    ///
    ///
    ///
    if (width < 1000) {
      return 2;
    } else {
      int val = ((width / 300)).toInt();
      debugPrint("getCrossAxisCount val   $val");
      return val;
    }

    if (width < 1000) {
      return 2;
    } else if (width >= 1000 && width < 1200) {
      return 3;
    } else if (width >= 1200 && width < 1400) {
      return 4;
    } else if (width >= 1400 && width < 1600) {
      return 5;
    } else {
      return 6;
    }
  }

  Widget getWidget(
    DashableGridHelper element,
  ) {
    return FileInfoStaggerdGridView(
        list: element.widgets.map((e) => e.widget).toList(),
        wrapWithCard: element.wrapWithCard,
        crossAxisCount: getCrossAxisCount(getWidth),
        childAspectRatio: 1

        // width < 1400 ? 1.1 : 1.4,
        );
  }

  Widget getSecondPaneWidget(
    DashableGridHelper element,
  ) {
    return FileInfoStaggerdGridView(
        list: element.widgets.map((e) => e.widget).toList(),
        wrapWithCard: element.wrapWithCard,
        crossAxisCount: 2,
        childAspectRatio: 1.4

        // width < 1400 ? 1.1 : 1.4,
        );
  }

  @override
  getDesktopFirstPane({TabControllerHelper? tab}) {
    debugPrint("getDesktopFirstPane tab is ${tab?.extras.runtimeType}");
    // debugPrint("getDesktopFirstPane tab getExtras ${getExtras().debitsDue}");
    List<Widget> widgets = List.empty(growable: true);
    var list = getExtrasCastDashboard(tab: tab).getDashboardSectionsFirstPane(
        context, getCrossAxisCount(getWidth),
        tab: tab, globalKey: globalKeyBasePageWithApi);
    if (list is List<DashableGridHelper>) {
      for (var element in list) {
        GlobalKey buttonKey = GlobalKey();
        var group = [
          SectionItemHeader(
            context: context,
            dgh: element,
            buttonKey: buttonKey,
            child: getWidget(element),
          ),
          // SliverToBoxAdapter(child: getWidget(width, element))
        ];
        widgets.addAll(group);
      }
    } else if (list is List<Widget>) {
      widgets.addAll(list);
    } else {
      widgets.add(list);
    }
    return widgets;
  }

  @override
  getDesktopSecondPane(
      {TabControllerHelper? tab, TabControllerHelper? secoundTab}) {
    var list = getExtrasCastDashboard(tab: tab).getDashboardSectionsSecoundPane(
        context, getCrossAxisCount(getWidth),
        tab: tab,
        globalKey: globalKeyBasePageWithApi,
        tabSecondPane: secoundTab);
    // if (secoundTab != null) {
    //   return list;
    // }
    List<Widget> widgets = List.empty(growable: true);
    if (list is List<DashableGridHelper>) {
      for (var element in list) {
        GlobalKey buttonKey = GlobalKey();
        var group = [
          SectionItemHeader(
            context: context,
            dgh: element,
            buttonKey: buttonKey,
            child: getSecondPaneWidget(element),
          ),
          // SliverToBoxAdapter(child: getWidget(width, element))
        ];
        widgets.addAll(group);
      }
    } else if (list is List<Widget>) {
      widgets.addAll(list);
    } else {
      widgets.add(list);
    }
    return widgets;
  }

  @override
  getFirstPane({TabControllerHelper? tab}) {
    // TODO: implement getFirstPane
    return getDesktopFirstPane(tab: tab);
  }

  @override
  Widget? getFirstPaneAppbar({TabControllerHelper? tab}) {
    return getExtrasCastDashboard(tab: tab).getDashboardAppbar(
      context,
      firstPane: true,
      tab: tab,
      globalKey: globalKeyBasePageWithApi,
    );
  }

  @override
  Widget? getFirstPaneBottomSheet({TabControllerHelper? tab}) {
    // TODO: implement getFirstPaneBottomSheet
    return null;
  }

  @override
  Widget? getFirstPaneFloatingActionButton({TabControllerHelper? tab}) {
    // TODO: implement getFirstPaneFloatingActionButton
    return null;
  }

  @override
  Widget? getSecondPaneAppbar({TabControllerHelper? tab}) {
    return getExtrasCastDashboard(tab: tab).getDashboardAppbar(
      context,
      firstPane: false,
      tab: tab,
      globalKey: globalKeyBasePageWithApi,
    );
  }

  @override
  Widget? getSecondPaneBottomSheet({TabControllerHelper? tab}) {
    // TODO: implement getSecondPaneBottomSheet
    return null;
  }

  @override
  Widget? getSecondPaneFloatingActionButton({TabControllerHelper? tab}) {
    // TODO: implement getSecondPaneFloatingActionButton
    return null;
  }

  @override
  getSecoundPane({TabControllerHelper? tab, TabControllerHelper? secoundTab}) {
    // TODO: implement getSecoundPane
    return getDesktopSecondPane(tab: tab, secoundTab: secoundTab);
  }

  @override
  bool isPanesIsSliver(bool firstPane, {TabControllerHelper? tab}) => true;

  @override
  bool setBodyPadding(bool firstPane, {TabControllerHelper? tab}) {
    return true;
  }

  @override
  bool setPaddingWhenTowPane(CurrentScreenSize currentScreenSize,
      {TabControllerHelper? tab}) {
    // TODO: implement setPaddingWhenTowPane
    return false;
  }

  @override
  Future getCallApiFunctionIfNull(BuildContext context,
          {TabControllerHelper? tab}) =>
      getExtras(tab: tab).callApi();

  @override
  ServerActions getServerActions() {
    return ServerActions.view;
  }

  @override
  bool isPaneScaffoldOverlayColord(bool firstPane, {TabControllerHelper? tab}) {
    return false;
    return !firstPane;
  }

  @override
  bool setPaneClipRect(bool firstPane, {TabControllerHelper? tab}) {
    return false;
    return !firstPane;
  }
}
