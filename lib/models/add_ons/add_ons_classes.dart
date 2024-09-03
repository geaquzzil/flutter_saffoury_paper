import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_saffoury_paper/models/add_ons/cuts_worker/cuts_worker_main.dart';
import 'package:flutter_view_controller/interfaces/posable_interface.dart';
import 'package:flutter_view_controller/new_screens/routes.dart';
import 'package:go_router/src/route.dart';

class CutWorkerRouteAddon extends RouteableInterface {
  @override
  GoRoute? getGoRouteAddOn(BuildContext context) {
    return GoRoute(
        name: reelCutterRouteName,
        path: '/cuts',
        pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: CutWorkerPage(),
            ));
  }
}

// class POSRouteAddon extends RouteableInterface {
//   @override
//   GoRoute? getGoRouteAddOn(BuildContext context) {
//     // TODO: implement getGoRouteAddOn
//     throw UnimplementedError();
//   }
// }

class GoodsInventoryRouteAddon extends RouteableInterface {
  @override
  GoRoute? getGoRouteAddOn(BuildContext context) {
    return GoRoute(
        name: goodsInventoryRouteName,
        path: '/inventory',
        pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: CutWorkerPage(),
            ));
  }
}
