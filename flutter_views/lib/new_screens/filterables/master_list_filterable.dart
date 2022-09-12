import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/lists/list_card_item.dart';
import 'package:flutter_view_controller/new_screens/lists/list_static_widget.dart';
import 'package:flutter_view_controller/screens/view/view_card_item.dart';

import '../home/components/empty_widget.dart';

class MasterFilterableController extends StatelessWidget {
  
  List<dynamic> list;
  ViewAbstract? viewAbstract;
  MasterFilterableController(
      {Key? key, required this.viewAbstract, required this.list})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ExpansionTile(
        title: viewAbstract!.getMainLabelText(context),
        children: [
          ListView.builder(
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (context, index) =>
              CheckboxListTile(value: value, onChanged: onChanged)
                  ListCardItem<ViewAbstract>(object: list[index])),
        ],
      ),
    );
  }
}
