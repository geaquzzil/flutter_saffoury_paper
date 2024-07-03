// ignore_for_file: constant_identifier_names

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_view_controller/customs_widget/draggable_home.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/lists/horizontal_list_card_item.dart';
import 'package:flutter_view_controller/new_components/qr_code_widget.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/providers/actions/list_scroll_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';

class SliverMaster extends StatefulWidget {
  bool buildSearchWidget;
  bool buildAppBar;
  bool buildFabIfMobile;
  bool buildToggleView;
  String title;
  bool buildHeaderAsQrCodeReader;
  bool buildFilterableView;

  SliverMaster(
      {super.key,
      required this.title,
      this.buildHeaderAsQrCodeReader = false,
      this.buildAppBar = true,
      this.buildSearchWidget = true,
      this.buildFilterableView = false,
      this.buildToggleView = true,
      this.buildFabIfMobile = true});

  @override
  State<SliverMaster> createState() => SliverMasterState();
}

class SliverMasterState<T extends SliverMaster> extends State<T> {
  ViewAbstract? scanedQr;
  final _scrollController = ScrollController();
  ValueNotifier<ExpandType> expandType =
      ValueNotifier<ExpandType>(ExpandType.HALF_EXPANDED);
  ValueNotifier<ExpandType> expandTypeOnlyOnExpand =
      ValueNotifier<ExpandType>(ExpandType.CLOSED);

  ValueNotifier<QrCodeNotifierState> valueNotifierQrState =
      ValueNotifier<QrCodeNotifierState>(
          QrCodeNotifierState(state: QrCodeCurrentState.NONE));

  @override
  Widget build(BuildContext context) {
    return DraggableHome(
        valueNotifierExpandType: expandType,
        valueNotifierExpandTypeOnExpandOny: expandTypeOnlyOnExpand,
        // drawer: DrawerLargeScreens(),
        scrollController: _scrollController,
        floatingActionButton: FloatingActionButton.small(
            heroTag: UniqueKey(),
            onPressed: () {
              scrollTop();
              // context.goNamed(posRouteName);
            },
            child: const Icon(Icons.arrow_drop_up_rounded)),

        // backgroundColor: Colors.red,

        title: Text(widget.title),
        fullyStretchable: widget.buildHeaderAsQrCodeReader ? true : false,
        headerWidget: null,
        expandedBody: onBuildHeaderExtendedBoy(),
        slivers: [
          if (widget.buildSearchWidget) onBuildSearchWidget(),
          if (widget.buildFilterableView) onBuildFilterableWidget(),
          if (widget.buildHeaderAsQrCodeReader)
            ValueListenableBuilder<ExpandType>(
                valueListenable: expandTypeOnlyOnExpand,
                builder: (context, value, child) {
                  debugPrint("SliverApiMaster valueListenable expandType");
                  if (value == ExpandType.EXPANDED) {
                    return getQrCodeSelector();
                  }
                  scanedQr = null;
                  return onBuildSliverList();
                })
          else
            onBuildSliverList()
        ]);
  }

  @override
  void initState() {
    super.initState();
    debugPrint("listApiMaster initState ");
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    debugPrint("listApiMaster dispose");
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final direction = _scrollController.position.userScrollDirection;
    if (direction == ScrollDirection.forward) {
      context.read<ListScrollProvider>().setScrollDirection = direction;
    } else if (direction == ScrollDirection.reverse) {
      context.read<ListScrollProvider>().setScrollDirection = direction;
    }
    if (_isBottom) {
      onScrollOnBottom();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void onScrollOnBottom() {}

  Widget? onBuildHeaderExtendedBoy() {
    return widget.buildHeaderAsQrCodeReader
        ? QrCodeReader(
            getViewAbstract: true,
            currentHeight: 20,
            valueNotifierQrState: valueNotifierQrState,
          )
        : null;
  }

  Widget getQrCodeSelector() {
    return ValueListenableBuilder<QrCodeNotifierState>(
      valueListenable: valueNotifierQrState,
      builder: (context, value, _) {
        switch (value.state) {
          case QrCodeCurrentState.LOADING:
            scanedQr = null;

            return const SliverFillRemaining(
              child: EmptyWidget(
                expand: true,
                lottieJson: "loading_indecator.json",
              ),
            );

          case QrCodeCurrentState.NONE:
            scanedQr = null;
            return const SliverFillRemaining(
              child: EmptyWidget(
                expand: true,
                lottiUrl:
                    "https://assets3.lottiefiles.com/packages/lf20_oqfmttib.json",
              ),
            );

          case QrCodeCurrentState.DONE:
            scanedQr = value.viewAbstract as ViewAbstract;
            scanedQr!.setCustomMap({"<iD>": "${scanedQr!.iD}"});
            return SliverFillRemaining(
              child: Center(
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: ListCardItemHorizontal<ViewAbstract>(
                      useImageAsBackground: true,
                      object: scanedQr as ViewAbstract),
                ),
              ),
            );
            break;
        }
        // return getListSelector();
      },
    );
  }

  void scrollTop() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 700),
      curve: Curves.fastOutSlowIn,
    );
  }

  Widget onBuildSliverList() {
    return const SliverToBoxAdapter(child: SizedBox());
  }

  Widget onBuildFilterableWidget() {
    return const SliverToBoxAdapter(child: SizedBox());
  }

  Widget onBuildSearchWidget() {
    return const SliverToBoxAdapter(child: SizedBox());
  }

  Widget getEmptyWidget({bool isError = false}) {
    return SliverFillRemaining(
      child: _getEmptyWidget(isError),
    );
  }

  EmptyWidget _getEmptyWidget(bool isError) {
    return EmptyWidget(
        lottiUrl: "https://assets7.lottiefiles.com/packages/lf20_0s6tfbuc.json",
        title: isError
            ? AppLocalizations.of(context)!.cantConnect
            : AppLocalizations.of(context)!.noItems,
        subtitle: isError
            ? AppLocalizations.of(context)!.no_search_result
            : AppLocalizations.of(context)!.no_content);
  }

  Widget getShimmerLoading() {
    return SliverFillRemaining(
      child: SkeletonTheme(
        shimmerGradient: const LinearGradient(
          colors: [
            Color(0xFFD8E3E7),
            Color(0xFFC8D5DA),
            Color(0xFFD8E3E7),
          ],
          stops: [
            0.1,
            0.5,
            0.9,
          ],
        ),
        darkShimmerGradient: const LinearGradient(
          colors: [
            Color(0xFF222222),
            Color(0xFF242424),
            Color(0xFF2B2B2B),
            Color(0xFF242424),
            Color(0xFF222222),
            // Color(0xFF242424),
            // Color(0xFF2B2B2B),
            // Color(0xFF242424),
            // Color(0xFF222222),
          ],
          stops: [
            0.0,
            0.2,
            0.5,
            0.8,
            1,
          ],
          // begin: Alignment(-2.4, -0.2),
          // end: Alignment(2.4, 0.2),
          // tileMode: TileMode.clamp,
        ),
        child: SkeletonListView(
          itemCount: Random().nextInt(10 - 5),
        ),
      ),
    );
  }
}

enum SliverListMood { NONE, SELECT }
