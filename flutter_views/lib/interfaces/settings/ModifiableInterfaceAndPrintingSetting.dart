// ignore_for_file: file_names

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_view_controller/configrations.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:pdf/pdf.dart';

abstract class ModifiableInterface<T extends ViewAbstract> {
  String getModifiableMainGroupName(BuildContext context);
  String getModifibleTitleName(BuildContext context);
  IconData getModifibleIconData();
  FutureOr<T> getModifibleSettingObject(BuildContext context);
  Future<FutureOr<T>> getModifibleSettingObjcetSavedValue(
      BuildContext context) async {
    return Configurations.getReturnDefaultOnNull(
        await getModifibleSettingObject(context));
  }
}

abstract class ModifiablePrintableInterface<T extends ViewAbstract>
    extends ModifiableInterface<T> {
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
