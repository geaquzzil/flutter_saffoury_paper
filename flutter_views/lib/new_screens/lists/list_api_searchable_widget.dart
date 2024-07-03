import 'package:flutter/material.dart';
import 'package:flutter_view_controller/new_components/lists/list_card_item.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/lists/list_card_item_selected.dart';
import 'package:flutter_view_controller/providers/actions/list_multi_key_provider.dart';

import 'list_api_master.dart';

@immutable
class ListApiSearchableWidget extends ListApiMaster {
  ListApiSearchableWidget(
      {super.key,
      super.viewAbstract,
      bool? buildSearchWidget,
      bool? buildFabs})
      : super(
            buildFabIfMobile: buildFabs ?? true,
            buildSearchWidget: buildSearchWidget ?? true);

  @override
  void onScroll(
      {required BuildContext context,
      required ViewAbstract viewAbstract,
      required ListMultiKeyProvider listProvider}) {}

  @override
  Widget getListViewWidget(
      {required BuildContext context,
      required String key,
      required ScrollController scrollController,
      required ListMultiKeyProvider listProvider}) {
    var data = listProvider.getList(key);
    var listView = ListView.builder(
      key: const ValueKey(2),
      physics: const AlwaysScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      controller: scrollController,
      itemCount:
          listProvider.isLoading(key) ? (data.length + 1) : (data.length),
      itemBuilder: (context, index) {
        if (listProvider.isLoading(key) && index == data.length) {
          return getSharedLoadingItem(context);
        }
        return ListCardItem( object: data[index]);
      },
    );
    return listView;
  }

  @override
  Widget getListSelectedViewWidget(
      {required BuildContext context,
      required String key,
      required ScrollController scrollController,
      required ListMultiKeyProvider listProvider}) {
    // TODO: implement getListSelectedViewWidget
    var data = listProvider.getList(key);
    var listView = ListView.builder(
      key: const ValueKey(1),
      physics: const AlwaysScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      controller: scrollController,
      itemCount:
          listProvider.isLoading(key) ? (data.length + 1) : (data.length),
      itemBuilder: (context, index) {
        if (listProvider.isLoading(key) && index == data.length) {
          return getSharedLoadingItem(context);
        }
        return ListCardItemSelected<ViewAbstract>(
          object: data[index],
          // onSelected: (obj) => getKey()?.currentState?.onSelectedItem(obj),
        );
      },
    );
    return listView;
  }
}
