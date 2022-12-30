import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/home/components/ext_provider.dart';


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
        toAnimate: true,
         showBadge: getFilterableFieldsCount(context, viewAbstract) > 0,
        animationType: BadgeAnimationType.slide,
        child: viewAbstract.getIcon(),
      ),
      children: [
        Wrap(
            runSpacing: 20,
            spacing: 10,
            direction: Axis.horizontal,
            children: list.map((i) => getListItem(context, i)).toList()),
      ],
    );
  }

  Widget getListItem(BuildContext context, ViewAbstract item) {
    return ChoiceChip(
      surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
        backgroundColor: Theme.of(context).colorScheme.background,
        shadowColor: Theme.of(context).colorScheme.shadow,
       selectedColor: Theme.of(context).colorScheme.primary,


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
