import 'package:flutter/material.dart';

abstract class PosableInterface {
  /// get future that fired when pos widget is created
  Future<dynamic> getPosableInitObj(BuildContext context);

  Widget getPosableMainWidget(
      BuildContext context, AsyncSnapshot<dynamic> snapshotResponse);
}
