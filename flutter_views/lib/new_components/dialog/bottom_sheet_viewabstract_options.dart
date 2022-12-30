import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter/material.dart';

class BottomSheetDialogWidget extends StatelessWidget {
  ViewAbstract viewAbstract;
  BottomSheetDialogWidget({super.key, required this.viewAbstract});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        getListTile(context),
        Divider(),
        viewAbstract.onFutureAllPopupMenuLoaded(
          context,
          ServerActions.list,
          onPopupMenuListLoaded: (items) => Column(
              children: items
                  .map((e) => viewAbstract.buildMenuItemListTile(context, e))
                  .toList()),
        )
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
