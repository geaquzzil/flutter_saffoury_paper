import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/lists/list_card_item.dart';

class ListStaticWidget<T> extends StatelessWidget {
  List<T> list = [];
  Widget Function(T item)? listItembuilder;
  Widget emptyWidget;
  ListStaticWidget(
      {super.key,
      required this.list,
      required this.emptyWidget,
      this.listItembuilder});

  @override
  Widget build(BuildContext context) {
    return list.isEmpty
        ? Expanded(child: emptyWidget)
        : buildList(list, context);
  }

  Widget buildList(List<T> list, BuildContext context) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: ScrollController(),
      shrinkWrap: true,
      itemCount: list.length,
      itemBuilder: (context, index) {
        if (listItembuilder == null) {
          return ListCardItem(object: list[index] as ViewAbstract);
        }
        return listItembuilder!(list[index]);
        // return data[index].getCardView(context);
      },
    );
  }
}
