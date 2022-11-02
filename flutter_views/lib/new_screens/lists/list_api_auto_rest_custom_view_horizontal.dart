import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/actions/list_multi_key_provider.dart';
import 'package:provider/provider.dart';

import '../../new_components/loading_shimmer.dart';

///no scroll controller for now
class ListHorizontalCustomViewApiAutoRestWidget<
    T extends CustomViewHorizontalListResponse> extends StatefulWidget {
  T autoRest;
  Widget? title;
  String? titleString;
  Function(dynamic response)? onResponse;
  Widget? Function(dynamic response)? onResponseAddWidget;
  ListHorizontalCustomViewApiAutoRestWidget(
      {Key? key,
      required this.autoRest,
      this.title,
      this.titleString,
      this.onResponse,
      this.onResponseAddWidget})
      : super(key: key);

  @override
  State<ListHorizontalCustomViewApiAutoRestWidget> createState() =>
      _ListHorizontalApiWidgetState<T>();
}

class _ListHorizontalApiWidgetState<T extends CustomViewHorizontalListResponse>
    extends State<ListHorizontalCustomViewApiAutoRestWidget<T>> {
  final _scrollController = ScrollController();
  late ListMultiKeyProvider listProvider;
  late String key;
  var loadingLottie =
      "https://assets5.lottiefiles.com/packages/lf20_t9gkkhz4.json";

  @override
  void initState() {
    super.initState();
    key = widget.autoRest.getCustomViewKey();
    debugPrint("_ListHorizontalApiWidgetState $key");
    listProvider = Provider.of<ListMultiKeyProvider>(context, listen: false);
    listProvider.addListener(() {
      debugPrint("list provider is changed ${listProvider.listMap}");
    });
    _scrollController.addListener(() => _onScroll());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (listProvider.getCount(key) == 0) {
        switch (widget.autoRest.getCustomViewResponseType()) {
          case ResponseType.LIST:
            listProvider.fetchList(key, widget.autoRest as ViewAbstract);
            break;
          case ResponseType.SINGLE:
            listProvider.fetchView(key, widget.autoRest as ViewAbstract);
            break;
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // listProvider.fetchView(key, widget.autoRest as ViewAbstract);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: listProvider,
      child: Consumer<ListMultiKeyProvider>(
          builder: (context, provider, listTile) {
        if (provider.getCount(key) == 0) {
          return Center(
            child: const CircularProgressIndicator(
              strokeWidth: 2,
            ),
          );
        }
        debugPrint("List api provider loaded ${listProvider.isLoading}");
        return wrapHeader(context, getWidget(listProvider), listProvider);
      }),
    );
  }

  Widget getWidget(ListMultiKeyProvider listProvider) {
    switch (widget.autoRest.getCustomViewResponseType()) {
      case ResponseType.LIST:
        return getListWidget(listProvider);

      case ResponseType.SINGLE:
        return getSingleWidget(listProvider);
    }
  }

  Widget getSingleWidget(ListMultiKeyProvider listProvider) {
    if (widget.onResponse != null) {
      widget.onResponse!(listProvider.getList(key)[0]);
    }
    return widget.autoRest.getCustomViewSingleResponseWidget(
            context, listProvider.getList(key)[0]) ??
        const Text("Not emplemented getCustomViewSingleResponseWidget");
  }

  Widget getListWidget(ListMultiKeyProvider listProvider) {
    if (widget.onResponse != null) {
      widget.onResponse!(listProvider.getList(key) as List<T>);
    }
    return widget.autoRest.getCustomViewListResponseWidget(
            context, listProvider.getList(key)) ??
        const Text("Not emplemented getCustomViewListToSingle");
  }

  Widget wrapHeader(
      BuildContext context, Widget child, ListMultiKeyProvider listProvider) {
    Widget? custom;

    if (widget.onResponseAddWidget != null) {
      if (listProvider.getList(key).isNotEmpty) {
        dynamic obj =
            widget.autoRest.getCustomViewResponseType() == ResponseType.LIST
                ? listProvider.getList(key)
                : listProvider.getList(key)[0];
        custom = widget.onResponseAddWidget!(obj);
      }
    }

    return SizedBox(
        width: MediaQuery.of(context).size.width - 80,
        height: widget.autoRest.getCustomViewHeight() ??
            MediaQuery.of(context).size.height,
        child: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHeader(context),
              Expanded(child: child),
              if (custom != null) custom
            ],
          ),
        ));
  }

  Widget buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
      child: widget.title ??
          Text(
            widget.titleString ?? "NONT",
            style: const TextStyle(fontWeight: FontWeight.w200),
          ),
    );
  }

  Widget getShimmerLoading(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 10,
          itemBuilder: (ctx, i) {
            return Column(
              children: const [
                ShimmerLoadingList(),
                SizedBox(
                  height: 10,
                )
              ],
            );
          }),
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    debugPrint(" IS _onScroll $_isBottom");
    if (_isBottom) {
      debugPrint(" IS BOTTOM $_isBottom");
      // listProvider.fetchList(key, widget.autoRest.getCustomViewKey());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
