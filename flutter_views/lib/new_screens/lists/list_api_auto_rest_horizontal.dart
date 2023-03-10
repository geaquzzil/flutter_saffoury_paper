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
import 'package:flutter_view_controller/screens/web/components/grid_view_api_category.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tuple/tuple.dart';

import '../../new_components/lists/horizontal_list_card_item.dart';
import '../../new_components/loading_shimmer.dart';

class ListHorizontalApiAutoRestWidget extends StatefulWidget {
  AutoRest autoRest;
  Widget? title;
  double? customHeight;
  String? titleString;
  bool isSliver;
  bool useCardAsImageBackgroud;
  bool useCardAsOutLine;
  Widget Function(ViewAbstract v)? listItembuilder;
  ListHorizontalApiAutoRestWidget(
      {Key? key,
      required this.autoRest,
      this.title,
      this.titleString,
      this.useCardAsOutLine = false,
      this.useCardAsImageBackgroud = false,
      this.isSliver = false,
      this.customHeight,
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

  Widget listShimmerItems() {
    return LayoutBuilder(
      builder: (co, constraints) {
        debugPrint("layoutBuilder ${constraints.maxWidth}");
        return ResponsiveGridView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          alignment: Alignment.topCenter,
          itemCount: 5 + Random().nextInt(10 - 5),
          gridDelegate: ResponsiveGridDelegate(
            mainAxisSpacing: 20.0,
            crossAxisSpacing: 20.0,
            maxCrossAxisExtent:
                ScreenHelper.isTablet(context) || ScreenHelper.isMobile(context)
                    ? constraints.maxWidth / 2.0
                    : 250.0,
            // Hack to adjust child height
            childAspectRatio: ScreenHelper.isDesktop(context) ? 1 : 1,
          ),
          itemBuilder: (context, index) {
            return GridTile(
                // footer: Text("foot"),
                child: ListHorizontalItemShimmer(
              lines: 3,
            ));
          },
        );
      },
    );
  }

  Widget _listItems(
      List<ViewAbstract> data, ListMultiKeyProvider listProvider) {
    bool isLoading = listProvider.isLoading(widget.autoRest.key);
    return LayoutBuilder(
      builder: (co, constraints) {
        debugPrint("layoutBuilder ${constraints.maxWidth}");
        return ResponsiveGridView.builder(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: isLoading ? (data.length + 3) : (data.length),
          gridDelegate: ResponsiveGridDelegate(
            mainAxisSpacing: 20,

            crossAxisSpacing: 20,
            maxCrossAxisExtent:
                ScreenHelper.isTablet(context) || ScreenHelper.isMobile(context)
                    ? constraints.maxWidth / 2.0
                    : 250.0,
            // Hack to adjust child height
            childAspectRatio: ScreenHelper.isDesktop(context) ? 1 : 1,
          ),
          // const SliverGridDelegateWithMaxCrossAxisExtent(
          //   crossAxisSpacing: kDefaultPadding / 2,
          //   mainAxisSpacing: kDefaultPadding / 2,
          //   childAspectRatio: 1 / 1,
          //   // mainAxisExtent: 100,
          //   maxCrossAxisExtent: 250,
          //   // childAspectRatio: 3 / 2,
          // ),
          itemBuilder: (context, index) {
            if (isLoading && index > data.length - 1) {
              return GridTile(
                  child: ListHorizontalItemShimmer(
                lines: 3,
              ));
            }
            return GridTile(
                // footer: Text("foot"),
                child: WebGridViewItem(
              // setDescriptionAtBottom: !kIsWeb,
              item: data[index],
            ));

            //  kIsWeb
            //     ? WebGridViewItem(
            //         item: data[index],
            //       )
            //     : widget.listItembuilder == null
            //         ? ListCardItemHorizontal(
            //             useOutlineCard: widget.useCardAsOutLine,
            //             object: data[index],
            //             useImageAsBackground:
            //                 widget.useCardAsImageBackgroud,
            //           )
            //         : widget.listItembuilder!(data[index]));
          },
        );
      },
    );

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
      itemCount: isLoading ? (data.length + 1) : (data.length),
      itemBuilder: (context, index) {
        if (isLoading && index == data.length) {
          return const Center(
              child: Padding(
            padding: EdgeInsets.all(kDefaultPadding),
            child: CircularProgressIndicator(),
          ));
        }
        return widget.listItembuilder == null
            ? ListCardItemHorizontal(
                object: data[index],
                useImageAsBackground: widget.useCardAsImageBackgroud,
              )
            : widget.listItembuilder!(data[index]);
        // return data[index].getCardView(context);
      },
      // ),
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
                    listProvider.fetchList(
                        widget.autoRest.key, widget.autoRest.obj,
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
    return ChangeNotifierProvider.value(
        value: listProvider,
        child: Selector<ListMultiKeyProvider, Tuple3<bool, int, bool>>(
          builder: (context, value, child) {
            debugPrint(
                "ListHorizontalApiAutoRestWidget building widget: ${widget.autoRest.key}");
            bool isLoading = value.item1;
            int count = value.item2;
            bool isError = value.item3;
            if (isError) {
              if (count == 0) {
                return getErrorWidget(context);
              } else {
                return wrapHeader(
                    context,
                    _listItems(listProvider.getList(widget.autoRest.key),
                        listProvider));
              }
            } else if (isLoading) {
              if (count == 0) {
                return wrapHeader(context, listShimmerItems());
              } else {
                return wrapHeader(
                    context,
                    _listItems(listProvider.getList(widget.autoRest.key),
                        listProvider));
              }
            } else {
              if (count == 0) {
                return getEmptyWidget(context);
              }
              return wrapHeader(
                  context,
                  _listItems(
                      listProvider.getList(widget.autoRest.key), listProvider));
            }
          },
          selector: (p0, p1) => Tuple3(
              p1.isLoading(widget.autoRest.key),
              p1.getCount(widget.autoRest.key),
              p1.isHasError(widget.autoRest.key)),
        ));
  }

  Widget wrapHeader(BuildContext context, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHeader(context),
        if (kIsWeb)
          const SizedBox(
            height: kDefaultPadding,
          ),
        if (widget.customHeight != null)
          SizedBox(height: widget.customHeight, child: child)
        else
          Expanded(child: child)
        // if (widget.isSliver)
        //   child
        // else
        // SizedBox(height: widget.customHeight, child: child)
      ],
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
