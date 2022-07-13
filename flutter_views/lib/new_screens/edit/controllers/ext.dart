import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/providers/actions/edits/edit_error_list_provider.dart';
import 'package:flutter_view_controller/providers/actions/edits/sub_edit_viewabstract_provider.dart';
import 'package:provider/provider.dart';

InputDecoration getDecorationDropdown(BuildContext context, ViewAbstract parent,
    ViewAbstractEnum viewAbstractEnum, String field) {
  return InputDecoration(
    border: const UnderlineInputBorder(),
    filled: true,
    icon: Icon(viewAbstractEnum.getMainIconData()),
    labelText: viewAbstractEnum.getMainLabelText(context),
  );
}

InputDecoration getDecoration(
    BuildContext context, ViewAbstract viewAbstract, String field) {
  return InputDecoration(
      border: const UnderlineInputBorder(),
      filled: true,
      icon: viewAbstract.getTextInputIcon(field),
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
