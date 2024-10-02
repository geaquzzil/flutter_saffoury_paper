import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/barcode_setting.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/models/prints/printer_default_setting.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';

import '../../interfaces/settings/ModifiableInterfaceAndPrintingSetting.dart';
import '../auth_provider.dart';

@Deprecated("not in use anymore")
class SettingProvider with ChangeNotifier {
  ModifiableInterface? _selectedObject;
  ModifiableInterface? get getSelectedObject => _selectedObject;
  void change(ModifiableInterface selectedObject) {
    _selectedObject = selectedObject;
    notifyListeners();
  }

  List<ModifiableInterface> getModifiableListSetting(BuildContext context) {
    List<ModifiableInterface> printableSettingsObjects = context
        .read<AuthProvider<AuthUser>>()
        .getDrawerItemsPermissions
        .whereType<ModifiableInterface>()
        .toList();
    printableSettingsObjects.add(PrinterDefaultSetting());
    if (supportsSerialPort()) {
      printableSettingsObjects.add(BarcodeSetting());
    }
    return printableSettingsObjects;
  }
}
