import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_view_controller/new_components/lists/horizontal_list_card_item_shimmer.dart';
import 'package:flutter_view_controller/new_components/lists/list_card_item.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/actions/list_multi_key_provider.dart';

import 'package:provider/provider.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';

import '../../models/auto_rest.dart';
import '../../new_components/lists/square_card_pos.dart';
import '../../new_components/loading_shimmer.dart';

class POSListWidget<T extends ViewAbstract> extends StatefulWidget {
  AutoRest autoRest;
  POSListWidget({super.key, required this.autoRest});

  @override
  State<POSListWidget> createState() => _POSListWidget();
}

class _POSListWidget<T extends ViewAbstract> extends State<POSListWidget<T>> {
  final _scrollController = ScrollController();
  late ListMultiKeyProvider listProvider;

  var loadingLottie =
      "https://assets5.lottiefiles.com/packages/lf20_t9gkkhz4.json";

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() => _onScroll());

    listProvider = Provider.of<ListMultiKeyProvider>(context, listen: false);
    _scrollController.addListener(() => _onScroll());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (listProvider.getCount(widget.autoRest.key) == 0) {
        listProvider.fetchList(widget.autoRest.key,
            viewAbstract: widget.autoRest.obj, context: context);
      }
    });
  }

  Widget _listItems(
      List<ViewAbstract> data, ListMultiKeyProvider listProvider) {
    bool isLoading = listProvider.isLoading(widget.autoRest.key);
    const sh = 4;
    return GridView.builder(
        controller: _scrollController,
        itemCount: listProvider.isLoading(widget.autoRest.key)
            ? (data.length + 1)
            : (data.length),
        shrinkWrap: true,
        gridDelegate: SliverQuiltedGridDelegate(
          crossAxisCount: 4,
          mainAxisSpacing: 3,
          crossAxisSpacing: 3,
          repeatPattern: QuiltedGridRepeatPattern.inverted,
          pattern: [
            const QuiltedGridTile(2, 2),
            const QuiltedGridTile(2, 2),
            const QuiltedGridTile(1, 2),
            const QuiltedGridTile(1, 2),
          ],
        ),
        itemBuilder: (context, index) {
          if (listProvider.isLoading(widget.autoRest.key) &&
              index == data.length) {
            return const Center(
                child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    )));
          }
          return SquareCardPOS(object: data[index]);
          // return data[index].getCardView(context);
        });
    return SizedBox(
      height: MediaQuery.of(context).size.height - 80,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        controller: _scrollController,
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
          return ListCardItem(object: data[index]);
          // return data[index].getCardView(context);
        },
        // ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: listProvider,
      child: Consumer<ListMultiKeyProvider>(
          builder: (context, provider, listTile) {
        if (provider.getCount(widget.autoRest.key) == 0) {
          return getShimmerLoadingGrid(context);
        }
        debugPrint("List api provider loaded ${listProvider.isLoading}");
        return _listItems(
            listProvider.getList(widget.autoRest.key), listProvider);
      }),
    );
  }

  Widget getShimmerLoadingGrid(BuildContext context) {
    return GridView.builder(
        controller: _scrollController,
        itemCount: 10,
        shrinkWrap: true,
        gridDelegate: SliverQuiltedGridDelegate(
          crossAxisCount: 4,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          repeatPattern: QuiltedGridRepeatPattern.inverted,
          pattern: [
            const QuiltedGridTile(1, 2),
            const QuiltedGridTile(1, 1),
            const QuiltedGridTile(1, 1),
            const QuiltedGridTile(1, 2),
          ],
        ),
        itemBuilder: (context, index) {
          return ListHorizontalItemShimmer(
            lines: 2,
          );
          // return data[index].getCardView(context);
        });
  }

  Widget getShimmerLoading(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 10,
          itemBuilder: (ctx, i) {
            return const Column(
              children: [
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
      listProvider.fetchList(widget.autoRest.key,
          viewAbstract: widget.autoRest.obj, context: context);
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
