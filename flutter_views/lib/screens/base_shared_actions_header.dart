import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/action_view_abstract_provider.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';

class BaseSharedHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Row(
        children: [
          // We need this back button on mobile only
          if (SizeConfig.isMobile(context)) BackButton(),
          IconButton(
            icon: Icon(Icons.delete_outline),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.replay_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.reply_all_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.transfer_within_a_station_outlined),
            onPressed: () {},
          ),
          Spacer(),
          // We don't need print option on mobile
          if (SizeConfig.isDesktop(context))
            IconButton(
              icon: Icon(Icons.print_disabled_outlined),
              onPressed: () {},
            ),
          IconButton(
            icon: Icon(Icons.mark_as_unread_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_horiz),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget buildList(BuildContext context) {
    final action = context.watch<ActionViewAbstractProvider>().getServerActions;
    final ViewAbstract = context.watch<ActionViewAbstractProvider>().getObject;
    if (action == ServerActions.edit || action == ServerActions.add) {
      // ViewAbstract.getAppBarActionsView(context)
      // return ListView.builder(

      //   itemBuilder: (context,(context, index) {

      // }));

    }
    return Text("");
  }
}
