import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/providers/actions/list_multi_key_provider.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../../new_components/loading_shimmer.dart';

///no scroll controller for now
class ListHorizontalCustomViewApiAutoRestWidget<E extends ViewAbstract,
    T extends CustomViewHorizontalListResponse<E>> extends StatefulWidget {
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
      _ListHorizontalApiWidgetState<E, T>();
}

class _ListHorizontalApiWidgetState<E extends ViewAbstract,
        T extends CustomViewHorizontalListResponse<E>>
    extends State<ListHorizontalCustomViewApiAutoRestWidget<E, T>> {
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
    _scrollController.addListener(() => _onScroll());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetshList();
    });
  }

  void fetshList() {
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
  void didUpdateWidget(
      covariant ListHorizontalCustomViewApiAutoRestWidget<E, T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    debugPrint("ListHorizontalCustomViewApiAutoRestWidget didUpdateWidget");
    if (key != widget.autoRest.getCustomViewKey()) {
      key = widget.autoRest.getCustomViewKey();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        fetshList();
      });
    }
  }

  Widget getEmptyWidget(BuildContext context, {bool isError = false}) {
    return EmptyWidget(
        onSubtitleClicked: isError
            ? () {
                fetshList();
              }
            : null,
        lottiUrl: "https://assets7.lottiefiles.com/packages/lf20_0s6tfbuc.json",
        title: isError
            ? AppLocalizations.of(context)!.cantConnect
            : AppLocalizations.of(context)!.noItems,
        subtitle: isError
            ? AppLocalizations.of(context)!.cantConnectConnectToRetry
            : AppLocalizations.of(context)!.no_content);
  }

  @override
  Widget build(BuildContext context) {
    return Selector<ListMultiKeyProvider, Tuple3<bool, int, bool>>(
      builder: (context, value, child) {
        debugPrint("ListApiMasterState building widget: ${key}");
        bool isLoading = value.item1;
        int count = value.item2;
        bool isError = value.item3;

        if (isLoading) {
          if (count == 0) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        } else {
          if (count == 0 && isError) {
            return getEmptyWidget(context, isError: true);
          } else if (count == 0) {
            return getEmptyWidget(context);
          }
        }
        return wrapHeader(context, getWidget(listProvider), listProvider);
      },
      selector: (p0, p1) =>
          Tuple3(p1.isLoading(key), p1.getCount(key), p1.isHasError(key)),
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
    return (listProvider.getList(key)[0] as CustomViewHorizontalListResponse<E>)
            .getCustomViewSingleResponseWidget(context) ??
        const Text("Not emplemented getCustomViewSingleResponseWidget");
  }

  Widget getListWidget(ListMultiKeyProvider listProvider) {
    if (widget.onResponse != null) {
      widget.onResponse!(listProvider.getList(key) as List<T>);
    }
    return widget.autoRest.getCustomViewListResponseWidget(
            context, listProvider.getList(key).cast()) ??
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
    if (widget.title == null && widget.titleString == null) {
      return Column(
        children: [child, if (custom != null) custom],
      );
    }
    return Column(
      children: [buildHeader(context), child, if (custom != null) custom],
    );
    // return SizedBox(
    //     child: Expanded(
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       buildHeader(context),
    //       Expanded(child: child),
    //       if (custom != null) custom
    //     ],
    //   ),
    // ));
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
