import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/interfaces/settings/ModifiableInterfaceAndPrintingSetting.dart';
import 'package:flutter_view_controller/new_components/cards/card_background_with_title.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_master.dart';
import 'package:flutter_view_controller/new_screens/lists/list_static_master.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

import '../../components/expansion_tile_custom.dart';

class ListStickyWidget extends ListStaticMaster<ListStickyItem> {
  bool sort;
  ListStickyWidget(
      {Key? key, required List<ListStickyItem> list, this.sort = true})
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
    return StickyGroupedListView<ListStickyItem, String>(
      // physics: ,
      //  physics: const AlwaysScrollableScrollPhysics(),
      physics: ClampingScrollPhysics(parent: NeverScrollableScrollPhysics()),
      shrinkWrap: true,
      elements: list,
      stickyHeaderBackgroundColor: Colors.transparent,
      order: StickyGroupedListOrder.ASC,
      groupBy: (ListStickyItem element) => element.groupItem.groupName,
      groupComparator: sort == false
          ? null
          : (String value1, String value2) => value2.compareTo(value1),
      itemComparator: (ListStickyItem element1, ListStickyItem element2) =>
          element1.groupItem.groupName.compareTo(element2.groupItem.groupName),
      floatingHeader: false,
      separator: Text("s"),
      padding: EdgeInsets.all(kDefaultPadding / 2),
      groupSeparatorBuilder: (element) =>
          element.buildGroupNameInsideItemBuilder
              ? SizedBox(height: kDefaultPadding / 2)
              : _getGroupSeparator(context, element),
      itemBuilder: (context, element) {
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
              : CardBackgroundWithTitle(
                  title: element.groupItem.groupName,
                  leading: element.groupItem.icon,
                  child: element.itemBuilder(context),
                );
        }
        return element.itemBuilder(context);
      },
    );
  }
}

class ListStickyItem {
  ListStickyGroupItem groupItem;

  bool buildGroupNameInsideItemBuilder;
  bool useExpansionTile;
  Widget Function(BuildContext context) itemBuilder;
  ListStickyItem(
      {required this.groupItem,
      required this.itemBuilder,
      this.useExpansionTile = false,
      this.buildGroupNameInsideItemBuilder = true});
}

class ListStickyGroupItem {
  String groupName;
  IconData? icon;
  ListStickyGroupItem({required this.groupName, this.icon});
}
