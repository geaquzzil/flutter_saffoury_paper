import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/theming/text_field_theming.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

List<dynamic> dropdownGetValues(ViewAbstractEnum enumViewAbstract) {
  List<dynamic> v = [];
  v.add(null);
  v.addAll(enumViewAbstract.getValues());
  return v;
}

String getEditControllerText(dynamic invokedValue) {
  var num1 = 10.12345678;
  // var f = new NurFormat("###.##", "en_US");
  // print(f.format(num1));
  if (invokedValue is double) {
    return (invokedValue as double?)?.toCurrencyFormatWithoutDecimal() ?? "0";
  }
  return invokedValue?.toString() ?? "";
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
    // filled: true,
    border: OutlineInputBorder(gapPadding: 0),
    // label: TextBold(
    //   text: dropdownGettLabelWithText(context, viewAbstractEnum),
    //   regex: viewAbstractEnum.getFieldLabelString(context, viewAbstractEnum),
    // ));
    // hintText: parent.getTextInputHint(context, field));
  );
}

InputDecoration getDecorationIconLabel(BuildContext context,
    {required IconData icon, required String label}) {
  return InputDecoration(
      // filled: true,
      border: const OutlineInputBorder(),
      icon: Icon(icon),
      labelText: label);
  // hintText: parent.getTextInputHint(context, field));
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

InputDecoration getDecorationForAutoComplete(
    BuildContext context, ViewAbstract viewAbstract) {
  return InputDecoration(
    filled: true,
    icon: SizedBox(
        height: 25,
        width: 25,
        child: viewAbstract.getCardLeadingCircleAvatar(context,
            height: 25, width: 25)),
    hintText: viewAbstract.getTextInputHint(context),
    labelText: viewAbstract.getMainHeaderLabelTextOnly(context),
  );
}
InputDecoration getDecorationWithoutDecoration(BuildContext context,ViewAbstract viewAbstract,String field){
     return InputDecoration(
        hintText: viewAbstract.getTextInputHint(context, field: field),
        labelText: viewAbstract.getTextInputLabel(context, field),
        prefixText: viewAbstract.getTextInputPrefix(context, field),
        suffixText: viewAbstract.getTextInputSuffix(context, field));
  
}
InputDecoration getDecoration(BuildContext context, ViewAbstract viewAbstract,
    {String? field}) {
  if (field != null) {
    return InputDecoration(
        // border: const UnderlineInputBorder(),
        filled: true,
        // fillColor: Theme.of(context).colorScheme.onBackground,
        // errorText: "err",
        icon: viewAbstract.getTextInputIcon(field),
        // iconColor: context
        //         .watch<ErrorFieldsProvider>()
        //         .hasErrorField(viewAbstract, field)
        //     ? Theme.of(context).colorScheme.error
        //     : null,
        hintText: viewAbstract.getTextInputHint(context, field: field),
        labelText: viewAbstract.getTextInputLabel(context, field),
        prefixText: viewAbstract.getTextInputPrefix(context, field),
        suffixText: viewAbstract.getTextInputSuffix(context, field));
  } else {
    return InputDecoration(
      border: const UnderlineInputBorder(),
      filled: true,

      // errorText: "err",
      icon: viewAbstract.getIcon(),
      // iconColor: context
      //         .watch<ErrorFieldsProvider>()
      //         .hasErrorField(viewAbstract, field)
      //     ? Theme.of(context).colorScheme.error
      //     : null,
      hintText: viewAbstract.getTextInputHint(context),
      // labelText: viewAbstract.getMainHeaderLabelTextOnly(context),
    );
  }
}

Widget getSpace({double? height = 26}) {
  return SizedBox(height: height);
}

bool canSubmitChanges(ViewAbstract viewAbstract) =>
    (viewAbstract.getParnet) != null;

ViewAbstract copyWithSetNew(
    ViewAbstract oldViewAbstract, String field, dynamic value) {
  ViewAbstract newObject = oldViewAbstract.copyWithSetNew(field, value);
  return newObject;
}

// dynamic getFieldValue(
//     BuildContext context, String? parentField, String currentField) {
//   dynamic value =
//       getViewAbstract(context, parentField)?.getFieldValue(currentField);
//   return value ?? "";
// }

// dynamic getFieldValueForTextField(
//     BuildContext context, String? parentField, String currentField) {
//   return getFieldValue(context, parentField, currentField).toString();
// }

String getFieldNameFromParent(ViewAbstract viewAbstract) {
  return viewAbstract.getFieldNameFromParent ?? "";
}

// ViewAbstract onChange(BuildContext context, ViewAbstract oldViewAbstract,
//     String field, dynamic value) {
//   debugPrint("isChanged to $value");
//   if (canSubmitChanges(oldViewAbstract)) {
//     debugPrint("isChanged can submit changes to $value");
//     return toggleIsNew(context, oldViewAbstract, field, value);
//   }
//   return oldViewAbstract;
// }

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