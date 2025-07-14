import 'package:flutter/material.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/new_screens/theme.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:flutter_view_controller/theming/text_field_theming.dart';

RelativeRect getRealativPosition(GlobalKey clickedWidget) {
  RenderBox renderBox =
      clickedWidget.currentContext?.findRenderObject() as RenderBox;

  final Size size = renderBox.size; // or _widgetKey.currentContext?.size
  debugPrint('getRealativPosition Size: ${size.width}, ${size.height}');

  final Offset offset = renderBox.localToGlobal(Offset.zero);
  debugPrint('getRealativPosition Offset: ${offset.dx}, ${offset.dy}');
  debugPrint(
      'getRealativPosition Position: ${(offset.dx + size.width) / 2}, ${(offset.dy + size.height) / 2}');
  return RelativeRect.fromLTRB(
    offset.dx,
    offset.dy + size.height,
    offset.dx,
    offset.dy,
  );
}

List<dynamic> dropdownGetValues(ViewAbstractEnum enumViewAbstract) {
  List<dynamic> v = [];
  v.add(null);
  v.addAll(enumViewAbstract.getValues());
  return v;
}

String getEditControllerText(dynamic invokedValue) {
  debugPrint(
      "getEditControllerText type is ${invokedValue.runtimeType} value => $invokedValue");
  if (invokedValue is double) {
    return (invokedValue).toCurrencyFormatWithoutDecimalReturnSpaceIfZero();
  } else if (invokedValue is num) {
    return (invokedValue).toCurrencyFormatWithoutDecimalReturnSpaceIfZero();
  } else if (invokedValue is int) {
    return (invokedValue).toCurrencyFormatWithoutDecimalReturnSpaceIfZero();
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
    {IconData? icon, required String label}) {
  return InputDecoration(
    isDense: true,
    // contentPadding: EdgeInsets.zero,
    // filled: true,
    // border: const OutlineInputBorder(

    //     // borderSide: BorderSide(strokeAlign: ),
    //     // borderSide: BorderSide.none,
    //     // gapPadding: 0,
    //     borderRadius: BorderRadius.all(Radius.circular(kBorderRadius))),
    icon: icon == null
        ? null
        : Icon(
            icon,
            // size: 15,
          ),
    // labelText: label
  );
  // hintText: parent.getTextInputHint(context, field));
}

InputDecoration getDecorationDropdown(BuildContext context, ViewAbstract parent,
    ViewAbstractEnum viewAbstractEnum, String field) {
  return InputDecoration(
    // filled: true,
    // border: const OutlineInputBorder(),

    icon: Icon(viewAbstractEnum.getMainIconData()),
    // labelText: viewAbstractEnum.getMainLabelText(context)
  );
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

InputDecoration getDecorationWithoutDecoration(
    BuildContext context, ViewAbstract viewAbstract, String field) {
  return InputDecoration(
      hintText: viewAbstract.getTextInputHint(context, field: field),
      labelText: viewAbstract.getTextInputLabel(context, field),
      prefixText: viewAbstract.getTextInputPrefix(context, field),
      suffixText: viewAbstract.getTextInputSuffix(context, field));
}

bool isDecorationFilled(CurrentScreenSize? c) {
  if (c == null) return true;
  if (c == CurrentScreenSize.MOBILE) return true;
  return false;
}

InputDecoration getDecorationIconHintPrefix(
    {required BuildContext context,
    String? prefix,
    String? suffix,
    String? hint,
    String? label,
    IconData? icon,
    CurrentScreenSize? currentScreenSize}) {
  return InputDecoration(
      icon: icon == null ? null : Icon(icon),
      hintText: hint,
      border: InputBorder.none,
      errorStyle: Theme.of(context)
          .textTheme
          .bodySmall
          ?.copyWith(color: Theme.of(context).colorScheme.error),
      labelText: label,
      counterText: '',
      prefixText: prefix,
      suffixText: suffix);
}

InputDecoration getDecoration(BuildContext context, ViewAbstract viewAbstract,
    {String? field, CurrentScreenSize? currentScreenSize}) {
  debugPrint("getDecoration currentScreenSize: $currentScreenSize");
  bool isLarge = isLargeScreen(context);
  if (field != null) {
    return getDecorationIconHintPrefix(
        context: context,
        currentScreenSize: currentScreenSize,
        prefix: viewAbstract.getTextInputPrefix(context, field),
        suffix: viewAbstract.getTextInputSuffix(context, field),
        hint: viewAbstract.getTextInputHint(context, field: field),
        label: isLarge ? null : viewAbstract.getTextInputLabel(context, field),
        icon: isLarge ? null : viewAbstract.getTextInputIconData(field));
  } else {
    return getDecorationIconHintPrefix(
        context: context,
        currentScreenSize: currentScreenSize,
        icon: isLarge ? null : viewAbstract.getMainIconData(),
        hint: viewAbstract.getTextInputHint(context));
  }
}

Widget getSpace({double? height = 26}) {
  return SizedBox(height: height);
}

Widget getSpaceWidth({double? width = 20}) {
  return SizedBox(width: width);
}

bool canSubmitChanges(ViewAbstract viewAbstract) =>
    (viewAbstract.getParent) != null;

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
      // decoration: getDecorationTheming(context, theme),
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
