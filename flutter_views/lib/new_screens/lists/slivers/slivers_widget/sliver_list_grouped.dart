// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/interfaces/dashable_interface.dart';
import 'package:flutter_view_controller/new_screens/actions/dashboard/base_dashboard_screen_page.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/slivers_widget/sliver_custom_scroll_widget.dart';

class StickyItem {
  String title;
  List<Widget> widgets;
  StickyItem({
    required this.title,
    required this.widgets,
  });
}

List<Widget> getListStickyWidget(BuildContext context,List<StickyItem> list) {
  return list.map(
    (e) {
      GlobalKey buttonKey = GlobalKey();
      return SectionItemHeaderI(
        context: context,
        title: Text(e.title),
        buttonKey: buttonKey,
        child: Wrap(
          children: e.widgets,
        ),
      );
    },
  ).toList();
}

@Deprecated("i dont want to use this")
class SliverListGrouped extends StatefulWidget {
  List<StickyItem> list;
  SliverListGrouped({super.key, required this.list});

  @override
  State<SliverListGrouped> createState() => _SliverListGroupedState();
}

class _SliverListGroupedState extends State<SliverListGrouped> {
  @override
  Widget build(BuildContext context) {
    return SliverCustomScrollView(
        slivers: widget.list.map(
      (e) {
        GlobalKey buttonKey = GlobalKey();
        return SectionItemHeaderI(
          context: context,
          title: Text(e.title),
          buttonKey: buttonKey,
          child: Wrap(
            children: e.widgets,
          ),
        );
      },
    ).toList());
  }
}
