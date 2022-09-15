import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/new_screens/home/components/ext_provider.dart';
import 'package:flutter_view_controller/theming/text_field_theming.dart';

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
              EdgeInsets.only(right: 40, top: 0, left: 40, bottom: 0),
          initiallyExpanded: true,
          leading: Badge(
            badgeContent: Text(getFilterableFieldsCountStringValue(
                    context, customFilterableField.field)
                .toString()),
            child: Icon(customFilterableField.icon),
            toAnimate: true,
            showBadge: getFilterableFieldsCountStringValue(
                    context, customFilterableField.field) >
                0,
            animationType: BadgeAnimationType.slide,
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
            .map((i) => ChoiceChip(
                label: Text(i.toString()),
                // avatar: item.getCardLeadingCircleAvatar(context),
                selected: isFilterableSelectedStringValue(
                    context, customFilterableField.field, i.toString()),
                onSelected: (v) {
                  if (v) {
                    if (customFilterableField.singleChoiceIfList ?? false) {
                      clearFilterableSelected(
                          context, customFilterableField.field);
                    }
                    addFilterableSelectedStringValue(
                        context, customFilterableField.field, i.toString());
                  } else {
                    removeFilterableSelectedStringValue(
                        context, customFilterableField.field, i.toString());
                  }
                }))
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
            .map((i) => ChoiceChip(
  
                label: Text(v.getFieldLabelString(context, i)),
                // avatar: item.getCardLeadingCircleAvatar(context),
                selected: isFilterableSelectedStringValue(
                    context, customFilterableField.field, i.toString()),
                onSelected: (v) {
                  if (v) {
                    if (customFilterableField.singleChoiceIfList ?? false) {
                      clearFilterableSelected(
                          context, customFilterableField.field);
                    }
                    addFilterableSelectedStringValue(
                        context, customFilterableField.field, i.toString());
                  } else {
                    removeFilterableSelectedStringValue(
                        context, customFilterableField.field, i.toString());
                  }
                }))
            .toList());
  }

  Widget buildItem(BuildContext context) {
    return getTextInputController(
        context, customFilterableField.theme, customFilterableField.field,
        keyboardType: customFilterableField.type, onFieldSubmitted: (v) {
      if (v == null) {
        clearFilterableSelected(context, customFilterableField.field);
      } else {
        addFilterableSelectedStringValue(
            context, customFilterableField.field, v);
      }
    });
  }
}
