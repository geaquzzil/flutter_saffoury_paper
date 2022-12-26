import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/interfaces/settings/ModifiableInterfaceAndPrintingSetting.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_master.dart';
import 'package:flutter_view_controller/new_screens/lists/list_static_master.dart';
import 'package:flutter_view_controller/new_screens/lists/list_sticky_widget.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

import '../../components/expansion_tile_custom.dart';

class ListMultibleViews extends ListStaticMaster<ListStickyItem> {
  ListMultibleViews({Key? key, required List<ListStickyItem> list})
      : super(key: key, list: list);

  Widget _getGroupSeparator(BuildContext ctx, ListStickyItem element) {
    return Text(
      element.groupItem.groupName,
      style: Theme.of(ctx).textTheme.titleMedium!.copyWith(color: Colors.grey),
    );
  }

  @override
  Widget getListViewWidget(
      {required BuildContext context, required List<ListStickyItem> list}) {
    return ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(parent: NeverScrollableScrollPhysics()),
      itemCount: list.length,
      itemBuilder: (context, index) {
        var element = list[index];
        if (element.buildGroupNameInsideItemBuilder) {
          return element.useExpansionTile
              ? ExpansionTileCustom(
                  useLeadingOutSideCard: false,
                  padding: false,
                  title: _getGroupSeparator(context, element),
                  leading: element.groupItem.icon == null
                      ? null
                      : Icon(element.groupItem.icon),
                  children: [element.itemBuilder(context)],
                )
              : Card(
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: _getGroupSeparator(context, element),
                      leading: element.groupItem.icon == null
                          ? null
                          : Icon(element.groupItem.icon),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: kDefaultPadding * 2,
                        vertical: kDefaultPadding / 2,
                      ),
                      child: element.itemBuilder(context),
                    )
                  ],
                ));
        }
        return element.itemBuilder(context);
      },
    );
  }
}
