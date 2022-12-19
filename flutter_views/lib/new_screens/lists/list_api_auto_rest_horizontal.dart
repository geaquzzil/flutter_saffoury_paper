import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/actions/list_multi_key_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

import '../../new_components/lists/horizontal_list_card_item.dart';
import '../../new_components/loading_shimmer.dart';

class ListHorizontalApiAutoRestWidget extends StatefulWidget {
  AutoRest autoRest;
  Widget? title;
  double customHeight;
  String? titleString;
  Widget Function(ViewAbstract v)? listItembuilder;
  ListHorizontalApiAutoRestWidget(
      {Key? key,
      required this.autoRest,
      this.title,
      this.titleString,
      this.customHeight = 230,
      this.listItembuilder})
      : super(key: key);

  @override
  State<ListHorizontalApiAutoRestWidget> createState() =>
      _ListHorizontalApiWidgetState();
}

class _ListHorizontalApiWidgetState
    extends State<ListHorizontalApiAutoRestWidget> {
  final _scrollController = ScrollController();
  late ListMultiKeyProvider listProvider;

  var loadingLottie =
      "https://assets5.lottiefiles.com/packages/lf20_t9gkkhz4.json";

  @override
  void initState() {
    super.initState();
    listProvider = Provider.of<ListMultiKeyProvider>(context, listen: false);
    _scrollController.addListener(() => _onScroll());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (listProvider.getCount(widget.autoRest.key) == 0) {
        listProvider.fetchList(widget.autoRest.key, widget.autoRest.obj,
            autoRest: widget.autoRest);
      }
    });
  }

  Widget _listItems(
      List<ViewAbstract> data, ListMultiKeyProvider listProvider) {
    bool isLoading = listProvider.isLoading(widget.autoRest.key);
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
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
        return widget.listItembuilder == null
            ? ListCardItemHorizontal(object: data[index])
            : widget.listItembuilder!(data[index]);
        // return data[index].getCardView(context);
      },
      // ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: listProvider,
      child: Consumer<ListMultiKeyProvider>(
          builder: (context, provider, listTile) {
        if (provider.getCount(widget.autoRest.key) == 0) {
          return wrapHeader(
              context,
              Center(
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ));
        }
        debugPrint("List api provider loaded ${listProvider.isLoading}");
        return wrapHeader(
            context,
            _listItems(
                listProvider.getList(widget.autoRest.key), listProvider));
      }),
    );
  }

  Widget wrapHeader(BuildContext context, Widget child) {
    return SizedBox(
        width: MediaQuery.of(context).size.width - 80,
        height: widget.customHeight,
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
            style: Theme.of(context).textTheme.titleMedium,
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
    if (_isBottom) {
      debugPrint(" IS BOTTOM $_isBottom");
      listProvider.fetchList(widget.autoRest.key, widget.autoRest.obj,
          autoRest: widget.autoRest);
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
