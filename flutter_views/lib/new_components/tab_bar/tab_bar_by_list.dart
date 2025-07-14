import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

///Controller tabs used context to AppLoclazation \
///this throw error if we init tabController in the initState
///So we initialize tab controller on the build
class TabBarByListWidget<T extends TabControllerHelper> extends StatefulWidget {
  List<T> tabs;
  TabBarByListWidget({super.key, required this.tabs});

  @override
  State<TabBarByListWidget> createState() => _TabBarWidgetState();
}

class _TabBarWidgetState<T extends TabControllerHelper>
    extends State<TabBarByListWidget<T>> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    _tabController = TabController(length: widget.tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Align(
        alignment: Alignment.centerLeft,
        child: TabBar(
            indicator: DotIndicator(
              color: Theme.of(context).colorScheme.primary,
              distanceFromCenter: 16,
              radius: 3,
              paintingStyle: PaintingStyle.fill,
            ),
            //   RectangularIndicator(
            // bottomLeftRadius: 100,
            // bottomRightRadius: 100,
            // topLeftRadius: 100,
            // topRightRadius: 100,
            // paintingStyle: PaintingStyle.stroke,

            isScrollable: true,
            // labelPadding: const EdgeInsets.only(
            //   left: 20,
            //   right: 20,
            // ),
            controller: _tabController,
            tabs: widget.tabs),
      ),
      Expanded(
        child: TabBarView(
            controller: _tabController,
            children: widget.tabs
                .where((e) => e.widget != null)
                .map((e) => e.widget!)
                .toList()),
      )
    ]);
  }
}
