import 'package:flutter_view_controller/models/view_abstract_lists.dart';

abstract class ViewAbstract<T> extends ViewAbstractLists<T> {
  bool isEquals(ViewAbstract? object) {
    if (object == null) {
      return false;
    }
    return object.iD == iD && object.getTableNameApi() == getTableNameApi();
  }

  T copyWithSetNew(String field, dynamic value) {
    Map<String, dynamic> jsonCopy = toJsonViewAbstract();
    jsonCopy[field] = value;
    jsonCopy['iD'] = '-1';
    T newObject = fromJsonViewAbstract(jsonCopy);
    (newObject as ViewAbstract).setParent(this.parent);
    (newObject).setFieldNameFromParent(fieldNameFromParent);
    (newObject).setLastSearchViewAbstractByTextInputList(
        getLastSearchViewByTextInputList);
    return newObject;
  }

  @override
  String toString() {
    return toJsonString();
  }
}
