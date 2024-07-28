import 'package:flutter/material.dart';
import 'package:flutter_view_controller/new_components/lists/list_card_item.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/actions/list_provider.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';

import 'package:provider/provider.dart';

import '../../new_components/loading_shimmer.dart';

class ListApiWidget extends StatefulWidget {
  const ListApiWidget({super.key});

  @override
  State<ListApiWidget> createState() => _ListApiWidgetState();
}

class _ListApiWidgetState extends State<ListApiWidget> {
  final _scrollController = ScrollController();
  final ListProvider listProvider = ListProvider();
  late DrawerMenuControllerProvider drawerViewAbstractObsever;

  var loadingLottie =
      "https://assets5.lottiefiles.com/packages/lf20_t9gkkhz4.json";

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() => _onScroll());
    drawerViewAbstractObsever =
        Provider.of<DrawerMenuControllerProvider>(context, listen: false);
    drawerViewAbstractObsever.addListener(onChangedViewAbstract);
    listProvider
        .fetchList(context.read<DrawerMenuControllerProvider>().getObjectCastViewAbstract);
  }

  Widget _listItems(List<ViewAbstract> data, ListProvider listProvider) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 80,
      child:
          // ScrollConfiguration(
          //   behavior: ScrollConfiguration.of(context).copyWith(
          //     dragDevices: {
          //       PointerDeviceKind.touch,
          //       PointerDeviceKind.mouse,
          //     },
          //   ),
          //   child:

          ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        // physics: const AlwaysScrollableScrollPhysics(),
        // physics: const AlwaysScrollableScrollPhysics(),
        // scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        controller: _scrollController,
        itemCount: listProvider.isLoading ? (data.length + 1) : (data.length),
        itemBuilder: (context, index) {
          if (listProvider.isLoading && index == data.length) {
            return const Center(
                child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Loading..."),
                  SizedBox(
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
      child: Consumer<ListProvider>(builder: (context, provider, listTile) {
        if (provider.getCount == 0) {
          // return EmptyWidget(
          //     lottiUrl: loadingLottie,
          //     title: AppLocalizations.of(context)!.loading,
          //     subtitle: AppLocalizations.of(context)!.pleaseWait);
          return getShimmerLoading(context);
        }
        debugPrint("List api provider loaded ${listProvider.isLoading}");
        return _listItems(listProvider.getObjects, listProvider);
      }),
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
      listProvider
          .fetchList(context.read<DrawerMenuControllerProvider>().getObjectCastViewAbstract);
      // context
      //     .read<ListProvider>()
      //     .fetchList(context.read<DrawerViewAbstractProvider>().getObject);
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void onChangedViewAbstract() {
    if (mounted) {
      listProvider.clear(viewAbstract: drawerViewAbstractObsever.getObjectCastViewAbstract);
      debugPrint("ViewAbstractProvider CHANGED");
    }
  }
}
