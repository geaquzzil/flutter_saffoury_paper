import 'package:flutter/material.dart';
import 'package:flutter_view_controller/interfaces/posable_interface.dart';
import 'package:flutter_view_controller/new_components/tow_pane_ext.dart';
import 'package:flutter_view_controller/new_screens/pos/pos_description.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';

class POSPage extends StatelessWidget {
  const POSPage({super.key});

  @override
  Widget build(BuildContext context) {
    var pos = context
        .read<AuthProvider<AuthUser>>()
        .getDrawerItemsPermissions
        .whereType<PosableInterface>()
        .toList();

    // debugPrint(
    //     " ${context.read<AuthProvider<AuthUser>>().getDrawerItemsPermissions}  =>pos $pos");

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: TowPaneExt(
          customPaneProportion: SizeConfig.getPaneProportion(context),
          startPane: FutureBuilder(
            future: (pos[0]).getPosableInitObj(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return (pos[0]).getPosableMainWidget(context, snapshot);
              }
              return const Expanded(
                  child: Center(child: CircularProgressIndicator()));
            },
          ),
          endPane: const POSDescription(),
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
                    return const Expanded(
                        child: Center(child: CircularProgressIndicator()));
                  },
                )),
            // VerticalDivider(
            //   color: Theme.of(context).colorScheme.outline,
            // ),
            const Expanded(
              flex: 1,
              child: POSDescription(),
            ),
          ]),
        ),
      ),
    );
  }
}
