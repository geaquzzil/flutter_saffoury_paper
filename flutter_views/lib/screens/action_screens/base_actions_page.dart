import 'package:flutter/material.dart';
import 'package:flutter_view_controller/components/main_body.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/new_components/rounded_icon_button.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

abstract class BaseActionPage<T extends ViewAbstract> extends StatefulWidget {
  Widget? getBottomNavigationBar(BuildContext context);

  Widget? getBodyActionView(BuildContext context);

  List<Widget>? getAppBarActionsView(BuildContext context);
  T object;
  BaseActionPage({super.key, required this.object});
  List<String> getFields(BuildContext context) {
    return object.getMainFields(context: context);
  }

  @override
  State<BaseActionPage> createState() => _BaseActionPageState();
}

class _BaseActionPageState<T extends ViewAbstract>
    extends State<BaseActionPage<T>> with TickerProviderStateMixin {
  late TabController _tabController;
  List<Tab> tabs = <Tab>[];
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    tabs.addAll([TabControllerHelper("TITLE"), TabControllerHelper("LIST")]);
    _tabController = TabController(vsync: this, length: tabs.length);
  }

  SliverAppBar getSilverAppBar(BuildContext context, bool innerBoxIsScrolled) {
    return SliverAppBar(
        floating: true,
        expandedHeight: 200.0,
        snap: true,
        stretchTriggerOffset: 150,
        // title: widget.object.getMainHeaderText(context),
        // centerTitle: true,
        forceElevated: innerBoxIsScrolled,
        flexibleSpace: getSilverAppBarBackground(context),
        // actions: widget.getAppBarActionsView(context),
        bottom: TabBar(
          tabs: tabs,
          controller: _tabController,
        ));
  }

  FlexibleSpaceBar getSilverAppBarBackground(BuildContext context) {
    return FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.blurBackground,
          StretchMode.zoomBackground,
          StretchMode.fadeTitle
        ],
        title: Text(widget.object.getMainHeaderTextOnly(context)),
        background: Hero(
            tag: widget.object,
            child: widget.object.getCardLeadingImage(context)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: widget.getBottomNavigationBar(context),
        body: NestedScrollView(
          floatHeaderSlivers: false,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            getSilverAppBar(context, innerBoxIsScrolled),
          ],
          body: // widget.getBodyActionView(context) ??
              TabBarView(
            controller: _tabController,
            children: tabs.map((Tab tab) {
              final String label = tab.text!.toLowerCase();
              return MainBody(child: Text(label));
              // final String label = tab.text!.toLowerCase();
              // return Center(
              //   child: Text(
              //     'This is the $label tab',
              //     style: const TextStyle(fontSize: 36),
              //   ),
              // );
            }).toList(),
          ),
        ));
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
}
