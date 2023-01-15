import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/customs_widget/color_tabbar.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/new_components/lists/slivers/sliver_animated_card.dart';
import 'package:flutter_view_controller/new_components/scroll_to_hide_widget.dart';
import 'package:flutter_view_controller/new_screens/base_material_app.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import 'sliver_delegates.dart';

enum ExpandType { CLOSED, HALF_EXPANDED, EXPANDED }

class DraggableHome extends StatefulWidget {
  @override
  _DraggableHomeState createState() => _DraggableHomeState();

  /// Leading: A widget to display before the toolbar's title.
  final Widget? leading;

  final ScrollController? scrollController;

  /// Title: A Widget to display title in AppBar
  final Widget? title;

  /// Center Title: Allows toggling of title from the center. By default title is in the center.
  final bool centerTitle;

  /// Action: A list of Widgets to display in a row after the title widget.
  final List<Widget>? actions;

  /// Always Show Leading And Action : This make Leading and Action always visible. Default value is false.
  final bool alwaysShowLeadingAndAction;

  /// Always Show Title : This make Title always visible. Default value is false.
  final bool alwaysShowTitle;

  /// Drawer: Drawers are typically used with the Scaffold.drawer property.
  final Widget? drawer;

  /// Header Expanded Height : Height of the header widget. The height is a double between 0.0 and 1.0. The default value of height is 0.35 and should be less than stretchMaxHeigh
  final double headerExpandedHeight;

  /// Header Widget: A widget to display Header above body.
  final Widget? headerWidget;

  /// headerBottomBar: AppBar or toolBar like widget just above the body.

  final Widget? headerBottomBar;

  /// backgroundColor: The color of the Material widget that underlies the entire DraggableHome body.
  final Color? backgroundColor;

  /// appBarColor: The color of the scaffold app bar.
  final Color? appBarColor;

  /// curvedBodyRadius: Creates a border top left and top right radius of body, Default radius of the body is 20.0. For no radius simply set value to 0.
  final double curvedBodyRadius;

  /// body: A widget to Body
  final List<Widget> slivers;

  /// fullyStretchable: Allows toggling of fully expand draggability of the DraggableHome. Set this to true to allow the user to fully expand the header.
  final bool fullyStretchable;

  /// stretchTriggerOffset: The offset of overscroll required to fully expand the header.
  final double stretchTriggerOffset;

  /// expandedBody: A widget to display when fully expanded as header or expandedBody above body.
  final Widget? expandedBody;

  /// stretchMaxHeight: Height of the expandedBody widget. The height is a double between 0.0 and 0.95. The default value of height is 0.9 and should be greater than headerExpandedHeight
  final double stretchMaxHeight;

  /// floatingActionButton: An object that defines a position for the FloatingActionButton based on the Scaffold's ScaffoldPrelayoutGeometry.
  final Widget? floatingActionButton;

  /// bottomSheet: A persistent bottom sheet shows information that supplements the primary content of the app. A persistent bottom sheet remains visible even when the user interacts with other parts of the app.
  final Widget? bottomSheet;

  /// bottomNavigationBarHeight: This is requires when using custom height to adjust body height. This make no effect on bottomNavigationBar.
  final double? bottomNavigationBarHeight;

  /// bottomNavigationBar: Snack bars slide from underneath the bottom navigation bar while bottom sheets are stacked on top.
  final Widget? bottomNavigationBar;

  /// floatingActionButtonLocation: An object that defines a position for the FloatingActionButton based on the Scaffold's ScaffoldPrelayoutGeometry.
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// floatingActionButtonAnimator: Provider of animations to move the FloatingActionButton between FloatingActionButtonLocations.
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;

  final ScrollPhysics? physics;
  final bool hideBottomNavigationBarOnScroll;
  final List<TabControllerHelper>? tabs;

  final ValueNotifier<ExpandType>? valueNotifierExpandType;
  final ValueNotifier<ExpandType>? valueNotifierExpandTypeOnExpandOny;
  // final Widget? tabbar;
  final bool showAppbarOnTopOnly;

  /// This will create DraggableHome.
  const DraggableHome(
      {Key? key,
      this.leading,
      this.title,
      this.centerTitle = true,
      this.actions,
      this.alwaysShowLeadingAndAction = false,
      this.showAppbarOnTopOnly = true,
      this.valueNotifierExpandTypeOnExpandOny,
      this.alwaysShowTitle = false,
      this.headerExpandedHeight = 0.4,
      this.scrollController,
      this.headerWidget,
      this.headerBottomBar,
      this.hideBottomNavigationBarOnScroll = true,
      this.backgroundColor,
      this.valueNotifierExpandType,
      this.appBarColor,
      this.curvedBodyRadius = 20,
      required this.slivers,
      this.tabs,
      this.drawer,
      this.fullyStretchable = false,
      this.stretchTriggerOffset = 100,
      this.expandedBody,
      this.stretchMaxHeight = 0.5,
      this.bottomSheet,
      this.bottomNavigationBarHeight = kBottomNavigationBarHeight,
      this.bottomNavigationBar,
      this.floatingActionButton,
      this.floatingActionButtonLocation,
      this.floatingActionButtonAnimator,
      this.physics})
      : assert(headerExpandedHeight > 0.0 &&
            headerExpandedHeight < stretchMaxHeight),
        assert(
          (stretchMaxHeight > headerExpandedHeight) && (stretchMaxHeight < .95),
        ),
        super(key: key);
}

class _DraggableHomeState extends State<DraggableHome>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  bool isPlaying = false;
  final BehaviorSubject<bool> isFullyExpanded =
      BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<bool> isFullyCollapsed =
      BehaviorSubject<bool>.seeded(false);
  TabController? _tabController;
  List<TabControllerHelper>? _tabs;
  final bucket = PageStorageBucket();
  ValueNotifier<int> onTabSelected = ValueNotifier<int>(0);
  final GlobalKey<SliverAnimatedListState> _listKey =
      GlobalKey<SliverAnimatedListState>();
  int currentPage = 0;

  ValueNotifier<bool> hideWhenScroll = ValueNotifier<bool>(false);

  List<Widget> animatedWidgets = [];

  @override
  void dispose() {
    isFullyExpanded.close();
    isFullyCollapsed.close();
    _tabController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));
    _animationController.forward();
    if (widget.tabs != null) {
      _tabs = <TabControllerHelper>[];
      _tabs!.clear();
      _tabs!.addAll(widget.tabs!);
      _tabController = TabController(length: _tabs!.length, vsync: this)
        ..addListener(() async {
          onTabSelected.value = _tabController!.index;
          // await widget.scrollController?.animateTo(
          //   0,
          //   duration: Duration(seconds: 1),
          //   curve: Curves.ease,
          // );
        });
      ;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double appBarHeight =
        AppBar().preferredSize.height + widget.curvedBodyRadius;

    final double topPadding = MediaQuery.of(context).padding.top;

    double expandedHeight =
        MediaQuery.of(context).size.height * widget.headerExpandedHeight;

    final double fullyExpandedHeight =
        MediaQuery.of(context).size.height * (widget.stretchMaxHeight);

    return Scaffold(
      backgroundColor:
          widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      drawer: widget.drawer,
      body: PageStorage(
        bucket: bucket,
        child: getNotificationListener(expandedHeight, context, appBarHeight,
            fullyExpandedHeight, topPadding),
      ),
      bottomSheet: widget.bottomSheet,
      bottomNavigationBar: getBottomNavigationBar(),
      floatingActionButton: getScaffoldFloatingActionButton(),
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      floatingActionButtonAnimator: widget.floatingActionButtonAnimator,
    );
  }

  Widget getTabbar(BuildContext context) {
    // final availableHeight = MediaQuery.of(context).padding.top;
    return SliverSafeArea(
      sliver: SliverPadding(
        padding: const EdgeInsets.only(
            top: kDefaultPadding, left: kDefaultPadding / 2),
        sliver: SliverPersistentHeader(
            pinned: true,
            delegate: SliverAppBarDelegatePreferedSize(
                wrapWithSafeArea: true,
                child: ColoredTabBar(
                  useCard: true,
                  cornersIfCard: 80.0,
                  // color: Theme.of(context).colorScheme.surfaceVariant,
                  child: TabBar(
                    // padding: EdgeInsets.all(kDefaultPadding),
                    labelStyle: Theme.of(context).textTheme.titleSmall,
                    indicatorColor:
                        Theme.of(context).colorScheme.primary.withOpacity(.2),
                    labelColor: Theme.of(context).colorScheme.primary,
                    tabs: _tabs!,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(80.0),
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(.2),
                    ),
                    isScrollable: true,
                    controller: _tabController,
                  ),
                ))),
      ),
    );
  }

  Widget getTabsNotificationListener(
      double expandedHeight,
      BuildContext context,
      double appBarHeight,
      double fullyExpandedHeight,
      double topPadding) {
    return NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [],
        body: TabBarView(
            controller: _tabController,
            children: _tabs!
                .map((e) => Builder(builder: (BuildContext context) {
                      return getNotificationListener(expandedHeight, context,
                          appBarHeight, fullyExpandedHeight, topPadding,
                          tab: e);
                    }))
                .toList()));
  }

  NotificationListener<ScrollNotification> getNotificationListener(
      double expandedHeight,
      BuildContext context,
      double appBarHeight,
      double fullyExpandedHeight,
      double topPadding,
      {TabControllerHelper? tab}) {
    return NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          // debugPrint("DraggableHome  ${notification.metrics.extentBefore}");
          // if (widget.showAppbarOnTopOnly && widget.scrollController != null) {
          //   debugPrint(
          //       "DraggableHome ${widget.scrollController!.position.pixels}");
          //   if (widget.scrollController!.position.pixels >= 200) {
          //     if (isFullyExpanded.value) isFullyExpanded.add(false);
          //     if ((!isFullyCollapsed.value)) isFullyCollapsed.add(true);
          //     // expandedHeight = 0;
          //     return false;
          //   }
          // }

          if (notification.metrics.axis == Axis.vertical) {
            // isFullyCollapsed
            if ((isFullyExpanded.value) &&
                notification.metrics.extentBefore > 100) {
              isFullyExpanded.add(false);
            }
            // if (widget.hideBottomNavigationBarOnScroll) {
            //   if (notification.metrics.extentBefore > 100) {
            //     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            //       hideWhenScroll.value = true;
            //     });
            //   } else {
            //     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            //       hideWhenScroll.value = false;
            //     });
            //   }
            // }

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
        child: sliver(context, appBarHeight, fullyExpandedHeight,
            expandedHeight, topPadding));
  }

  Widget? getBottomNavigationBar() {
    Widget? child = widget.bottomNavigationBar;
    if (widget.bottomNavigationBar == null ||
        !widget.hideBottomNavigationBarOnScroll) {
      return child;
    }
    return ScrollToHideWidget(
        height: widget.bottomNavigationBarHeight ?? kBottomNavigationBarHeight,
        controller: widget.scrollController,
        child: child!);
  }

  Widget? getScaffoldFloatingActionButton() {
    Widget? child = widget.floatingActionButton;
    if (widget.valueNotifierExpandType == null) {
      return child;
    }
    return child;
    return ValueListenableBuilder(
      valueListenable: widget.valueNotifierExpandType!,
      builder: (context, value, child) => AnimatedOpacity(
        opacity: value == ExpandType.EXPANDED ? 1 : 0,
        duration: const Duration(milliseconds: 300),
        child: child,
      ),
    );
  }

  Widget sliver(
    BuildContext context,
    double appBarHeight,
    double fullyExpandedHeight,
    double expandedHeight,
    double topPadding,
  ) {
    Widget child = ValueListenableBuilder<int>(
      valueListenable: onTabSelected,
      builder: (_, value, ___) {
        Widget? toggleWidget;
        if (_tabs != null) {
          toggleWidget = getToggleWidget(_tabs![value]);
        }
        return SafeArea(
          child: CustomScrollView(
            key: const PageStorageKey<String>('saveState'),
            controller: widget.scrollController,
            physics: widget.physics ?? const BouncingScrollPhysics(),
            slivers: [
              StreamBuilder<List<bool>>(
                stream: CombineLatestStream.list<bool>([
                  isFullyCollapsed.stream,
                  isFullyExpanded.stream,
                ]),
                builder:
                    (BuildContext context, AsyncSnapshot<List<bool>> snapshot) {
                  final List<bool> streams = (snapshot.data ?? [false, false]);
                  final bool fullyCollapsed = streams[0];
                  final bool fullyExpanded = streams[1];
                  if (toggleWidget != null) {
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      if (!fullyCollapsed && !fullyExpanded) {
                        if (animatedWidgets.isEmpty) return;
                        Widget removed = animatedWidgets.removeAt(0);
                        _listKey.currentState?.removeItem(
                            0,
                            (context, animation) => SliverAnimatedCard(
                                animation: animation, child: removed));
                      } else if (fullyCollapsed && !fullyExpanded) {
                        animatedWidgets.add(_tabs![value]
                            .draggableSwithHeaderFromAppbarToScroll!);
                        _listKey.currentState?.insertItem(0);
                      }
                    });
                  }
                  notifyListenerWidgetBinding(fullyCollapsed, fullyExpanded);

                  return SliverAppBar(
                    automaticallyImplyLeading: true,
                    backgroundColor: Theme.of(context).colorScheme.background,
                    // surfaceTintColor: Theme.of(context).colorScheme.primary,
                    // !fullyCollapsed ? widget.backgroundColor : widget.appBarColor,
                    leading: getLeadingAppBar(context),
                    // leading: widget.alwaysShowLeadingAndAction
                    //     ? widget.leading
                    //     : !fullyCollapsed
                    //         ? const SizedBox()
                    //         : widget.leading,
                    actions: widget.alwaysShowLeadingAndAction
                        ? widget.actions
                        : !fullyCollapsed
                            ? []
                            : widget.actions,
                    elevation: 0,
                    pinned: false,
                    // floating: true,
                    stretch: true,
                    centerTitle: widget.centerTitle,
                    title: widget.title == null
                        ? null
                        : widget.alwaysShowTitle
                            ? widget.title
                            : AnimatedOpacity(
                                opacity: fullyCollapsed ? 1 : 0,
                                duration: const Duration(milliseconds: 100),
                                child: widget.title,
                              ),

                    collapsedHeight: appBarHeight,
                    expandedHeight:
                        fullyExpanded ? fullyExpandedHeight : expandedHeight,
                    flexibleSpace: _tabs != null
                        ? ValueListenableBuilder<int>(
                            valueListenable: onTabSelected,
                            builder: (context, value, child) => getSliverSpace(
                                fullyExpanded, context, fullyCollapsed,
                                tabFullyExpanded:
                                    _tabs![value].draggableExtendedWidget,
                                tabHeaderWidget: _tabs![value]
                                        .draggableSwithHeaderFromAppbarToScroll ??
                                    _tabs![value].draggableHeaderWidget),
                          )
                        : widget.headerWidget != null
                            ? getSliverSpace(
                                fullyExpanded, context, fullyCollapsed)
                            : null,
                    stretchTriggerOffset: widget.stretchTriggerOffset,
                    onStretchTrigger: widget.fullyStretchable
                        ? () async {
                            if (!fullyExpanded) isFullyExpanded.add(true);
                          }
                        : null,
                  );
                },
              ),
              if (_tabs != null) getTabbar(context),
              if (toggleWidget != null) toggleWidget,
              SliverToBoxAdapter(
                child: expandedUpArrow(),
              ),
              // TabBarView(children: children)
              if (_tabs != null)
                ...getTabWidget(_tabs![value])
              else
                ...widget.slivers,
              // sliverList(context, appBarHeight + topPadding),
            ],
          ),
        );
      },
    );
    if (_tabs != null) {
      return GestureDetector(
          onHorizontalDragEnd: (dragDetails) {
            if (dragDetails.primaryVelocity != 0) {
              final int val = dragDetails.primaryVelocity!.sign.toInt();
              if (currentPage - val >= 0 &&
                  currentPage - val < _tabController!.length) {
                _tabController!.animateTo(currentPage - val);
              }
            }
          },
          child: child);
    }
    return child;
  }

  Widget? getToggleWidget(TabControllerHelper tab) {
    if (tab.draggableSwithHeaderFromAppbarToScroll == null) return null;
    debugPrint("DraggableHome draggableSwithHeaderFromAppbarToScroll ");
    if (widget.valueNotifierExpandType == null) return null;
    debugPrint("DraggableHome valueNotifierExpandType ");
    return SliverAnimatedList(
      initialItemCount: animatedWidgets.length,
      key: _listKey,
      itemBuilder: (context, index, animation) {
        return SliverAnimatedCard(
            animation: animation, child: animatedWidgets[index]);
      },
    );
    // SliverAnimatedList(itemBuilder: itemBuilder)
    return ValueListenableBuilder<ExpandType>(
      valueListenable: widget.valueNotifierExpandType!,
      builder: (__, v, _) {
        debugPrint("DraggableHome getToggleWidget $v");
        return AnimatedContainer(
          padding: const EdgeInsets.only(left: 10, right: 10),
          // curve: Curves.easeInOutCirc,
          duration: const Duration(milliseconds: 750),
          height: v == ExpandType.CLOSED ? null : 0,
          child: v == ExpandType.CLOSED
              ? tab.draggableSwithHeaderFromAppbarToScroll
              : const SizedBox(),
        );
      },
    );
  }

  List<Widget> getTabWidget(TabControllerHelper tab) {
    bool hasSlivers = tab.slivers != null;
    return [
      if (!hasSlivers)
        SliverFillRemaining(
            fillOverscroll: true, hasScrollBody: false, child: tab.widget),
      ...?tab.slivers?.map((e) => e).toList()
    ];
  }

  Widget? getLeadingAppBar(BuildContext context) {
    Widget icon = IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.arrow_menu,
        progress: _animationController,
      ),
      onPressed: () {
        context.read<DrawerMenuControllerProvider>().controlStartDrawerMenu();
      },
    );
    if (widget.valueNotifierExpandType == null) {
      return icon;
    } else {
      return ValueListenableBuilder<ExpandType>(
        valueListenable: widget.valueNotifierExpandType!,
        builder: (context, value, child) {
          return AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: value == ExpandType.HALF_EXPANDED ? 1 : 0,
            child: icon,
          );
        },
      );
    }
  }

  Widget getSliverSpace(
      bool fullyExpanded, BuildContext context, bool fullyCollapsed,
      {Widget? tabFullyExpanded, Widget? tabHeaderWidget}) {
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
                        ? tabFullyExpanded ??
                            (widget.expandedBody ?? const SizedBox())
                        : tabHeaderWidget ?? widget.headerWidget,
                  )),
            ),
          ),
          Positioned(
            bottom: -1,
            left: 0,
            right: 0,
            child: roundedCorner(context),
          ),
          Positioned(
            bottom: 0 + widget.curvedBodyRadius,
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
                      : widget.headerBottomBar ?? Container(),
            ),
          )
        ],
      ),
    );
  }

  Container roundedCorner(BuildContext context) {
    return Container(
      height: widget.curvedBodyRadius,
      decoration: BoxDecoration(
        color:
            widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(widget.curvedBodyRadius),
        ),
      ),
    );
  }

  SliverList sliverList(BuildContext context, double topHeight) {
    final double bottomPadding =
        widget.bottomNavigationBar == null ? 0 : kBottomNavigationBarHeight;
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height -
                    topHeight -
                    bottomPadding,
                color: widget.backgroundColor ??
                    Theme.of(context).scaffoldBackgroundColor,
              ),
              Column(
                children: [
                  expandedUpArrow(),
                  //Body
                  const Text("this is  abody")
                ],
              ),
            ],
          ),
        ],
      ),
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
              onPressed: () {
                // _scrollDown();
                _scrollDown();
              },
              // color: (snapshot.data ?? false) ? null : Colors.transparent,
            ),
          ),
        );
      },
    );
  }

  void _scrollDown() {
    widget.scrollController?.animateTo(
      widget.scrollController!.position.maxScrollExtent,
      duration: const Duration(milliseconds: 400),
      curve: Curves.fastOutSlowIn,
    );
  }

  void _scrollTop() {
    widget.scrollController?.animateTo(
      widget.scrollController!.position.minScrollExtent,
      duration: const Duration(milliseconds: 700),
      curve: Curves.fastOutSlowIn,
    );
  }

  void _scrollToCollapsed() {
    widget.scrollController?.jumpTo(500);
  }

  void notifyListenerWidgetBinding(bool fullyCollapsed, bool fullyExpanded) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      notifyListeners(fullyCollapsed, fullyExpanded);
    });
  }

  void notifyListeners(bool fullyCollapsed, bool fullyExpanded) {
    // final provider = context.read<DraggableHomeExpandProvider>();
    // false false half expanded
    //false true expanded
    //true false collapsed
    if (!fullyCollapsed && !fullyExpanded) {
      // provider.type = ExpandType.HALF_EXPANDED;
      if (widget.valueNotifierExpandType?.value != ExpandType.HALF_EXPANDED) {
        debugPrint("DraggableHome notifying ${ExpandType.HALF_EXPANDED}");
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          widget.valueNotifierExpandType?.value = ExpandType.HALF_EXPANDED;
        });
      }
    } else if (!fullyCollapsed && fullyExpanded) {
      // provider.type = ExpandType.EXPANDED;

      if (widget.valueNotifierExpandType?.value != ExpandType.EXPANDED) {
        debugPrint("DraggableHome notifying ${ExpandType.EXPANDED}");

        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          widget.valueNotifierExpandType?.value = ExpandType.EXPANDED;
        });
      }
      if (widget.valueNotifierExpandTypeOnExpandOny?.value !=
          ExpandType.EXPANDED) {
        debugPrint("DraggableHome notifying ${ExpandType.EXPANDED}");
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          widget.valueNotifierExpandTypeOnExpandOny?.value =
              ExpandType.EXPANDED;
        });
      }
    } else {
      // provider.type = ExpandType.CLOSED;

      if (widget.valueNotifierExpandType?.value != ExpandType.CLOSED) {
        debugPrint("DraggableHome notifying ${ExpandType.CLOSED}");
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          widget.valueNotifierExpandType?.value = ExpandType.CLOSED;
        });
      }
      if (widget.valueNotifierExpandTypeOnExpandOny?.value !=
          ExpandType.CLOSED) {
        debugPrint("DraggableHome notifying ${ExpandType.CLOSED}");
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          widget.valueNotifierExpandTypeOnExpandOny?.value = ExpandType.CLOSED;
        });
      }
    }
  }
}

// class DraggableHomeExpandProvider with ChangeNotifier {
//   ExpandType _type = ExpandType.HALF_EXPANDED;
//   ExpandType get type => _type;

//   set type(ExpandType value) {
//     _type = value;
//     notifyListeners();
//   }
// }
