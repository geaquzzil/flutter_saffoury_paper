// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/slivers_widget/sliver_custom_scroll_widget.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:rxdart/rxdart.dart';

class SliverCustomScrollViewDraggableHelper {
  List<Widget> widget;
  Widget? expandHeaderWidget;
  Widget? headerWidget;
  Widget? expandBottomWidget;
  SliverCustomScrollViewDraggableHelper({
    required this.widget,
    this.expandHeaderWidget,
    this.headerWidget,
    this.expandBottomWidget,
  });
}

class SliverCustomScrollViewDraggable extends StatefulWidget {
  final List<Widget> slivers;
  final SliverCustomScrollViewDraggableHelper Function(
      ScrollController, TabControllerHelper?)? builder;
  final List<TabControllerHelper>? tabs;
  final ScrollController? scrollController;
  final String? scrollKey;
  final ScrollPhysics? physics;
  final Widget? title;
  final bool pinToolbar;
  final List<Widget>? actions;
  final Widget? expandHeaderWidget;
  final Widget? headerWidget;
  final Widget? expandBottomWidget;
  const SliverCustomScrollViewDraggable(
      {super.key,
      required this.slivers,
      this.title,
      this.scrollController,
      this.builder,
      this.pinToolbar = false,
      this.expandHeaderWidget,
      this.tabs,
      this.expandBottomWidget,
      this.headerWidget,
      this.actions,
      this.physics,
      this.scrollKey});

  @override
  State<SliverCustomScrollViewDraggable> createState() =>
      _SliverCustomScrollViewDraggableState();
}

class _SliverCustomScrollViewDraggableState
    extends State<SliverCustomScrollViewDraggable> {
  late ScrollController _scrollController;
  late String bucketOffsetKey;
  final BehaviorSubject<bool> isFullyExpanded =
      BehaviorSubject<bool>.seeded(false);

  late double appBarHeight;
  late double topPadding;
  late double expandedHeight;
  late double fullyExpandedHeight;

  static const double stretchMaxHeight = .7;
  static const double headerExpandedHeight = .7;
  static const double curvedBodyRadius = 20;

  @override
  void initState() {
    _scrollController = widget.scrollController ?? ScrollController();
    bucketOffsetKey = widget.scrollKey ?? "scrollKey";

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SliverCustomScrollViewDraggable oldWidget) {
    bucketOffsetKey = widget.scrollKey ?? "scrollKey";
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    appBarHeight = AppBar().preferredSize.height + curvedBodyRadius;

    topPadding = MediaQuery.of(context).padding.top;

    expandedHeight = canExpandBody()
        ? MediaQuery.of(context).size.height * headerExpandedHeight
        : 0;

    fullyExpandedHeight = canExpandBody()
        ? MediaQuery.of(context).size.height * (stretchMaxHeight)
        : 0;

    return SliverCustomScrollView(
      tabs: widget.tabs,
      physics: widget.physics,
      builder: widget.builder == null
          ? null
          : (scrollController, tab) {
              return [
                SliverToBoxAdapter(
                  child: expandedUpArrow(),
                ),
                ...widget.builder!.call(scrollController, tab).widget
              ];
            },
      scrollController: _scrollController,
      scrollKey: widget.scrollKey,
      builderAppbar: widget.title == null
          ? null
          : (fullyCol, fullyExp, tab) {
              return getSliverAppbar(context, fullyCol, appBarHeight, fullyExp,
                  fullyExpandedHeight, expandedHeight,
                  customTabHeader:
                      widget.builder?.call(_scrollController, tab).headerWidget,
                  customTabExpandedHeader: widget.builder
                      ?.call(_scrollController, tab)
                      .expandHeaderWidget);
            },
      slivers: [
        SliverToBoxAdapter(
          child: expandedUpArrow(),
        ),
        ...widget.slivers,
      ],
    );
  }

  StreamBuilder<bool> expandedUpArrow() {
    return StreamBuilder<bool>(
      stream: isFullyExpanded.stream,
      builder: (context, snapshot) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          height: (snapshot.data ?? false) ? 40 : 0,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: IconButton(
              icon: const Icon(
                Icons.keyboard_arrow_up_rounded,
              ),
              onPressed: () {},
            ),
          ),
        );
      },
    );
  }

  Widget getSliverTitle(bool fullyCollapsed) {
    return AnimatedOpacity(
      opacity: canExpandBody() ? (fullyCollapsed ? 0 : 1) : 1,
      duration: const Duration(milliseconds: 100),
      child: widget.title,
    );
  }

  Widget? getSliverAppbarLeading() {
    return null;
  }

  List<Widget>? getSliverAppbarActions() {
    return widget.actions ?? [Container()];
  }

  bool canExpandBody() {
    return isMobile(context);
  }

  bool hasFlexibleSpace() {
    return canExpandBody();
  }

  Widget? getFlexibleSpace(bool fullyExpanded, bool fullyCollapsed,
      {Widget? customTabHeader, Widget? customTabExpandedHeader}) {
    if (!hasFlexibleSpace()) {
      return null;
    }
    return getFlixibleSpaceWidget(fullyExpanded, fullyCollapsed,
        customTabHeader: customTabHeader,
        customTabExpandedHeader: customTabExpandedHeader);
  }

  Widget getFlixibleSpaceWidget(bool fullyExpanded, bool fullyCollapsed,
      {Widget? customTabHeader, Widget? customTabExpandedHeader}) {
    return Center(
      child: Stack(
        children: [
          FlexibleSpaceBar(
            background: Card(
                child: Container(
                    // color: Theme.of(context).colorScheme.surfaceVariant,
                    margin: EdgeInsets.only(
                        bottom: 0.2, top: AppBar().preferredSize.height),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: fullyExpanded
                          ? (customTabExpandedHeader ??
                              widget.expandHeaderWidget ??
                              const SizedBox())
                          : customTabHeader ?? widget.headerWidget,
                    ))),
          ),
          Positioned(
            bottom: -1,
            left: 0,
            right: 0,
            child: roundedCorner(context),
          ),
          Positioned(
            bottom: 0 + curvedBodyRadius,
            child: AnimatedContainer(
              padding: const EdgeInsets.only(left: 10, right: 10),
              curve: Curves.easeInOutCirc,
              duration: const Duration(milliseconds: 100),
              height: fullyCollapsed
                  ? 0
                  : fullyExpanded
                      ? 0
                      : kToolbarHeight,
              width: MediaQuery.of(context).size.width,
              child: fullyCollapsed
                  ? const SizedBox()
                  : fullyExpanded
                      ? const SizedBox()
                      : widget.expandBottomWidget ?? Container(),
            ),
          )
        ],
      ),
    );
  }

  Container roundedCorner(BuildContext context) {
    return Container(
      height: curvedBodyRadius,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(curvedBodyRadius),
        ),
      ),
    );
  }

  Future<void> Function()? onStretchTrigger() {
    return null;
  }

  double getStretchTriggerOffset() {
    if (canExpandBody()) {
      return 50;
    }
    return 100;
  }

  SliverAppBar getSliverAppbar(
      BuildContext context,
      bool fullyCollapsed,
      double appBarHeight,
      bool fullyExpanded,
      double fullyExpandedHeight,
      double expandedHeight,
      {Widget? customTabHeader,
      Widget? customTabExpandedHeader}) {
    return SliverAppBar(
      automaticallyImplyLeading: canExpandBody(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      leading: getSliverAppbarLeading(),
      actions: getSliverAppbarActions(),
      elevation: 10,
      pinned: false,
      stretch: canExpandBody(),
      title: getSliverTitle(fullyCollapsed),
      collapsedHeight: canExpandBody() ? appBarHeight : null,
      expandedHeight: fullyExpanded ? fullyExpandedHeight : expandedHeight,
      flexibleSpace: getFlexibleSpace(
        fullyExpanded,
        fullyCollapsed,
      ),
      stretchTriggerOffset: getStretchTriggerOffset(),
      onStretchTrigger: canExpandBody()
          ? () async {
              if (!fullyExpanded) isFullyExpanded.add(true);
            }
          : null,
    );
  }
}
