import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/providers/actions/list_multi_key_provider.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

///no scroll controller for now
class ListHorizontalCustomViewApiAutoRestWidget<E extends ViewAbstract,
    T extends CustomViewHorizontalListResponse<E>> extends StatefulWidget {
  T autoRest;
  Widget Function(dynamic response)? onResponse;
  Widget? Function(dynamic response)? onResponseAddWidget;

  ListHorizontalCustomViewApiAutoRestWidget(
      {super.key,
      required this.autoRest,
      this.onResponse,
      this.onResponseAddWidget});

  @override
  State<ListHorizontalCustomViewApiAutoRestWidget> createState() =>
      _ListHorizontalApiWidgetState<E, T>();
}

class _ListHorizontalApiWidgetState<E extends ViewAbstract,
        T extends CustomViewHorizontalListResponse<E>>
    extends State<ListHorizontalCustomViewApiAutoRestWidget<E, T>> {
  final _scrollController = ScrollController();
  late ListMultiKeyProvider listProvider;
  Widget? header;
  late ValueNotifier valueNotifier;
  late String key;
  late T autoRest;
  var loadingLottie =
      "https://assets5.lottiefiles.com/packages/lf20_t9gkkhz4.json";

  @override
  void initState() {
    super.initState();
    autoRest = widget.autoRest;
    key = autoRest.getCustomViewKey();
    debugPrint("_ListHorizontalApiWidgetState $key");
    listProvider = Provider.of<ListMultiKeyProvider>(context, listen: false);
    _scrollController.addListener(() => _onScroll());
    valueNotifier = ValueNotifier(autoRest);

    valueNotifier.addListener(onValueChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetshList();
    });
  }

  void fetshList() {
    if (listProvider.getCount(key) == 0) {
      switch (widget.autoRest.getCustomViewResponseType()) {
        case ResponseType.LIST:
          listProvider.fetchList(key,
              viewAbstract: widget.autoRest as ViewAbstract);
          break;
        case ResponseType.SINGLE:
          listProvider.fetchView(key, viewAbstract: autoRest as ViewAbstract);
          break;

        case ResponseType.NONE_RESPONSE_TYPE:
          break;
      }
    }
  }

  @override
  void didUpdateWidget(
      covariant ListHorizontalCustomViewApiAutoRestWidget<E, T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    debugPrint("ListHorizontalCustomViewApiAutoRestWidget didUpdateWidget");
    if (key != autoRest.getCustomViewKey()) {
      key = autoRest.getCustomViewKey();
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
        debugPrint("ListApiMasterState building widget: $key");
        bool isLoading = value.item1;
        int count = value.item2;
        bool isError = value.item3;
        if (isLoading) {
          if (count == 0) {
            return wrapHeader(
                context, const CircularProgressIndicator(), listProvider);
          }
        } else {
          if (count == 0 && isError) {
            return wrapHeader(
                context, getEmptyWidget(context, isError: true), listProvider);
          } else if (count == 0) {
            return wrapHeader(context, getEmptyWidget(context), listProvider);
          }
        }
        return wrapHeader(context, getWidget(listProvider), listProvider);
      },
      selector: (p0, p1) =>
          Tuple3(p1.isLoading(key), p1.getCount(key), p1.isHasError(key)),
    );
  }

  Widget getWidget(ListMultiKeyProvider listProvider) {
    switch (autoRest.getCustomViewResponseType()) {
      case ResponseType.LIST:
        return getListWidget(listProvider);

      case ResponseType.SINGLE:
        return getSingleWidget(listProvider);

      case ResponseType.NONE_RESPONSE_TYPE:
        return getSingleWidget(listProvider);
    }
  }

  Widget getSingleWidget(ListMultiKeyProvider listProvider) {
    if (widget.onResponse != null) {
      return widget.onResponse!(listProvider.getList(key)[0]);
    }
    return (listProvider.getList(key)[0] as CustomViewHorizontalListResponse<E>)
            .getCustomViewSingleResponseWidget(context) ??
        const Text("Not emplemented getCustomViewSingleResponseWidget");
  }

  Widget getListWidget(ListMultiKeyProvider listProvider) {
    if (widget.onResponse != null) {
      return widget.onResponse!(listProvider.getList(key) as List<T>);
    }
    return autoRest.getCustomViewListResponseWidget(
            context, listProvider.getList(key).cast()) ??
        const Text("Not emplemented getCustomViewListToSingle");
  }

  Widget wrapHeader(
      BuildContext context, Widget child, ListMultiKeyProvider listProvider) {
    Widget? custom;
    if (child is CircularProgressIndicator) {
      return Center(child: child);
    }
    if (widget.onResponseAddWidget != null) {
      if (listProvider.getList(key).isNotEmpty) {
        dynamic obj = autoRest.getCustomViewResponseType() == ResponseType.LIST
            ? listProvider.getList(key)
            : listProvider.getList(key)[0];
        custom = widget.onResponseAddWidget!(obj);
      }
    }
    header ??= autoRest.getCustomViewTitleWidget(context, valueNotifier);
    if (header == null) {
      return Column(
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
            child: child,
          )),
          if (custom != null) custom
        ],
      );
    }
    return Column(
      children: [
        header!,
        Expanded(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: child,
        )),
        if (custom != null) custom
      ],
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();

    valueNotifier.removeListener(onValueChanged);
    super.dispose();
  }

  void _onScroll() {
    debugPrint(" IS _onScroll $_isBottom");
    if (_isBottom) {
      debugPrint(" IS BOTTOM $_isBottom");
      // listProvider.fetchList(key, autoRest.getCustomViewKey());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void onValueChanged() {
    debugPrint(
        "ListHorizontalCustomViewApiAutoRestWidget onValueNotifierChanged");
    setState(() {
      autoRest = valueNotifier.value;
      key = autoRest.getCustomViewKey();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        fetshList();
      });
    });
  }
}
