import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/new_components/lists/list_card_item.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/actions/list_multi_key_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

import '../../components/square_card.dart';
import '../../new_components/lists/horizontal_list_card_item.dart';
import '../../new_components/loading_shimmer.dart';

///no scroll controller for now
class ListHorizontalCustomViewApiAutoRestWidget<T extends CustomViewResponse>
    extends StatefulWidget {
  T autoRest;
  Widget? title;
  String? titleString;
  ListHorizontalCustomViewApiAutoRestWidget(
      {Key? key, required this.autoRest, this.title, this.titleString})
      : super(key: key);

  @override
  State<ListHorizontalCustomViewApiAutoRestWidget> createState() =>
      _ListHorizontalApiWidgetState();
}

class _ListHorizontalApiWidgetState
    extends State<ListHorizontalCustomViewApiAutoRestWidget> {
  final _scrollController = ScrollController();
  final ListMultiKeyProvider listProvider = ListMultiKeyProvider();
  late String key;
  var loadingLottie =
      "https://assets5.lottiefiles.com/packages/lf20_t9gkkhz4.json";

  @override
  void initState() {
    super.initState();
    key = widget.autoRest.getCustomViewKey();
    _scrollController.addListener(() => _onScroll());
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
          return wrapHeader(
              context,
              const CircularProgressIndicator(
                strokeWidth: 2,
              ));
        }
        debugPrint("List api provider loaded ${listProvider.isLoading}");
        return wrapHeader(context, getWidget(listProvider));
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
    return widget.autoRest.getCustomViewSingleResponseWidget(
            context, listProvider.getList(key)[0]) ??
        Text("Not emplemented getCustomViewSingleResponseWidget");
  }

  Widget getListWidget(ListMultiKeyProvider listProvider) {
    return widget.autoRest.getCustomViewListResponseWidget(
            context, listProvider.getList(key)) ??
        Text("Not emplemented getCustomViewListToSingle");
  }

  Widget _listItems(
      List<ViewAbstract> data, ListMultiKeyProvider listProvider) {
    bool isLoading = listProvider.isLoading(key);
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      // controller: _scrollController,
      itemCount: isLoading ? (data.length + 1) : (data.length),
      itemBuilder: (context, index) {
        if (isLoading && index == data.length) {
          return Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context)!.loading),
                const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    )),
              ],
            ),
          ));
        }
        return ListCardItemHorizontal(object: data[index]);
        // return data[index].getCardView(context);
      },
      // ),
    );
  }

  Widget wrapHeader(BuildContext context, Widget child) {
    return SizedBox(
        width: MediaQuery.of(context).size.width - 80,
        height: 230,
        child: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [buildHeader(context), Expanded(child: child)],
          ),
        ));
  }

  Widget buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
      child: widget.title ??
          Text(
            widget.titleString ?? "NONT",
            style: TextStyle(fontWeight: FontWeight.w200),
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
