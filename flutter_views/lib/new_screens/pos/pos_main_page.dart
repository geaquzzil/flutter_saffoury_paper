import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/interfaces/posable_interface.dart';
import 'package:flutter_view_controller/new_components/tab_bar/tab_bar_by_list.dart';
import 'package:flutter_view_controller/new_components/tow_pane_ext.dart';
import 'package:flutter_view_controller/new_screens/pos/pos_description.dart';
import 'package:flutter_view_controller/new_screens/lists/pos_list.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';

import '../../models/view_abstract_base.dart';
import '../cart/cart_description/cart_description.dart';
import '../actions/dashboard/compontents/header.dart';

class POSPage extends StatelessWidget {
  POSPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var pos = context
        .read<AuthProvider>()
        .getDrawerItemsPermissions
        .whereType<PosableInterface>()
        .toList();

    // debugPrint(
    //     " ${context.read<AuthProvider>().getDrawerItemsPermissions}  =>pos $pos");

    return Scaffold(
        body: TowPaneExt(
      customPaneProportion: SizeConfig.getPaneProportion(context),
      startPane: FutureBuilder(
        future: (pos[0]).getPosableInitObj(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return (pos[0]).getPosableMainWidget(context, snapshot);
          }
          return Expanded(child: Center(child: CircularProgressIndicator()));
        },
      ),
      endPane: POSDescription(),
    ));

    SafeArea(
      child: Container(
        // padding: EdgeInsets.all(kDefaultPadding),
        child: Expanded(
          child: Row(children: [
            Expanded(
                flex: 2,
                child: FutureBuilder(
                  future: (pos[0]).getPosableInitObj(context),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return (pos[0]).getPosableMainWidget(context, snapshot);
                    }
                    return Expanded(
                        child: Center(child: CircularProgressIndicator()));
                  },
                )),
            // VerticalDivider(
            //   color: Theme.of(context).colorScheme.outline,
            // ),
            Expanded(
              flex: 1,
              child: Container(
                  // color: Theme.of(context).colorScheme.onBackground,
                  child: POSDescription()),
            ),
          ]),
        ),
      ),
    );
  }
}
