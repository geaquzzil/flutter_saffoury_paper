import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';

///Controller tabs used context to AppLoclazation \
///this throw error if we init tabController in the initState
///So we initialize tab controller on the build
class TabBarByListWidget<T extends TabControllerHelper> extends StatefulWidget {
  List<T> tabs;
  TabBarByListWidget({Key? key, required this.tabs}) : super(key: key);

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
            isScrollable: true,
            labelPadding: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
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
