import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_api_master_new.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';

class BottomSheetDialogWidget extends StatelessWidget {
  final ViewAbstract viewAbstract;
  final SliverApiWithStaticMixin? state;
  final SecoundPaneHelperWithParentValueNotifier? base;
  const BottomSheetDialogWidget({
    super.key,
    required this.viewAbstract,
    this.state,
    this.base,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        getListTile(context),
        const Divider(),
        ...viewAbstract
            .getActions(context: context, action: ServerActions.list)
            .map(
              (e) => viewAbstract.buildListActionItem(
                context,
                e,
                secPaneHelper: base,
              ),
            ),
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
