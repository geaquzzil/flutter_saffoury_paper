import 'package:flutter/cupertino.dart';
import 'package:flutter_view_controller/models/prints/print_commad_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

import '../../models/prints/print_local_setting.dart';

abstract class ModifiableInterface<T> {
  String getModifiableMainGroupName(BuildContext context);
  String getModifibleTitleName(BuildContext context);
  IconData getModifibleIconData();
  T getModifibleObject(BuildContext context);



}

// abstract class PrintableSetting extends ModifiableInterface {
//   PrintLocalSetting getPrintSetting(BuildContext context);
// }
