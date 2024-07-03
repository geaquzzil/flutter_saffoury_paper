import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/home/components/ext_provider.dart';
import 'package:flutter_view_controller/providers/filterables/filterable_provider.dart';
import 'package:provider/provider.dart';

class MasterFilterableController extends StatelessWidget {
  List<dynamic> list;
  ViewAbstract viewAbstract;
  MasterFilterableController(
      {super.key, required this.viewAbstract, required this.list});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: viewAbstract.getMainLabelText(context),
      leading: Selector<FilterableProvider, int>(
        selector: (p0, p1) => p1.getCount(field:viewAbstract.getForeignKeyName()),
        builder: (context, value, child) => Badge(
          smallSize: 4,
          isLabelVisible: value > 0,
          label: Text(
            "$value",
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: Theme.of(context).colorScheme.onPrimary),
          ),
          // badgeColor: Theme.of(context).colorScheme.primary,
          // badgeContent: Text(
          //   "$value",
          //   style: Theme.of(context)
          //       .textTheme
          //       .titleSmall!
          //       .copyWith(color: Theme.of(context).colorScheme.onPrimary),
          // ),
          // toAnimate: true,
          // showBadge: value > 0,
          // animationType: BadgeAnimationType.slide,
          child: viewAbstract.getIcon(),
        ),
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
    return Selector<FilterableProvider, bool>(
      builder: (context, value, child) => ChoiceChip(
          // surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
          // backgroundColor: Theme.of(context).colorScheme.background,
          // shadowColor: Theme.of(context).colorScheme.shadow,
          // selectedColor: Theme.of(context).colorScheme.primary,
          label: item.getMainHeaderText(context),
          avatar: item.getCardLeadingCircleAvatar(context),
          selected: value,
          onSelected: (v) {
            if (v) {
              addFilterableSelected(context, item);
            } else {
              removeFilterableSelected(context, item);
            }
          }),
      selector: (p0, p1) =>
          p1.isSelected(item.getForeignKeyName(), item.getIDString()),
    );
  }
}
