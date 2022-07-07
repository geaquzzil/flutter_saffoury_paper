import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

class ListStaticWidget extends StatefulWidget {
  List<ViewAbstract> list = [];
  Widget Function(ViewAbstract item)? listItembuilder;
  Widget emptyWidget;
  ListStaticWidget(
      {Key? key,
      required this.list,
      required this.emptyWidget,
       this.listItembuilder})
      : super(key: key);

  @override
  State<ListStaticWidget> createState() => _ListStaticWidgetState();
}

class _ListStaticWidgetState extends State<ListStaticWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.list.isEmpty
        ? widget.emptyWidget
        : buildList(widget.list, context);
  }

  Widget buildList(List<ViewAbstract> list, BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (context, index) {
          return widget.listItembuilder!(list[index]);
          // return data[index].getCardView(context);
        },
      ),
    );
  }
}
