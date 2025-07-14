import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract class PosableInterface {
  /// get future that fired when pos widget is created
  Future<dynamic> getPosableInitObj(BuildContext context);

  Widget getPosableMainWidget(
      BuildContext context, AsyncSnapshot<dynamic> snapshotResponse);

  Widget getPosableOnAddWidget(BuildContext context);
}

abstract class RouteableInterface {
  GoRoute? getGoRouteAddOn(BuildContext context);
}
