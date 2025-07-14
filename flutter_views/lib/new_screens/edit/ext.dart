import 'package:flutter_view_controller/models/view_abstract.dart';

bool checkIfNullAndViewAbstractField(ViewAbstract viewAbstract,
    {String? fieldName, dynamic fieldValue}) {
  fieldValue =
      fieldName == null ? fieldValue : viewAbstract.getFieldValue(fieldName);
  if (fieldValue == null) {
    return  viewAbstract.isViewAbstract(fieldName ?? "");
  }
  return false;
}
