// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/models/apis/date_object.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/new_components/text_bold.dart';
import 'package:flutter_view_controller/new_screens/controllers/ext.dart';

class DropdownDateControllerListener extends StatelessWidget {
  final DateEnum viewAbstractEnum;
  final void Function(DateEnum? object) onSelected;
  final void Function(DateObject? dateObject)? onSelectedDateObject;

  const DropdownDateControllerListener(
      {super.key,
      required this.viewAbstractEnum,
      required this.onSelected,
      this.onSelectedDateObject});

  @override
  Widget build(BuildContext context) {
    return FormBuilderDropdown(
      isExpanded: true,
      name: viewAbstractEnum.getMainLabelText(context),
      initialValue: viewAbstractEnum,
      // decoration: getDecoration(context, viewAbstract)
      // hint: TextBold(
      //   text: dropdownGettLabelWithText(context, viewAbstractEnum),
      //   regex: viewAbstractEnum.getFieldLabelString(context, viewAbstractEnum),
      // ),
      // decoration: getDecorationDropdownNewWithLabelAndValue(context,
      //     viewAbstractEnum: viewAbstractEnum),
      items: dropdownGetValues(viewAbstractEnum)
          .map((item) => DropdownMenuItem(
                value: item,
                child: item != null
                    ? TextBold(
                        text: dropdownGettLabelWithText(context, item),
                        regex: (item as ViewAbstractEnum)
                            .getFieldLabelString(context, item),
                      )
                    : Text(
                        item == null
                            ? dropdownGetEnterText(context, viewAbstractEnum)
                            : viewAbstractEnum.getFieldLabelString(
                                context, item),
                        overflow: TextOverflow.ellipsis,
                      ),
              ))
          .toList(),
      onChanged: (obj) {
        onSelected(obj as DateEnum?);
        if (onSelectedDateObject != null) {
          onSelectedDateObject!(getDateFromEnum(obj));
        }
      },
    );
  }

  DateObject? getDateFromEnum(DateEnum? obj) {
    if (obj == null) return null;
    switch (obj) {
      case DateEnum.this_day:
        return DateObject();

      case DateEnum.this_month:
        return DateObject.initThisMonth();
      case DateEnum.this_year:
        return DateObject.initFirstDateOfYear();
      case DateEnum.this_week:
        return DateObject.initThisWeek();
      case DateEnum.custom:
        return null; //TODO show Dialog
    }
  }
}

enum DateEnum implements ViewAbstractEnum<DateEnum> {
  this_year,
  this_month,
  this_week,
  this_day,
  custom;

  @override
  IconData getMainIconData() {
    return Icons.date_range;
  }

  @override
  String getMainLabelText(BuildContext context) {
    return AppLocalizations.of(context)!.enteryInterval;
  }

  @override
  String getFieldLabelString(BuildContext context, DateEnum field) {
    switch (field) {
      case DateEnum.this_year:
        return AppLocalizations.of(context)!.thisYear;
      case DateEnum.this_month:
        return AppLocalizations.of(context)!.thisMonth;
      case DateEnum.this_week:
        return "TODO This week";
      case DateEnum.this_day:
        return AppLocalizations.of(context)!.this_day;
      case DateEnum.custom:
        return AppLocalizations.of(context)!.customDate;
    }
  }

  @override
  IconData getFieldLabelIconData(BuildContext context, DateEnum field) {
    return Icons.date_range;
  }

  @override
  List<DateEnum> getValues() {
    return DateEnum.values;
  }
}
