import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/interfaces/dashable_interface.dart';
import 'package:flutter_view_controller/models/apis/date_object.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/new_screens/actions/dashboard/base_dashboard_screen_page.dart';
import 'package:flutter_view_controller/new_screens/actions/dashboard/compontents/date_selector.dart';
import 'package:flutter_view_controller/new_screens/actions/dashboard/compontents/header.dart';
import 'package:flutter_view_controller/new_screens/base_page.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/dashboard.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/my_files.dart';
import 'package:flutter_view_controller/new_screens/home/components/profile/profile_pic_popup_menu.dart';
import 'package:flutter_view_controller/new_screens/lists/components/search_componenets_editable.dart';
import 'package:flutter_view_controller/new_screens/lists/components/search_components.dart';
import 'package:flutter_view_controller/size_config.dart';

const mediumPane = 0.65;
const largePane = 0.75;

class BaseDashboardMainPage extends StatefulWidget {
  final DashableInterface dashboard;
  final String title;
  const BaseDashboardMainPage(
      {super.key, required this.title, required this.dashboard});

  @override
  State<BaseDashboardMainPage> createState() => _BaseDashboardMainPageState();
}

class _BaseDashboardMainPageState
    extends BasePageWithApi<BaseDashboardMainPage> {
  //  late DashableInterface dashboard;

  @override
  void initState() {
    extras = widget.dashboard;
    super.initState();
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

  @override
  Widget? getBaseAppbar(CurrentScreenSize currentScreenSize) {
    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: kDefaultPadding,
              ),
              child: SearchWidgetComponent(onSearchTextChanged: (text) {
                debugPrint("search for $text");
              }),
            ),
          ),
          IconButton(onPressed: () {}, icon: Icon(Icons.tab)),
          IconButton(onPressed: () {}, icon: Icon(Icons.safety_check)),
          IconButton(onPressed: () {}, icon: Icon(Icons.baby_changing_station)),
          IconButton(onPressed: () {}, icon: Icon(Icons.notification_add)),
          ProfilePicturePopupMenu()
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
  Widget? getBaseFloatingActionButton(CurrentScreenSize currentScreenSize) {
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
    double width,
    DashableGridHelper element,
  ) {
    return FileInfoStaggerdGridView(
        list: element.widgets.map((e) => e.widget).toList(),
        wrapWithCard: element.wrapWithCard,
        crossAxisCount: getCrossAxisCount(width),
        childAspectRatio: 1

        // width < 1400 ? 1.1 : 1.4,
        );
  }

  Widget getSecondPaneWidget(
    double width,
    DashableGridHelper element,
  ) {
    return FileInfoStaggerdGridView(
        list: element.widgets.map((e) => e.widget).toList(),
        wrapWithCard: element.wrapWithCard,
        crossAxisCount: 1,
        childAspectRatio: 1.4

        // width < 1400 ? 1.1 : 1.4,
        );
  }

  @override
  getDesktopFirstPane(double width) {
    List<Widget> widgets = List.empty(growable: true);
    List<DashableGridHelper> list = getExtras()
        .getDashboardSectionsFirstPane(context, getCrossAxisCount(width));

    for (var element in list) {
      GlobalKey buttonKey = GlobalKey();
      var group = [
        SectionItemHeader(
          context: context,
          dgh: element,
          buttonKey: buttonKey,
          child: getWidget(width, element),
        ),
        // SliverToBoxAdapter(child: getWidget(width, element))
      ];
      widgets.addAll(group);
    }
    return widgets;
  }

  @override
  getDesktopSecondPane(double width) {
    List<DashableGridHelper> list = getExtras()
        .getDashboardSectionsSecoundPane(context, getCrossAxisCount(width));
    List<Widget> widgets = List.empty(growable: true);

    for (var element in list) {
      GlobalKey buttonKey = GlobalKey();
      var group = [
        SectionItemHeader(
          context: context,
          dgh: element,
          buttonKey: buttonKey,
          child: getSecondPaneWidget(width, element),
        ),
        // SliverToBoxAdapter(child: getWidget(width, element))
      ];
      widgets.addAll(group);
    }
    return widgets;
  }

  @override
  getFirstPane(double width) {
    // TODO: implement getFirstPane
    return getDesktopFirstPane(width);
  }

  @override
  Widget? getFirstPaneAppbar(CurrentScreenSize currentScreenSize) {
    return DashboardHeader(
      date: extras?.date ?? DateObject(),
      current_screen_size: currentScreenSize,
      onSelectedDate: (d) {
        if (d == null) return;
        extras.setDate(d);
        refresh(extras: extras);
      },
    );
  }

  @override
  Widget? getFirstPaneBottomSheet() {
    // TODO: implement getFirstPaneBottomSheet
    return null;
  }

  @override
  Widget? getFirstPaneFloatingActionButton(
      CurrentScreenSize currentScreenSize) {
    // TODO: implement getFirstPaneFloatingActionButton
    return null;
  }

  @override
  Widget? getSecondPaneAppbar(CurrentScreenSize currentScreenSize) {
    // TODO: implement getSecondPaneAppbar
    return null;
  }

  @override
  Widget? getSecondPaneBottomSheet() {
    // TODO: implement getSecondPaneBottomSheet
    return null;
  }

  @override
  Widget? getSecondPaneFloatingActionButton(
      CurrentScreenSize currentScreenSize) {
    // TODO: implement getSecondPaneFloatingActionButton
    return null;
  }

  @override
  getSecoundPane(double width) {
    // TODO: implement getSecoundPane
    return getDesktopSecondPane(width);
  }

  @override
  bool isPanesIsSliver(bool firstPane) => true;

  @override
  bool setBodyPadding(bool firstPane) {
    return true;
  }

  @override
  bool setPaddingWhenTowPane(CurrentScreenSize currentScreenSize) {
    // TODO: implement setPaddingWhenTowPane
    return false;
  }

  @override
  Future getCallApiFunctionIfNull(BuildContext context) =>
      getExtras().callApi();

  @override
  ServerActions getServerActions() {
    return ServerActions.view;
  }

  @override
  bool isPaneScaffoldOverlayColord(bool firstPane) {
    return false;
    return !firstPane;
  }

  @override
  bool setPaneClipRect(bool firstPane) {
    return false;
    return !firstPane;
  }
}
