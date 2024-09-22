import 'package:flutter/material.dart';
import 'package:flutter_view_controller/components/expansion_tile_custom_expand_to_card.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/home/components/ext_provider.dart';
import 'package:flutter_view_controller/providers/filterables/filterable_provider.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

class MasterFilterableController extends StatelessWidget {
  List<dynamic> list;
  ViewAbstract viewAbstract;
  MasterFilterableController(
      {super.key, required this.viewAbstract, required this.list});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ExpansionTile(
        childrenPadding: const EdgeInsets.all(kDefaultPadding / 2),
        backgroundColor: ElevationOverlay.overlayColor(context, 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        title: viewAbstract.getMainLabelText(context),
        leading: Selector<FilterableProvider, int>(
          selector: (p0, p1) =>
              p1.getCount(field: viewAbstract.getForeignKeyName()),
          builder: (context, value, child) {
            return badges.Badge(
              badgeStyle: badges.BadgeStyle(
                shape: badges.BadgeShape.circle,
                borderRadius: BorderRadius.circular(10),
                badgeColor: Theme.of(context).colorScheme.primary,
                elevation: 0,
              ),
              showBadge: value > 0,
              badgeAnimation: const badges.BadgeAnimation.scale(
                animationDuration: Duration(milliseconds: 200),
                toAnimate: true,
                disappearanceFadeAnimationDuration: Duration(milliseconds: 100),
              ),
              child: viewAbstract.getIcon(),
            );
          },
        ),
        children: [
          Wrap(
              runSpacing: 10,
              spacing: 10,
              direction: Axis.horizontal,
              children: list.map((i) => getListItem(context, i)).toList()),
        ],
      ),
    );
  }

  Widget getListItem(BuildContext context, ViewAbstract item) {
    return Selector<FilterableProvider, bool>(
      builder: (context, value, child) => ChoiceChip.elevated(
          pressElevation: 20,
          label: item.getMainHeaderText(context),
          // avatar: item.getCardLeadingCircleAvatar(context),
          avatar: null,
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
