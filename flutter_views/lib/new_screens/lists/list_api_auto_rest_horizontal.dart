import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/lists/horizontal_list_card_item_shimmer.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/providers/actions/list_multi_key_provider.dart';
import 'package:flutter_view_controller/screens/on_hover_button.dart';
import 'package:flutter_view_controller/screens/web/components/grid_view_api_category.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tuple/tuple.dart';

import '../../new_components/loading_shimmer.dart';

class ListHorizontalApiAutoRestWidget extends StatefulWidget {
  AutoRest? autoRest;
  List<ViewAbstract>? list;
  Widget? title;
  bool isImagable;
  double? customHeight;
  String? titleString;
  bool isSliver;
  Widget Function(ViewAbstract v)? listItembuilder;

  ValueNotifier<ViewAbstract?>? valueNotifier;
  ListHorizontalApiAutoRestWidget(
      {super.key,
      this.autoRest,
      this.title,
      this.list,
      this.titleString,
      this.isSliver = false,
      this.customHeight,
      this.valueNotifier,
      this.isImagable = false,
      this.listItembuilder})
      : assert(list != null || autoRest != null);

  @override
  State<ListHorizontalApiAutoRestWidget> createState() =>
      _ListHorizontalApiWidgetState();
}

class _ListHorizontalApiWidgetState
    extends State<ListHorizontalApiAutoRestWidget> {
  ScrollController _scrollController = ScrollController();
  ValueNotifier<bool> _valueNotifier = ValueNotifier<bool>(false);
  late ListMultiKeyProvider listProvider;
  AutoRest? _autoRest;
  double itemShowingHeight = 0;
  double itemsShowingWidth = 0;
  bool isButtonScrolling = false;
  double? _currentHeight;
  var loadingLottie =
      "https://assets5.lottiefiles.com/packages/lf20_t9gkkhz4.json";

  @override
  void initState() {
    super.initState();
    debugPrint("ListHorizontalApiAutoRestWidget==========>initState");
    listProvider = Provider.of<ListMultiKeyProvider>(context, listen: false);
    _autoRest = widget.autoRest;
    callRest();
  }

  void callRest() {
    debugPrint("ListHorizontalApiAutoRestWidget==========>callRest");
    if (_autoRest != null) {
      debugPrint("ListHorizontalApiAutoRestWidget==========>callRest !=null");
      _scrollController.addListener(() => _onScroll());
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (listProvider.getCount(_autoRest!.key) == 0) {
          listProvider.fetchList(_autoRest!.key,
              viewAbstract: _autoRest!.obj, autoRest: _autoRest);
        }
      });
    }
  }

  @override
  void didChangeDependencies() {
    debugPrint(
        "ListHorizontalApiAutoRestWidget==========>didChangeDependencies");
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant ListHorizontalApiAutoRestWidget oldWidget) {
    debugPrint("ListHorizontalApiAutoRestWidget==========>didUpdateWidget");
    _autoRest = widget.autoRest;
    callRest();
    super.didUpdateWidget(oldWidget);
  }

  Widget listShimmerItems() {
    return LayoutBuilder(
      builder: (co, constraints) {
        debugPrint(
            "layoutBuilder width ${constraints.maxWidth} height ${constraints.maxHeight} ");
        return ResponsiveGridView.builder(
          scrollDirection: Axis.horizontal,
          // shrinkWrap: true,
          // alignment: Alignment.topCenter,
          itemCount: 5 + Random().nextInt(10 - 5),
          gridDelegate: ResponsiveGridDelegate(
            crossAxisExtent: constraints.maxHeight * .9,
            mainAxisSpacing: 10,
            maxCrossAxisExtent: constraints.maxHeight,
            childAspectRatio: isDesktop(context) ? 1 : 1,
          ),
          itemBuilder: (context, index) {
            return GridTile(
                // footer: Text("foot"),
                child: ListHorizontalItemShimmer(
              lines: SizeConfig.hasPointer(context) ? 0 : 3,
            ));
          },
        );
      },
    );
  }

  Widget _listItems(List<ViewAbstract> data,
      {ListMultiKeyProvider? listProvider}) {
    bool isLoading = widget.autoRest == null
        ? false
        : listProvider!.isLoading(widget.autoRest!.key);
    return LayoutBuilder(
      builder: (co, constraints) {
        itemShowingHeight = constraints.maxHeight;
        itemsShowingWidth = constraints.maxWidth;
        debugPrint(
            "layoutBuilder horizontal maxWidth  ${constraints.maxWidth} maxHeight ${constraints.maxHeight}");
        return ResponsiveGridView.builder(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: isLoading ? (data.length + 3) : (data.length),
          gridDelegate: ResponsiveGridDelegate(
            crossAxisExtent: constraints.maxHeight * .9,
            mainAxisSpacing: 20,
            maxCrossAxisExtent: constraints.maxHeight,
            childAspectRatio: isDesktop(context) ? 1 : 1,
          ),
          itemBuilder: (context, index) {
            if (isLoading && index > data.length - 1) {
              return GridTile(
                  child: ListHorizontalItemShimmer(
                lines: SizeConfig.hasPointer(context) ? 0 : 3,
              ));
            }
            Widget currentTile = WebGridViewItem(
              setDescriptionAtBottom: !SizeConfig.hasPointer(context),
              onPress: widget.valueNotifier == null
                  ? null
                  : () {
                      widget.valueNotifier!.value = data[index];
                    },
              item: data[index],
            );
            return GridTile(child: currentTile);
          },
        );
      },
    );
  }

  Widget getErrorWidget(BuildContext context) {
    return getEmptyWidget(context, isError: true);
  }

  Widget getEmptyWidget(BuildContext context, {bool isError = false}) {
    return wrapHeader(
        context,
        EmptyWidget(
            onSubtitleClicked: isError
                ? () {
                    listProvider.fetchList(widget.autoRest!.key,
                        viewAbstract: widget.autoRest!.obj,
                        autoRest: widget.autoRest);
                  }
                : null,
            lottiUrl:
                "https://assets7.lottiefiles.com/packages/lf20_0s6tfbuc.json",
            title: isError
                ? AppLocalizations.of(context)!.cantConnect
                : AppLocalizations.of(context)!.noItems,
            subtitle: isError
                ? AppLocalizations.of(context)!.cantConnectConnectToRetry
                : AppLocalizations.of(context)!.no_content));
  }

  @override
  Widget build(BuildContext context) {
    _currentHeight =
        widget.customHeight ?? MediaQuery.of(context).size.height * .25;
    if (widget.list != null) {
      return wrapHeader(context, _listItems(widget.list!));
    }
    return ChangeNotifierProvider.value(
        value: listProvider,
        child: Selector<ListMultiKeyProvider, Tuple3<bool, int, bool>>(
          builder: (context, value, child) {
            if (isButtonScrolling) {
              isButtonScrolling = false;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _scroll();
              });
            }
            debugPrint(
                "ListHorizontalApiAutoRestWidget building widget: ${widget.autoRest?.key}");
            bool isLoading = value.item1;
            int count = value.item2;
            bool isError = value.item3;
            if (isError) {
              if (count == 0) {
                return getErrorWidget(context);
              } else {
                return wrapHeader(
                    context,
                    _listItems(listProvider.getList(widget.autoRest!.key),
                        listProvider: listProvider));
              }
            } else if (isLoading) {
              if (count == 0) {
                return wrapHeader(context, listShimmerItems());
              } else {
                return wrapHeader(
                    context,
                    _listItems(listProvider.getList(widget.autoRest!.key),
                        listProvider: listProvider));
              }
            } else {
              if (count == 0) {
                return getEmptyWidget(context);
              }
              return wrapHeader(
                  context,
                  _listItems(listProvider.getList(widget.autoRest!.key),
                      listProvider: listProvider));
            }
          },
          selector: (p0, p1) => Tuple3(
              p1.isLoading(widget.autoRest!.key),
              p1.getCount(widget.autoRest!.key),
              p1.isHasError(widget.autoRest!.key)),
        ));
  }

  bool hasTitle() {
    return widget.title != null || widget.titleString != null;
  }

  Widget wrapHeader(BuildContext context, Widget child) {
    Widget c = _currentHeight != null
        ? SizedBox(
            height: _currentHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: child,
            ))
        : Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: child,
            ),
          );
    if (SizeConfig.hasPointer(context)) {
      c = SizedBox(
        height: _currentHeight,
        child: OnHoverWidget(
          onHover: _valueNotifier,
          scale: false,
          builder: (isHovered) {
            return Stack(clipBehavior: Clip.none, children: [
              Positioned.fill(child: child),
              HoverButtons(
                valueNotifier: _valueNotifier,
                valuePageNotifierVoid: (idx) {
                  if (_isBottom) {
                    listProvider.fetchList(widget.autoRest!.key,
                        viewAbstract: widget.autoRest!.obj,
                        autoRest: widget.autoRest);
                    isButtonScrolling = true;
                  } else {
                    _scroll();
                  }
                },
              )
            ]);
          },
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasTitle()) buildHeader(context),
        if (kIsWeb)
          const SizedBox(
            height: kDefaultPadding,
          ),
        c
        // if (widget.isSliver)
        //   child
        // else
        // SizedBox(height: widget.customHeight, child: child)
      ],
    );
  }

  void _scroll() {
    _scrollController.position.animateTo(
      _scrollController.offset + itemsShowingWidth - 20,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  Widget buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: kDefaultPadding, horizontal: kDefaultPadding),
      child: widget.title ??
          Text(
            widget.titleString ?? "NONT",
            style: Theme.of(context).textTheme.titleLarge,
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
    if (_isBottom) {
      debugPrint(" IS BOTTOM $_isBottom");
      listProvider.fetchList(widget.autoRest!.key,
          viewAbstract: widget.autoRest!.obj, autoRest: widget.autoRest);
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
