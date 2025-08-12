import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/interfaces/dashable_interface.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/new_screens/actions/dashboard/compontents/section_item_header.dart';
import 'package:flutter_view_controller/new_screens/base_page.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/components/staggerd_grid_view_widget.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';

const mediumPane = 0.62;
const largePane = 0.7;

class BaseDashboardMainPage extends BasePageApi {
  BaseDashboardMainPage({
    super.key,
    super.buildDrawer,
    super.buildSecondPane,
    super.iD,
    super.tableName,
    super.isFirstToSecOrThirdPane = true,
    super.extras,
    super.onBuild,
    super.parent,
  });

  @override
  State<BaseDashboardMainPage> createState() => _BaseDashboardMainPageState();
}

class _BaseDashboardMainPageState
    extends BasePageStateWithApi<BaseDashboardMainPage>
    with BasePageSecoundPaneNotifierState<BaseDashboardMainPage> {
  //  late DashableInterface dashboard;
  @override
  List<TabControllerHelper>? initTabBarList({
    bool? firstPane,
    TabControllerHelper? tab,
  }) {
    if (firstPane == null && tab == null) {
      return context
          .read<AuthProvider<AuthUser>>()
          .getListableOfDashablesInterface()
          .map((e) {
            debugPrint(
              "getTabBarList getCustomAction:${(e as ViewAbstract).getCustomAction()}",
            );
            ViewAbstract v = e as ViewAbstract;
            return TabControllerHelper(
              titleFunction: (context) {
                debugPrint("getTabBarList called");
                return v.getMainHeaderLabelTextOnly(context) ?? "sda";
              },
              extras: v,
              // icon: Icon(v.getMainIconData()),
            );
          })
          .toList();
    }
    if (firstPane != null && !firstPane) {
      return getExtrasCastDashboard(
        tab: tab,
      ).getDashboardTabbarSectionSecoundPaneList(
        context,
        getSecoundPaneHelper(),
      );
    }
    return null;
  }

  @override
  Widget? getFloatingActionButtonPaneNotifier({
    bool? firstPane,
    TabControllerHelper? tab,
    TabControllerHelper? secoundTab,
  }) {
    return null;
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
  String onActionInitial() {
    return AppLocalizations.of(context)!.dashboard_and_rep;
  }

  @override
  Widget? getAppbarTitle({
    bool? firstPane,
    TabControllerHelper? tab,
    TabControllerHelper? secoundTab,
  }) {
    if (firstPane == null) {
      return Text(
        AppLocalizations.of(context)!.dashboard_and_rep,
        style: Theme.of(context).textTheme.titleLarge,
      );
      // return ListTile(
      //   title: Row(
      //     children: [
      //       Expanded(
      //         child: Padding(
      //           padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
      //           child: Text(
      //             AppLocalizations.of(context)!.dashboard_and_rep,
      //             style: Theme.of(context).textTheme.headlineMedium,
      //           ),

      //           // SearchWidgetComponent(onSearchTextChanged: (text) {
      //           //   debugPrint("search for $text");
      //           // }),
      //         ),
      //       ),
      //       if (isPrintable(tab: tab))
      //         IconButton(
      //           onPressed: () {
      //             getExtrasCast(tab: tab).printPage(context, standAlone: true);
      //           },
      //           icon: const Icon(Icons.print),
      //         ),
      //       // IconButton(onPressed: () {}, icon: const Icon(Icons.safety_check)),
      //       // IconButton(
      //       //     onPressed: () {}, icon: const Icon(Icons.baby_changing_station)),
      //       IconButton(
      //         onPressed: () {},
      //         icon: const Icon(Icons.notification_add),
      //       ),
      //       const ProfilePicturePopupMenu(),
      //     ],
      //   ),
      //   // subtitle: Row(
      //   //   children: [
      //   //     Expanded(child: DashboardHeader()),
      //   //     DateSelector(),
      //   //     Spacer()
      //   //   ],
      //   // ),
    } else {
      return getExtrasCastDashboard(tab: tab ?? secoundTab).getDashboardAppbar(
        context,
        firstPane: firstPane,
        tab: tab ?? secoundTab,
        basePage: getSecoundPaneHelper(),
      );
    }
  }

  Widget getWidget(DashableGridHelper element) {
    return StaggerdGridViewWidget(
      builder:
          (
            fullCrossAxisCount,
            crossCountFundCalc,
            crossAxisCountMod,
            heightMainAxisCellCount,
          ) => element.widgets
              .map(
                (e) => e.widget.call(
                  fullCrossAxisCount,
                  crossCountFundCalc,
                  crossAxisCountMod,
                  heightMainAxisCellCount,
                ),
              )
              .toList(),
      wrapWithCard: element.wrapWithCard,
      // crossAxisCount: getCrossAxisCount(getWidth),
      childAspectRatio: 1,

      // width < 1400 ? 1.1 : 1.4,
    );
  }

  Widget getSecondPaneWidget(DashableGridHelper element) {
    return StaggerdGridViewWidget(
      builder:
          (
            fullCrossAxisCount,
            crossCountFundCalc,
            crossAxisCountMod,
            heightMainAxisCellCount,
          ) => element.widgets
              .map(
                (e) => e.widget.call(
                  fullCrossAxisCount,
                  crossCountFundCalc,
                  crossAxisCountMod,
                  heightMainAxisCellCount,
                ),
              )
              .toList(),
      wrapWithCard: element.wrapWithCard,
      // crossAxisCount: 2,
      childAspectRatio: 1.4,

      // width < 1400 ? 1.1 : 1.4,
    );
  }

  List<Widget> getDesktopFirstPane({TabControllerHelper? tab}) {
    debugPrint("getDesktopFirstPane tab is ${tab?.extras.runtimeType}");
    // debugPrint("getDesktopFirstPane tab getExtras ${getExtras().debitsDue}");
    List<Widget> widgets = List.empty(growable: true);
    var list = getExtrasCastDashboard(tab: tab).getDashboardSectionsFirstPane(
      context,
      tab: tab,
      basePage: getSecoundPaneHelper(),
    );
    if (list is List<DashableGridHelper>) {
      for (var element in list) {
        GlobalKey buttonKey = GlobalKey();
        var group = [
          SectionItemHeader(
            context: context,
            dgh: element,
            buttonKey: buttonKey,
            basePage: getSecoundPaneHelper(),
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

  List<Widget> getDesktopSecondPane({
    TabControllerHelper? tab,
    TabControllerHelper? secoundTab,
  }) {
    debugPrint("getPane $tab secoundTab $secoundTab");

    var list = getExtrasCastDashboard(tab: tab).getDashboardSectionsSecoundPane(
      context,
      tab: tab,
      basePage: getSecoundPaneHelper(),
      tabSecondPane: secoundTab,
    );
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
            basePage: getSecoundPaneHelper(),
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
  List<Widget>? getCustomViewWhenSecondPaneIsEmpty(
    ScrollController? controler,
    TabControllerHelper? tab,
  ) {
    return getDesktopSecondPane(tab: tab);
  }

  @override
  List<Widget>? getPaneNotifier({
    required bool firstPane,
    ScrollController? controler,
    TabControllerHelper? tab,
    SecondPaneHelper? valueNotifier,
  }) {
    debugPrint("getPane =>firstPane $firstPane=>tab $tab=> ");
    if (firstPane) {
      return getDesktopFirstPane(tab: tab);
    } else {
      return getDesktopSecondPane(tab: tab);
    }
  }

  @override
  bool setPaneBodyPaddingHorizontal(bool firstPane) {
    return !firstPane;
  }

  @override
  bool setMainPageSuggestionPadding() => false;

  @override
  bool setHorizontalDividerWhenTowPanes() => false;

  @override
  FutureOr? getOverrideCallApiFunction(
    BuildContext context, {
    TabControllerHelper? tab,
  }) {
    // return null;
    dynamic ex = getExtras(tab: tab);
    debugPrint("getCallApiFunctionIfNull extras=> $ex ");
    return (ex as ViewAbstract).viewCall(
      context: context,
      lastObject: getLastExtras,
    );
  }

  @override
  ServerActions getServerActions() {
    return ServerActions.view;
  }

  @override
  bool isPaneScaffoldOverlayColord(bool firstPane) {
    return false;
  }

  @override
  bool setClipRect(bool? firstPane) {
    return false;
  }

  @override
  Widget? getPaneDraggableExpandedHeader({
    required bool firstPane,
    TabControllerHelper? tab,
  }) {
    return null;
  }

  @override
  Widget? getPaneDraggableHeader({
    required bool firstPane,
    TabControllerHelper? tab,
  }) {
    return null;
  }

  @override
  Future<void>? getPaneIsRefreshIndicator({required bool firstPane}) {
    return null;
  }
}
