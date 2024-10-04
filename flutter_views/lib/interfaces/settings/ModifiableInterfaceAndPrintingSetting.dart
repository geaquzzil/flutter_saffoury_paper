// ignore_for_file: file_names

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_view_controller/configrations.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';
import 'package:pdf/pdf.dart';

mixin ModifiableInterface<T extends ViewAbstract> {
  String getModifiableMainGroupName(BuildContext context);
  String getModifibleTitleName(BuildContext context);
  IconData getModifibleIconData();
  FutureOr<T> getModifibleSettingObject(BuildContext context);
  Future<T> getModifibleSettingObjcetSavedValue(BuildContext context) async {
    return onModifibleSettingLoaded(await Configurations.getReturnDefaultOnNull(
        await getModifibleSettingObject(context)));
  }

  Future<T> onModifibleSettingLoaded(T loaded) async {
    return loaded;
  }
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
