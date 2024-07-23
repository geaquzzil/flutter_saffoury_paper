// import 'dart:math';

// import 'package:connectivity_listener/connectivity_listener.dart';
// import 'package:dual_screen/dual_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_view_controller/constants.dart';
// import 'package:flutter_view_controller/customs_widget/color_tabbar.dart';
// import 'package:flutter_view_controller/customs_widget/sliver_delegates.dart';
// import 'package:flutter_view_controller/ext_utils.dart';
// import 'package:flutter_view_controller/interfaces/dashable_interface.dart';
// import 'package:flutter_view_controller/models/servers/server_helpers.dart';
// import 'package:flutter_view_controller/models/view_abstract.dart';
// import 'package:flutter_view_controller/models/view_abstract_base.dart';
// import 'package:flutter_view_controller/new_components/tow_pane_ext.dart';
// import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
// import 'package:flutter_view_controller/providers/actions/list_multi_key_provider.dart';
// import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
// import 'package:flutter_view_controller/size_config.dart';
// import 'package:provider/provider.dart';
// import 'package:web_smooth_scroll/web_smooth_scroll.dart';
// import 'package:flutter_gen/gen_l10n/app_localization.dart';
// /// WebSmothSceroll additional offset to users scroll input WEB WAS 150
// const scrollOffset = 10;

// ///WebSmothSceroll animation duration WEB WAS 600
// const animationDuration = 250;

// const double kDefualtAppBar = 70;

// const double kDefualtClipRect = 25;

import 'package:flutter/widgets.dart';
import 'package:flutter_view_controller/interfaces/dashable_interface.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_stand_alone.dart';
import 'package:flutter_view_controller/new_screens/actions/dashboard/base_dashboard_screen_page_new.dart';
import 'package:flutter_view_controller/new_screens/actions/view/base_home_details_view.dart';
import 'package:flutter_view_controller/new_screens/actions/view/view_stand_alone.dart';
import 'package:flutter_view_controller/new_screens/home/list_to_details_widget.dart';
import 'package:flutter_view_controller/new_screens/home/list_to_details_widget_new.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class BaseDeterminePageState extends StatelessWidget {
  const BaseDeterminePageState({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<
        DrawerMenuControllerProvider,
        Tuple3<ViewAbstract, ViewAbstractStandAloneCustomViewApi?,
            ViewAbstract?>>(
      builder: (context, value, child) {
        ViewAbstract listable = value.item1;
        ViewAbstract? dashboard = value.item3;
        ViewAbstractStandAloneCustomViewApi? customView = value.item2;
        if (dashboard != null) {
          return const BaseDashboardMainPage(
            title: "D",
          );
        } else if (customView != null) {
          return MasterViewStandAlone(viewAbstract: customView);
        } else {
          return const ListToDetailsPageNew(
            title: "SOSO",
          );
        }
      },
      selector: (p0, p1) =>
          Tuple3(p1.getObject, p1.getStandAloneCustomView, p1.getDashboard),
    );
  }
}
