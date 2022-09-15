import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/providers/actions/edits/edit_error_list_provider.dart';
import 'package:flutter_view_controller/providers/actions/edits/sub_edit_viewabstract_provider.dart';
import 'package:flutter_view_controller/theming/text_field_theming.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

List<dynamic> dropdownGetValues(ViewAbstractEnum enumViewAbstract) {
  List<dynamic> v = [];
  v.add(null);
  v.addAll(enumViewAbstract.getValues());
  return v;
}

Enum getEnum(ViewAbstractEnum enumViewAbstract) {
  return enumViewAbstract as Enum;
}

String dropdownGetEnterText(
    BuildContext context, ViewAbstractEnum enumViewAbstract) {
  String? label = enumViewAbstract.getMainLabelText(context);
  return "${AppLocalizations.of(context)!.enter} $label";
}

String dropdownGettLabelWithText(
    BuildContext context, ViewAbstractEnum viewAbstractEnum) {
  return "${viewAbstractEnum.getMainLabelText(context)}:${viewAbstractEnum.getFieldLabelString(context, viewAbstractEnum)}";
}

InputDecoration getDecorationDropdownNewWithLabelAndValue(BuildContext context,
    {ViewAbstractEnum? viewAbstractEnum}) {
  return const InputDecoration(
    fillColor: Colors.white,
    focusColor: Colors.white,

    filled: true,
    border: OutlineInputBorder(),
    // label: TextBold(
    //   text: dropdownGettLabelWithText(context, viewAbstractEnum),
    //   regex: viewAbstractEnum.getFieldLabelString(context, viewAbstractEnum),
    // ));
    // hintText: parent.getTextInputHint(context, field));
  );
}

InputDecoration getDecorationDropdown(BuildContext context, ViewAbstract parent,
    ViewAbstractEnum viewAbstractEnum, String field) {
  return InputDecoration(
      // filled: true,
      border: const OutlineInputBorder(),
      icon: Icon(viewAbstractEnum.getMainIconData()),
      labelText: viewAbstractEnum.getMainLabelText(context));
  // hintText: parent.getTextInputHint(context, field));
}

InputDecoration getDecorationTheming(
    BuildContext context, TextFieldTheming theme) {
  return InputDecoration(
      border: theme.inputBorder,
      filled: true,
      // errorText: "err",
      icon: Icon(theme.icon),
      hintText: theme.hintText,
      labelText: theme.lableText,
      prefixText: theme.prefix,
      suffixText: theme.suffix);
}

InputDecoration getDecoration(
    BuildContext context, ViewAbstract viewAbstract, String field) {
  return InputDecoration(
      border: const UnderlineInputBorder(),
      filled: true,
      // errorText: "err",
      icon: viewAbstract.getTextInputIcon(field),
      iconColor: context
              .watch<ErrorFieldsProvider>()
              .hasErrorField(viewAbstract, field)
          ? Colors.red
          : null,
      hintText: viewAbstract.getTextInputHint(context, field),
      labelText: viewAbstract.getTextInputLabel(context, field),
      prefixText: viewAbstract.getTextInputPrefix(context, field),
      suffixText: viewAbstract.getTextInputSuffix(context, field));
}

Widget getSpace() {
  return const SizedBox(height: 24.0);
}

bool isEnabled(BuildContext context, ViewAbstract viewAbstract) {
  //if this is the main viewabstract then we should enabled the text field
  debugPrint("isEnabled checking canSubmitChanges");
  if (!canSubmitChanges(viewAbstract)) return true;
  bool res = context
      .watch<EditSubsViewAbstractControllerProvider>()
      .getIsNew(viewAbstract.getFieldNameFromParent ?? "");
  debugPrint("isEnabled checking isNew=>$res");
  return res;
}

bool canSubmitChanges(ViewAbstract viewAbstract) =>
    (viewAbstract.getParnet) != null;

ViewAbstract copyWithSetNew(
    ViewAbstract oldViewAbstract, String field, dynamic value) {
  ViewAbstract newObject = oldViewAbstract.copyWithSetNew(field, value);
  return newObject;
}

dynamic getFieldValue(
    BuildContext context, String? parentField, String currentField) {
  dynamic value =
      getViewAbstract(context, parentField)?.getFieldValue(currentField);
  return value ?? "";
}

dynamic getFieldValueForTextField(
    BuildContext context, String? parentField, String currentField) {
  return getFieldValue(context, parentField, currentField).toString();
}

String getFieldNameFromParent(ViewAbstract viewAbstract) {
  return viewAbstract.getFieldNameFromParent ?? "";
}

ViewAbstract? getViewAbstract(BuildContext context, String? field) {
  return context
      .watch<EditSubsViewAbstractControllerProvider>()
      .getViewAbstract(field ?? "");
}

ViewAbstract getViewAbstractReturnSameIfNull(
    BuildContext context, ViewAbstract viewAbstract, String? field) {
  return getViewAbstract(context, field) ?? viewAbstract;
}

bool getIsNullable(BuildContext context, String? field) {
  return context
      .watch<EditSubsViewAbstractControllerProvider>()
      .getIsNullable(field ?? "");
}

ViewAbstract onChange(BuildContext context, ViewAbstract oldViewAbstract,
    String field, dynamic value) {
  debugPrint("isChanged to $value");
  if (canSubmitChanges(oldViewAbstract)) {
    debugPrint("isChanged can submit changes to $value");
    return toggleIsNew(context, oldViewAbstract, field, value);
  }
  return oldViewAbstract;
}

EditSubsViewAbstractControllerProvider getViewAbstractControllerProvider(
    BuildContext context) {
  return context.watch<EditSubsViewAbstractControllerProvider>();
}

ErrorFieldsProvider getErrorFieldProvider(BuildContext context) {
  return context.watch<ErrorFieldsProvider>();
}

ViewAbstract toggleIsNew(BuildContext context, ViewAbstract oldViewAbstract,
    String field, dynamic value) {
  ViewAbstract newObject = copyWithSetNew(oldViewAbstract, field, value);
  context
      .read<EditSubsViewAbstractControllerProvider>()
      .toggleIsNew(newObject.getFieldNameFromParent ?? "", newObject, field);
  return newObject;
}

bool isEnabledField(EditSubsViewAbstractControllerProvider editSubsView,
    ViewAbstract viewAbstract) {
  if (viewAbstract.getTextInputIsAutoCompleteViewAbstractMap().isEmpty) {
    return true;
  }
  //if this is the main viewabstract then we should enabled the text field
  debugPrint("isEnabled checking canSubmitChanges");
  if (!canSubmitChanges(viewAbstract)) return true;
  bool res = editSubsView.getIsNew(viewAbstract.getFieldNameFromParent ?? "");
  debugPrint("isEnabled checking isNew=>$res");
  return res;
}

Widget getTextInputController(
    BuildContext context, TextFieldTheming theme, String initialValue,
    {Function(String?)? onFieldSubmitted,
    TextInputAction? textInputAction,
    TextInputType? keyboardType}) {
  return TextFormField(
      //  cursorColor: Theme.of(context).cursorColor,
      decoration: getDecorationTheming(context, theme),
      initialValue: initialValue,
      onSaved: (newValue) => debugPrint("getTextInputController onSaved"),
      maxLength: 20,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      onFieldSubmitted: onFieldSubmitted);
}

// Widget getTextInputMultibleController(
//     BuildContext context, String initialValue, Function(String)? onChange) {
//   return FormBuilderChipsInput<String>(
//     autovalidateMode: AutovalidateMode.onUserInteraction,
//     decoration: const InputDecoration(
//         labelText: 'Ok, if I had to choose one language, it would be:'),
//     name: 'languages_choice',

//     onChanged: (string) => debugPrint("getTextInputController onChanged"),
//   );
  // return FormBuilderChipsInput(
  //   name: "test",
  //   //  cursorColor: Theme.of(context).cursorColor,
  //   onSaved: (newValue) => debugPrint("getTextInputController onSaved"),
  //   onChanged: (string) => debugPrint("getTextInputController onChanged"),
  //   chipBuilder:
  //       (BuildContext context, ChipsInputState<Object?> state, Object? data) {},
  // );
// }


  //  FormBuilderChipsInput<Contact>(
  //                 decoration: const InputDecoration(labelText: 'Chips Input'),
  //                 name: 'chips_test',
  //                 onChanged: _onChanged,
  //                 maxChips: 5,
  //                 findSuggestions: (String query) {
  //                   if (query.isNotEmpty) {
  //                     var lowercaseQuery = query.toLowerCase();
  //                     return contacts.where((profile) {
  //                       return profile.name
  //                               .toLowerCase()
  //                               .contains(query.toLowerCase()) ||
  //                           profile.email
  //                               .toLowerCase()
  //                               .contains(query.toLowerCase());
  //                     }).toList(growable: false)
  //                       ..sort((a, b) => a.name
  //                           .toLowerCase()
  //                           .indexOf(lowercaseQuery)
  //                           .compareTo(
  //                               b.name.toLowerCase().indexOf(lowercaseQuery)));
  //                   } else {
  //                     return const <Contact>[];
  //                   }
  //                 },
  //                 chipBuilder: (context, state, profile) {
  //                   return InputChip(
  //                     key: ObjectKey(profile),
  //                     label: Text(profile.name),
  //                     avatar: CircleAvatar(
  //                       backgroundImage: NetworkImage(profile.imageUrl),
  //                     ),
  //                     onDeleted: () => state.deleteChip(profile),
  //                     materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  //                   );
  //                 },
  //                 suggestionBuilder: (context, state, profile) {
  //                   return ListTile(
  //                     key: ObjectKey(profile),
  //                     leading: CircleAvatar(
  //                       backgroundImage: NetworkImage(profile.imageUrl),
  //                     ),
  //                     title: Text(profile.name),
  //                     subtitle: Text(profile.email),
  //                     onTap: () => state.selectSuggestion(profile),
  //                   );
  //                 },
  //               ),