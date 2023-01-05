import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_view_controller/new_components/lists/horizontal_list_card_item.dart';
import 'package:flutter_view_controller/providers/actions/list_multi_key_provider.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter/src/widgets/scroll_controller.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../new_components/lists/list_card_item.dart';
import 'list_api_master.dart';

class ListSliverGrid extends ListApiMaster {
  ListSliverGrid({super.key, required super.viewAbstract})
      : super(useSlivers: true);

  @override
  State<ListApiMaster> createState() => _ListSliverGridState();

  @override
  Widget getListSelectedViewWidget(
      {required BuildContext context,
      required String key,
      required ScrollController scrollController,
      required ListMultiKeyProvider listProvider}) {
    // TODO: implement getListSelectedViewWidget
    throw UnimplementedError();
  }

  @override
  Widget getListViewWidget(
      {required BuildContext context,
      required String key,
      required ScrollController scrollController,
      required ListMultiKeyProvider listProvider}) {
    // TODO: implement getListViewWidget
    throw UnimplementedError();
  }

  @override
  void onScroll(
      {required BuildContext context,
      required ViewAbstract viewAbstract,
      required ListMultiKeyProvider listProvider}) {
    // TODO: implement onScroll
  }
}

class _ListSliverGridState extends ListApiMasterState {
  @override
  Widget build(BuildContext context) {
    return Selector<ListMultiKeyProvider, Tuple3<bool, int, bool>>(
      builder: (context, value, child) {
        var data = listProvider.getList(findCustomKey());
        debugPrint("ListApiMasterState building widget: ${findCustomKey()}");
        bool isLoading = value.item1;
        int count = value.item2;
        bool isError = value.item3;

        if (isLoading) {
          if (count == 0) {
            return getShimmerLoading();
          }
        } else {
          if (count == 0 || isError) {
            return getEmptyWidget(isError: isError);
          }
        }
        return SliverGrid(
          
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              return ListCardItemHorizontal(object: data[index]);
            }, childCount: count));
      },
      selector: (p0, p1) => Tuple3(p1.isLoading(findCustomKey()),
          p1.getCount(findCustomKey()), p1.isHasError(findCustomKey())),
    );
  }
}
