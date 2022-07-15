import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/new_screens/edit/controllers/ext.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class EditControllerDropdown<T extends ViewAbstractEnum>
    extends StatelessWidget {
  T enumViewAbstract;
  ViewAbstract parent;
  String field;
  EditControllerDropdown(
      {Key? key,
      required this.parent,
      required this.enumViewAbstract,
      required this.field})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      FormBuilderDropdown(
        validator: parent.getTextInputValidatorCompose(context, field),
        name: parent.getTag(field),
        initialValue: parent.getFieldValue(field),
        decoration:
            getDecorationDropdown(context, parent, enumViewAbstract, field),
        hint: Text(enumViewAbstract.getMainLabelText(context)),
        items: getValues()
            .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(item == null
                      ? getEnterText(context)
                      : enumViewAbstract.getFieldLabelString(context, item)),
                ))
            .toList(),
      ),
      getSpace()
    ]);
  }

  String getEnterText(BuildContext context) {
    String? label = enumViewAbstract.getMainLabelText(context);
    return "${AppLocalizations.of(context)!.enter} $label";
  }

  List<dynamic> getValues() {
    List<dynamic> v = [];
    v.add(null);
    v.addAll(enumViewAbstract.getValues());

    return v;
  }
}
