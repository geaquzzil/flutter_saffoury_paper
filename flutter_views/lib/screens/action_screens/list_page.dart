import 'package:flutter/material.dart';
import 'package:flutter_view_controller/components/loading_list.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/view_abstract_provider.dart';
import 'package:loadmore/loadmore.dart';
import 'package:provider/provider.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState<T extends ViewAbstract> extends State<ListPage> {
  late List<T> list = [];
  int get count => list.length;
  int page = 0;
  @override
  Widget build(BuildContext context) {
    return const Text("TEST");

    // SizedBox(
    //   height: double.maxFinite,
    //   child: RefreshIndicator(
    //     onRefresh: _refresh,
    //     child: LoadMore(
    //       isFinish: count >= 10,
    //       onLoadMore: _loadMore,
    //       whenEmptyLoad: true,
    //       delegate: const DefaultLoadMoreDelegate(),
    //       textBuilder: DefaultLoadMoreTextBuilder.english,
    //       child: ListView.builder(
    //         physics: const AlwaysScrollableScrollPhysics(),
    //         itemBuilder: (BuildContext context, int index) {
    //           return list[index].getCardView(context);
    //         },
    //         itemCount: count,
    //       ),
    //     ),
    //   ),
    // );
  }

  Future<bool> _loadMore() async {
    print("onLoadMore");
    bool result = true;
    ViewAbstract viewAbstract = context.watch<ViewAbstractProvider>().getObject;
    List? c = await viewAbstract.listCall(5, page,
        onResponse: OnResponseCallback(onServerNoMoreItems: () {
          result = false;
          return;
          //...
        }, onServerFailure: (message) {
          result = false;
          //...
        }, onServerFailureResponse: (message) {
          result = false;
          //...
        }));
    if (c != null) {
      list.addAll(List<T>.from(c));
    }
    return result;
  }

  Future<void> _refresh() async {
    page = 0;
    await Future.delayed(const Duration(seconds: 0, milliseconds: 2000));
    list.clear();
  }
}

class CustomLoadMoreDelegate extends LoadMoreDelegate {
  static const _defaultLoadMoreHeight = 80.0;
  static const _loadmoreIndicatorSize = 33.0;
  static const _loadMoreDelay = 16;
  CustomLoadMoreDelegate();
  @override
  Widget buildChild(LoadMoreStatus status,
      {LoadMoreTextBuilder builder = DefaultLoadMoreTextBuilder.english}) {
    String text = builder(status);
    if (status == LoadMoreStatus.fail) {
      return Text(text);
    }
    if (status == LoadMoreStatus.idle) {
      return Text(text);
    }
    if (status == LoadMoreStatus.loading) {
      return const LoadingListPage();
    }
    if (status == LoadMoreStatus.nomore) {
      return Text(text);
    }

    return Text(text);
  }
}
