import 'package:flutter/cupertino.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:pdf/pdf.dart';

abstract class ModifiableInterface<T> {
  String getModifiableMainGroupName(BuildContext context);
  String getModifibleTitleName(BuildContext context);
  IconData getModifibleIconData();
  T getModifibleSettingObject(BuildContext context);


}

abstract class ModifiablePrintableInterface<T> extends ModifiableInterface<T> {
  PrintableMaster getModifiablePrintablePdfSetting(BuildContext context);


}

class PrintPageSetting {
  PdfPageFormat? defaultPageFormat;
  String? primaryColor;
  String? secondaryColor;
  PrintPageSetting();
}
// abstract class PrintableSetting extends ModifiableInterface {
//   PrintLocalSetting getPrintSetting(BuildContext context);
// }
