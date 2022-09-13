import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/new_components/lists/list_card_item.dart';
import 'package:flutter_view_controller/new_screens/home/components/ext_provider.dart';
import 'package:flutter_view_controller/new_screens/lists/list_static_widget.dart';
import 'package:flutter_view_controller/screens/view/view_card_item.dart';

import '../home/components/empty_widget.dart';

class MasterFilterableController extends StatelessWidget {
  List<dynamic> list;
  ViewAbstract viewAbstract;
  MasterFilterableController(
      {Key? key, required this.viewAbstract, required this.list})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: viewAbstract.getMainLabelText(context),
      leading: Badge(
        badgeContent:
            Text(getFilterableFieldsCount(context, viewAbstract).toString()),
        child: viewAbstract.getIcon(),
        toAnimate: true,
         showBadge: getFilterableFieldsCount(context, viewAbstract) > 0,
        animationType: BadgeAnimationType.slide,
      ),
      children: [
        Wrap(
            runSpacing: 20,
            spacing: 10,
            direction: Axis.horizontal,
            children: list.map((i) => getListItem(context, i)).toList()),

        // [
        //   ListView.builder(
        //       itemCount: list.length,
        //       itemBuilder: (context, index) => getListItem(context, list[index])

        //       // CheckboxListTile(
        //       //     secondary: (list[index] as ViewAbstract)
        //       //         .getCardLeadingCircleAvatar(context),
        //       //     title:
        //       //         (list[index] as ViewAbstract).getMainHeaderText(context),
        //       //     value: isFilterableSelected(context, list[index]),
        //       //     onChanged: (value) {
        //       //       if (value ?? false) {
        //       //         addFilterableSelected(context, list[index]);
        //       //       } else {
        //       //         removeFilterableSelected(context, list[index]);
        //       //       }
        //       //     })

        //       ),
        // ]
      ],
    );
  }

  Widget getListItem(BuildContext context, ViewAbstract item) {
    return ChoiceChip(
        selectedColor: Colors.green,
        label: item.getMainHeaderText(context),
        avatar: item.getCardLeadingCircleAvatar(context),
        selected: isFilterableSelected(context, item),
        onSelected: (v) {
          if (v) {
            addFilterableSelected(context, item);
          } else {
            removeFilterableSelected(context, item);
          }
        });
  }
}
