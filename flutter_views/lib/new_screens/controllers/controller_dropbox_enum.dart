import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/new_screens/controllers/ext.dart';

import '../../new_components/text_bold.dart';

class DropdownEnumControllerListener<T extends ViewAbstractEnum>
    extends StatelessWidget {
  T viewAbstractEnum;
  void Function(T? object) onSelected;

  DropdownEnumControllerListener(
      {super.key, required this.viewAbstractEnum, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    debugPrint("DropdownEnumControllerListener soso");
    return FormBuilderDropdown(
      isExpanded: true,
      // dropdownColor: Colors.amber,
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
      onChanged: (obj) => onSelected(obj as T),
    );
  }
}
