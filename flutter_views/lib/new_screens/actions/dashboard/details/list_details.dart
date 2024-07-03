import 'package:flutter/cupertino.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/lists/list_card_item.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/components/chart_card_item_custom.dart';
import 'package:flutter_view_controller/new_screens/home/base_home_shared_with_widget.dart';

class DashboardListDetails extends BaseHomeSharedWithWidgets {
  List<ViewAbstract> list;
  ChartCardItemCustom header;
  DashboardListDetails(
      {super.key,
      required this.list,
      required this.header,
      super.wrapWithScaffold = true});

  @override
  Widget? getEndPane(BuildContext context) {
    return null;
  }

  @override
  Widget? getSilverAppBarTitle(BuildContext context) {
    return Text(list[0].getMainHeaderLabelTextOnly(context));
  }

  @override
  List<Widget>? getSliverAppBarActions(BuildContext context) {
    return null;
  }

  @override
  Widget? getSliverHeader(BuildContext context) {
    return header;
  }

  @override
  List<Widget> getSliverList(BuildContext context) {
    return [
      SliverList(
          delegate: SliverChildBuilderDelegate(
              (context, index) => ListCardItem(object: list[index]),
              childCount: list.length))
    ];
  }

  @override
  EdgeInsets? hasBodyPadding(BuildContext context) {
    return null;
  }

  @override
  EdgeInsets? hasMainBodyPadding(BuildContext context) {
    return null;
  }

  @override
  void init(BuildContext context) {
    // TODO: implement init
  }
}
