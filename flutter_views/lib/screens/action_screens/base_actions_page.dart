import 'package:flutter/material.dart';
import 'package:flutter_view_controller/components/main_body.dart';
import 'package:flutter_view_controller/components/rounded_icon_button.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

abstract class BaseActionPage<T extends ViewAbstract> extends StatefulWidget {
  Widget? getBottomNavigationBar(BuildContext context);

  Widget? getBodyActionView(BuildContext context);

  List<Widget>? getAppBarActionsView(BuildContext context);
  T object;
  BaseActionPage({Key? key, required this.object}) : super(key: key);

  @override
  State<BaseActionPage> createState() => _BaseActionPageState();
}

class _BaseActionPageState<T extends ViewAbstract>
    extends State<BaseActionPage<T>> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Tab> myTabs = <Tab>[
    Tab(text: 'LEFT'),
    Tab(text: 'RIGHT'),
  ];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
  }
  Widget getBody(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverAppBar(
                      floating: true,
                      expandedHeight: 200.0,
                      snap: true,
                      title: widget.object.getHeaderText(context),
                      centerTitle: true,
                      forceElevated: innerBoxIsScrolled,
                      flexibleSpace: FlexibleSpaceBar(
                          title: Text(widget.object.getHeaderTextOnly(context)),
                          background: Hero(
                              tag: widget.object,
                              child:
                                  widget.object.getCardLeadingImage(context))),
                      actions: getAppBarActionsView(context),
                      bottom: getTabBar(context)),
                ],
            body: getBodyActionView(context)!));

    CustomScrollView(slivers: [
      SliverAppBar(
          pinned: true,
          snap: true,
          floating: true,
          expandedHeight: 200.0,
          flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.object.getHeaderTextOnly(context)),
              background: Hero(
                  tag: widget.object,
                  child: widget.object.getCardLeadingImage(context))),
          actions: getAppBarActionsView(context)),
      const SliverToBoxAdapter(
        child: SizedBox(
          height: 20,
          child: Center(
            child: Text('Scroll to see the SliverAppBar in effect.'),
          ),
        ),
      ),
      // SliverList(
      //   delegate: SliverChildBuilderDelegate(
      //     (BuildContext context, int index) {
      //       return Container(
      //         color: index.isOdd ? Colors.white : Colors.black12,
      //         height: 100.0,
      //         child: Center(
      //           child: Text('$index', textScaleFactor: 5),
      //         ),
      //       );
      //     },
      //     childCount: 20,
      //   ),
      // ),
      // getBodyActionView(context)!
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        bottomNavigationBar: getBottomNavigationBar(context),
        body: getBody(context));
  }

  Row getTitle(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding,
          ),
          child: RoundedIconButton(
            onTap: () {
              Navigator.pop(context);
            },
            icon: Icons.arrow_back,
          ),
        ),
      ],
    );
  }

  List<String> getFields() {
    return widget.object.getFields();
  }

  TabBar getTabBar(BuildContext context) {
    return TabBar(tabs: [
      Tab(
        text: 'Tab 1',
      ),
      Tab(
        text: 'Tab 2',
      ),
      Tab(
        text: 'Tab 3',
      ),
    ]);
  }
}
