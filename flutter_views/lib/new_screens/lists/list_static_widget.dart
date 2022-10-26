import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

class ListStaticWidget<T> extends StatelessWidget {
  List<T> list = [];
  Widget Function(T item)? listItembuilder;
  Widget emptyWidget;
  ListStaticWidget(
      {Key? key,
      required this.list,
      required this.emptyWidget,
      this.listItembuilder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return list.isEmpty ? emptyWidget : buildList(list, context);
  }

  Widget buildList(List<T> list, BuildContext context) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: ScrollController(),
      shrinkWrap: true,
      itemCount: list.length,
      itemBuilder: (context, index) {
        return listItembuilder!(list[index]);
        // return data[index].getCardView(context);
      },
    );
  }
}
