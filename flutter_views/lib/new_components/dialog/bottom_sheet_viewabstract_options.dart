import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_api_master.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_api_master_new.dart';

class BottomSheetDialogWidget extends StatelessWidget {
  ViewAbstract viewAbstract;
  SliverApiWithStaticMixin? state;
  BottomSheetDialogWidget({super.key, required this.viewAbstract, this.state});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        getListTile(context),
        const Divider(),
        viewAbstract.onFutureAllPopupMenuLoaded(context, ServerActions.list,
            onPopupMenuListLoaded: (items) => Column(
                children: items
                    .map((e) => viewAbstract.buildMenuItemListTile(context, e))
                    .toList()),
            state: state)
      ],
    );
  }

  Widget getListTile(BuildContext context) {
    return ListTile(
      selectedTileColor: Theme.of(context).colorScheme.onSecondary,
      title: (viewAbstract.getMainHeaderText(context)),
      subtitle: (viewAbstract.getMainSubtitleHeaderText(context)),
      leading: viewAbstract.getCardLeading(context),
    );
    // trailing: object.getPopupMenuActionListWidget(context));
  }
}
