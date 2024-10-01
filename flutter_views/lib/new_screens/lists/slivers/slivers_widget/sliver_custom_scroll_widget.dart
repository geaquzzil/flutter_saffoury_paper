import 'package:flutter/material.dart';
import 'package:flutter_view_controller/configrations.dart';
import 'package:flutter_view_controller/customs_widget/color_tabbar.dart';
import 'package:flutter_view_controller/customs_widget/sliver_delegates.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:flutter_view_controller/utils/responsive_scroll.dart';
import 'package:rxdart/rxdart.dart';

class SliverCustomScrollView extends StatefulWidget {
  List<Widget> slivers;
  ScrollController? scrollController;
  List<TabControllerHelper>? tabs;
  List<Widget> Function(ScrollController, TabControllerHelper?)? builder;
  String? scrollKey;
  ScrollPhysics? physics;

  //this works with one object only todo cant retrun full List
  Widget Function(bool fullyCol, bool fullyExp,TabControllerHelper?tab)? builderAppbar;
  SliverCustomScrollView(
      {super.key,
      required this.slivers,
      this.scrollController,
      this.builder,
      this.builderAppbar,
      this.physics,
      this.tabs,
      this.scrollKey});

  @override
  State<SliverCustomScrollView> createState() =>
      _SliverCustomScrollViewDraggableState();
}

class _SliverCustomScrollViewDraggableState
    extends State<SliverCustomScrollView> with TickerProviderStateMixin {
  TabController? _tabController;
  List<TabControllerHelper>? _tabs;
  late ScrollController _scrollController;
  late String bucketOffsetKey;

  final BehaviorSubject<bool> isFullyExpanded =
      BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<bool> isFullyCollapsed =
      BehaviorSubject<bool>.seeded(false);

  late ValueNotifier<int> onTabSelectedValueNotifier;

  late double expandedHeight;

  static const double headerExpandedHeight = .7;
  @override
  void initState() {
    _scrollController = widget.scrollController ?? ScrollController();
    bucketOffsetKey = widget.scrollKey ?? "scrollKey";
    if (widget.tabs != null) {
      onTabSelectedValueNotifier = ValueNotifier<int>(0);
      _tabs = <TabControllerHelper>[];
      _tabs!.clear();
      _tabs!.addAll(widget.tabs!);
      _tabController = TabController(length: _tabs!.length, vsync: this)
        ..addListener(onTabSelected);
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SliverCustomScrollView oldWidget) {
    bucketOffsetKey = widget.scrollKey ?? "scrollKey";
    debugPrint("didUpdateWidget draggable $bucketOffsetKey");
    // WidgetsBinding.instance.addPostFrameCallback((c) {
    //   if (mounted) {
    //     double lastSavedScroll =
    //         Configurations.currentPageScrollOffset(context, bucketOffsetKey);
    //     if (lastSavedScroll != 0) {
    //       _scrollTo(lastSavedScroll);
    //     } else {
    //       _scrollTop();
    //     }
    //   }
    // });
    if (widget.tabs != null) {
      _tabs = <TabControllerHelper>[];
      _tabs!.clear();
      _tabs!.addAll(widget.tabs!);
      _tabController?.removeListener(onTabSelected);
      _tabController?.dispose();
      _tabController = TabController(length: _tabs!.length, vsync: this)
        ..addListener(onTabSelected);
    }
    super.didUpdateWidget(oldWidget);
  }

  void onTabSelected() {
    onTabSelectedValueNotifier.value = _tabController?.index ?? 0;
    // onTabSelectedVal.value = _tabController!.index;
  }

  bool canExpandBody() {
    return isMobile(context);
  }

  Widget getTabbarSliver() {
    return SliverSafeArea(
      sliver: SliverPadding(
        padding: EdgeInsets.zero,
        sliver: SliverPersistentHeader(
            pinned: true,
            delegate: SliverAppBarDelegatePreferedSize(
                wrapWithSafeArea: true,
                child: ColoredTabBar(
                  useCard: false,
                  color: Theme.of(context).colorScheme.surface.withOpacity(.9),
                  cornersIfCard: 80.0,
                  // color: Theme.of(context).colorScheme.surfaceVariant,
                  child: TabBar(
                    dividerColor: const Color.fromARGB(0, 222, 86, 86),
                    tabs: _tabs!,
                    isScrollable: true,
                    controller: _tabController,
                  ),
                ))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    expandedHeight = canExpandBody()
        ? MediaQuery.of(context).size.height * headerExpandedHeight
        : 0;

    return PageStorage(
      bucket: appBucket,
      child: hasTabbar()
          ? ValueListenableBuilder(
              valueListenable: onTabSelectedValueNotifier,
              builder: (c, x, v) => getNotificationListener(tab: _tabs?[x]))
          : getNotificationListener(),
    );
  }

  bool hasTabbar() {
    return _tabs != null && (_tabs?.isNotEmpty ?? false);
  }

  Widget sliver({TabControllerHelper? tab}) {
    return SafeArea(
      child: ResponsiveScroll(
        controller: _scrollController,
        child: CustomScrollView(
            controller: _scrollController,
            physics: widget.physics ??
                const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              if (widget.builderAppbar != null)
                StreamBuilder<List<bool>>(
                  stream: CombineLatestStream.list<bool>([
                    isFullyCollapsed.stream,
                    isFullyExpanded.stream,
                  ]),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<bool>> snapshot) {
                    final List<bool> streams =
                        (snapshot.data ?? [false, false]);
                    final bool fullyCollapsed = streams[0];
                    final bool fullyExpanded = streams[1];
                    return widget.builderAppbar!
                        .call(fullyCollapsed, fullyExpanded,tab);
                  },
                ),
              if (hasTabbar()) getTabbarSliver(),
              if (widget.builder != null)
                ...widget.builder!.call(_scrollController, tab)
              else
                ...widget.slivers
            ]),
      ),
    );
  }

  String getKeyForSaving({TabControllerHelper? tab}) {
    return bucketOffsetKey + ((tab?.text) ?? "");
  }

  NotificationListener<ScrollNotification> getNotificationListener(
      {TabControllerHelper? tab}) {
    return NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollEndNotification &&
              notification.metrics.axis == Axis.vertical) {
            Configurations.saveScrollOffset(context,
                notification.metrics.pixels, getKeyForSaving(tab: tab));
          }
          if (notification.metrics.axis == Axis.vertical) {
            if ((isFullyExpanded.value) &&
                notification.metrics.extentBefore > 100) {
              isFullyExpanded.add(false);
            }

            //isFullyCollapsed
            if (notification.metrics.extentBefore >
                expandedHeight - AppBar().preferredSize.height - 40) {
              if (!(isFullyCollapsed.value)) isFullyCollapsed.add(true);
            } else {
              if ((isFullyCollapsed.value)) isFullyCollapsed.add(false);
            }
          }
          return false;
        },
        child: sliver(tab: tab));
  }

  void _scrollDown() {
    if (_scrollController.hasClients == false) return;
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 400),
      curve: Curves.fastOutSlowIn,
    );
  }

  void _scrollTo(double pos) {
    debugPrint("scrollTo pos===> $pos");
    if (_scrollController.hasClients == false) return;
    _scrollController.animateTo(
      pos,
      duration: const Duration(milliseconds: 700),
      curve: Curves.fastOutSlowIn,
    );
  }

  void _scrollToHideTopWidget() {
    debugPrint("_scrollToHideTopWidget ===> top");
    if (_scrollController.hasClients == false) return;
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 700),
      curve: Curves.fastOutSlowIn,
    );
  }

  void _scrollTop() {
    debugPrint("scrollTo ===> top");
    if (_scrollController.hasClients == false) return;
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 700),
      curve: Curves.fastOutSlowIn,
    );
  }

  void _scrollToCollapsed() {
    if (_scrollController.hasClients == false) return;
    _scrollController.jumpTo(500);
  }
}
