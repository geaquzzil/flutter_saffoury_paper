import 'package:flutter_view_controller/models/view_abstract_inputs_validaters.dart';
import 'package:flutter_view_controller/models/view_abstract_lists.dart';

abstract class ViewAbstract<T> extends ViewAbstractLists<T> {
  bool isEquals(ViewAbstract? object) {
    if (object == null) {
      return false;
    }
    return object.iD == iD && object.getTableNameApi() == getTableNameApi();
  }
}
