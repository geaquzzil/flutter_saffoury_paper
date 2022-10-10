import 'package:flutter/cupertino.dart';
import 'package:flutter_view_controller/models/prints/print_commad_abstract.dart';

import '../../models/prints/print_local_setting.dart';

abstract class ModifiableInterface {
  String getModifiableMainGroupName(BuildContext context);
  String getModifibleTitleName(BuildContext context);
  IconData getModifibleIconData();


}

// abstract class PrintableSetting extends ModifiableInterface {
//   PrintLocalSetting getPrintSetting(BuildContext context);
// }
