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
  List<String> getFields() {
    return object.getFields();
  }

  @override
  State<BaseActionPage> createState() => _BaseActionPageState();
}

class _BaseActionPageState<T extends ViewAbstract>
    extends State<BaseActionPage<T>> with SingleTickerProviderStateMixin {
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
    tabs.addAll(widget.object.getTabs(context));
    _tabController = TabController(vsync: this, length: tabs.length);
  }

  SliverAppBar getSilverAppBar(BuildContext context, bool innerBoxIsScrolled) {
    return SliverAppBar(
        expandedHeight: 200.0,
        snap: true,
        title: widget.object.getHeaderText(context),
        centerTitle: true,
        forceElevated: innerBoxIsScrolled,
        flexibleSpace: getSilverAppBarBackground(context),
        actions: widget.getAppBarActionsView(context),
        bottom: TabBar(
          tabs: tabs,
          controller: _tabController,
        ));
  }

  FlexibleSpaceBar getSilverAppBarBackground(BuildContext context) {
    return FlexibleSpaceBar(
        title: Text(widget.object.getHeaderTextOnly(context)),
        background: Hero(
            tag: widget.object,
            child: widget.object.getCardLeadingImage(context)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: widget.getBottomNavigationBar(context),
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            getSilverAppBar(context, innerBoxIsScrolled),
          ],
          body: TabBarView(
            controller: _tabController,
            children: tabs.map((Tab tab) {
              final String label = tab.text!.toLowerCase();
              return MainBody(child: widget.getBodyActionView(context));
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
