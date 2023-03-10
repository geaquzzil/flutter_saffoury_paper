import 'package:badges/badges.dart' as customBadges;
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/new_screens/home/components/ext_provider.dart';
import 'package:provider/provider.dart';

import '../../providers/filterables/filterable_provider.dart';
import '../edit/controllers/ext.dart';

class CustomFilterableController extends StatelessWidget {
  CustomFilterableField customFilterableField;

  CustomFilterableController({Key? key, required this.customFilterableField})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpansionTile(
          childrenPadding:
              const EdgeInsets.only(right: 40, top: 0, left: 40, bottom: 0),
          initiallyExpanded: false,
          leading: Selector<FilterableProvider, int>(
            selector: (p0, p1) => p1.getCount(customFilterableField.field),
            builder: (context, value, child) => Badge(
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
              child: Icon(customFilterableField.icon),
            ),
          ),
          title: Text(customFilterableField.title),
          children: [
            if (customFilterableField.object is List)
              buildList(context)
            else if (customFilterableField.object is ViewAbstractEnum)
              buildEnum(context)
            else
              buildItem(context)
          ],
        ),
      ],
    );
  }

  Widget buildList(BuildContext context) {
    List<dynamic> v = (customFilterableField.object as List<dynamic>);
    return Wrap(
        runSpacing: 20,
        spacing: 10,
        direction: Axis.horizontal,
        children: v
            .map((i) => Selector<FilterableProvider, bool>(
                  builder: (context, value, child) => ChoiceChip(
                      label: Text(i.toString()),
                      // avatar: item.getCardLeadingCircleAvatar(context),
                      selected: value,
                      onSelected: (v) {
                        if (v) {
                          if (customFilterableField.singleChoiceIfList ??
                              false) {
                            clearFilterableSelected(
                                context, customFilterableField.field);
                          }
                          addFilterableSelectedStringValue(
                              context,
                              customFilterableField.field,
                              i.toString(),
                              customFilterableField.title,
                              i.toString());
                        } else {
                          removeFilterableSelectedStringValue(
                              context,
                              customFilterableField.field,
                              i.toString(),
                              i.toString());
                        }
                      }),
                  selector: (p0, p1) =>
                      p1.isSelected(customFilterableField.field, i.toString()),
                ))
            .toList());
  }

  Widget buildEnum(BuildContext context) {
    ViewAbstractEnum v = (customFilterableField.object as ViewAbstractEnum);
    return Wrap(
        runSpacing: 20,
        spacing: 10,
        direction: Axis.horizontal,
        children: v
            .getValues()
            .map((i) => Selector<FilterableProvider, bool>(
                  builder: (context, value, child) => ChoiceChip(
                      label: Text(v.getFieldLabelString(context, i)),
                      // avatar: item.getCardLeadingCircleAvatar(context),
                      selected: value,
                      onSelected: (v) {
                        if (v) {
                          if (customFilterableField.singleChoiceIfList ??
                              false) {
                            clearFilterableSelected(
                                context, customFilterableField.field);
                          }
                          addFilterableSelectedStringValue(
                              context,
                              customFilterableField.field,
                              i.toString(),
                              customFilterableField.title,
                              i);
                        } else {
                          removeFilterableSelectedStringValue(
                              context,
                              customFilterableField.field,
                              i.toString(),
                              i.toString());
                        }
                      }),
                  selector: (p0, p1) =>
                      p1.isSelected(customFilterableField.field, i.toString()),
                ))
            .toList());
  }

  Widget buildItem(BuildContext context) {
    return getTextInputController(
        context, customFilterableField.theme, customFilterableField.field,
        keyboardType: customFilterableField.type, onFieldSubmitted: (v) {
      if (v == null) {
        clearFilterableSelected(context, customFilterableField.field);
      } else {
        addFilterableSelectedStringValue(context, customFilterableField.field,
            v, customFilterableField.title, v);
      }
    });
  }
}
