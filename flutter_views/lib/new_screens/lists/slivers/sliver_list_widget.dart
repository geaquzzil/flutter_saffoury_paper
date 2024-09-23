import 'package:flutter/material.dart';
import 'package:flutter_view_controller/configrations.dart';
import 'package:flutter_view_controller/customs_widget/color_tabbar.dart';
import 'package:flutter_view_controller/customs_widget/sliver_delegates.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/streams.dart';

class SliverCustomScrollView extends StatefulWidget {
  List<Widget> slivers;
  ScrollController? scrollController;
  List<Widget> Function(ScrollController)? builder;
  String? scrollKey;
  ScrollPhysics? physics;

  //this works with one object only todo cant retrun full List
  Widget Function(bool fullyCol, bool fullyExp)? builderAppbar;
  SliverCustomScrollView(
      {super.key,
      required this.slivers,
      this.scrollController,
      this.builder,
      this.builderAppbar,
      this.physics,
      this.scrollKey});

  @override
  State<SliverCustomScrollView> createState() =>
      _SliverCustomScrollViewDraggableState();
}

class _SliverCustomScrollViewDraggableState
    extends State<SliverCustomScrollView> {
  late final _scrollController;
  late String bucketOffsetKey;

  final BehaviorSubject<bool> isFullyExpanded =
      BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<bool> isFullyCollapsed =
      BehaviorSubject<bool>.seeded(false);

  late double expandedHeight;

  static const double headerExpandedHeight = .7;
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
  void didUpdateWidget(covariant SliverCustomScrollView oldWidget) {
    bucketOffsetKey = widget.scrollKey ?? "scrollKey";
    debugPrint("didUpdateWidget draggable $bucketOffsetKey");
    WidgetsBinding.instance.addPostFrameCallback((c) {
      if (mounted) {
        double lastSavedScroll =
            Configurations.currentPageScrollOffset(context, bucketOffsetKey);
        if (lastSavedScroll != 0) {
          _scrollTo(lastSavedScroll);
        } else {
          _scrollTop();
        }
      }
    });
    super.didUpdateWidget(oldWidget);
  }

  bool canExpandBody() {
    return isMobile(context);
  }

  @override
  Widget build(BuildContext context) {
    expandedHeight = canExpandBody()
        ? MediaQuery.of(context).size.height * headerExpandedHeight
        : 0;

    return PageStorage(
      bucket: appBucket,
      child: getNotificationListener(),
    );
  }

  Widget sliver() {
    return SafeArea(
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
                builder:
                    (BuildContext context, AsyncSnapshot<List<bool>> snapshot) {
                  final List<bool> streams = (snapshot.data ?? [false, false]);
                  final bool fullyCollapsed = streams[0];
                  final bool fullyExpanded = streams[1];
                  return widget.builderAppbar!
                      .call(fullyCollapsed, fullyExpanded);
                },
              ),
            if (widget.builder != null)
              ...widget.builder!.call(_scrollController)
            else
              ...widget.slivers
          ]),
    );
  }

  NotificationListener<ScrollNotification> getNotificationListener() {
    return NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollEndNotification &&
              notification.metrics.axis == Axis.vertical) {
            Configurations.saveScrollOffset(
                context, notification.metrics.pixels, bucketOffsetKey);
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
        child: sliver());
  }

  void _scrollDown() {
    if (_scrollController == null) return;
    if (_scrollController?.hasClients == false) return;
    _scrollController?.animateTo(
      _scrollController!.position.maxScrollExtent,
      duration: const Duration(milliseconds: 400),
      curve: Curves.fastOutSlowIn,
    );
  }

  void _scrollTo(double pos) {
    debugPrint("scrollTo pos===> $pos");
    if (_scrollController == null) return;
    if (_scrollController?.hasClients == false) return;
    _scrollController?.animateTo(
      pos,
      duration: const Duration(milliseconds: 700),
      curve: Curves.fastOutSlowIn,
    );
  }

  void _scrollToHideTopWidget() {
    debugPrint("_scrollToHideTopWidget ===> top");
    if (_scrollController == null) return;
    if (_scrollController?.hasClients == false) return;
    _scrollController?.animateTo(
      _scrollController!.position.minScrollExtent,
      duration: const Duration(milliseconds: 700),
      curve: Curves.fastOutSlowIn,
    );
  }

  void _scrollTop() {
    debugPrint("scrollTo ===> top");
    if (_scrollController == null) return;
    if (_scrollController?.hasClients == false) return;
    _scrollController?.animateTo(
      _scrollController!.position.minScrollExtent,
      duration: const Duration(milliseconds: 700),
      curve: Curves.fastOutSlowIn,
    );
  }

  void _scrollToCollapsed() {
    if (_scrollController == null) return;
    if (_scrollController?.hasClients == false) return;
    _scrollController?.jumpTo(500);
  }
}
