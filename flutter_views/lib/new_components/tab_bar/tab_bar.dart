import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';

///Controller tabs used context to AppLoclazation \
///this throw error if we init tabController in the initState
///So we initialize tab controller on the build
class TabBarWidget extends StatefulWidget {
  ViewAbstract viewAbstract;
  TabBarWidget({super.key, required this.viewAbstract});

  @override
  State<TabBarWidget> createState() => _TabBarWidgetState();
}

class _TabBarWidgetState extends State<TabBarWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final List<TabControllerHelper> _tabs = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  void didUpdateWidget(covariant TabBarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    debugPrint("didUpdateWidget tabController");
    _tabs.clear();
    _tabs.addAll(widget.viewAbstract.getTabs(context));
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   debugPrint("didChangeDependencies tabController");
  //   _tabs.clear();
  //   _tabs.addAll(widget.viewAbstract.getTabs(context));
  // }

  @override
  Widget build(BuildContext context) {
    _tabs.clear();
    _tabs.addAll(widget.viewAbstract.getTabs(context));
    _tabController = TabController(length: _tabs.length, vsync: this);
    return Column(children: [
      Align(
        alignment: Alignment.centerLeft,
        child: TabBar(
            isScrollable: true,
            // indicator: BoxDecoration(
            //     borderRadius: BorderRadius.circular(50),
            //     color: Theme.of(context)
            //         .colorScheme
            //         .secondary), // Creates border
            // color: Theme.of(context).colorScheme.),
            // indicator: CircleTabIndicator(color: Colors.black12, radius: 4),
            labelPadding: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            // labelColor: Colors.black,
            // unselectedLabelColor: Colors.grey,
            controller: _tabController,
            tabs: _tabs),
      ),
      Expanded(
        child: TabBarView(
          controller: _tabController,
          children:
              widget.viewAbstract.getTabsViewGenerator(context, tabs: _tabs),
        ),
      )
    ]);
  }
}

class CircleTabIndicator extends Decoration {
  final Color color;
  double radius;

  CircleTabIndicator({required this.color, required this.radius});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CirclePainter(color: color, radius: radius);
  }
}

class _CirclePainter extends BoxPainter {
  final double radius;
  late Color color;
  _CirclePainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    late Paint paint;
    paint = Paint()..color = color;
    paint = paint..isAntiAlias = true;
    final Offset circleOffset =
        offset + Offset(cfg.size!.width / 2, cfg.size!.height - radius);
    canvas.drawCircle(circleOffset, radius, paint);
  }
}
