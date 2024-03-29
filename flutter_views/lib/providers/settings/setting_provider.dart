import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../interfaces/settings/ModifiableInterfaceAndPrintingSetting.dart';
import '../auth_provider.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
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

    return printableSettingsObjects;
  }
}
