import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

InputDecoration getDecoration(
    BuildContext context, ViewAbstract viewAbstract, String field) {
  return InputDecoration(
    border: const UnderlineInputBorder(),
    filled: true,
    icon: viewAbstract.getTextInputIcon(field),
    hintText: viewAbstract.getTextInputHint(context, field),
    labelText: viewAbstract.getTextInputLabel(context, field),
    prefixText: viewAbstract.getTextInputPrefix(context, field),
  );
}

Widget getSpace() {
  return const SizedBox(height: 24.0);
}

bool canSubmitChanges(ViewAbstract viewAbstract) =>
    (viewAbstract.getParnet) != null;

ViewAbstract copyWithSetNew(
    ViewAbstract oldViewAbstract, String field, dynamic value) {
  ViewAbstract newObject = oldViewAbstract.copyWithSetNew(field, value);
  return newObject;
}
