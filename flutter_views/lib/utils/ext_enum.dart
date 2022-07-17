import 'package:flutter_view_controller/models/view_abstract_enum.dart';

extension on ViewAbstractEnum {
  String getName() {
    return toString().split(".").last;
  }
}

String getEnumName(ViewAbstractEnum e) {
  return e.getName();
}
