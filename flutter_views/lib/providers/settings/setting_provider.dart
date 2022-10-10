import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:provider/provider.dart';

import '../../interfaces/settings/printable_setting.dart';
import '../auth_provider.dart';

class SettingProvider with ChangeNotifier {
  ModifiableInterface? _selectedObject;
  ModifiableInterface? get getSelectedObject => _selectedObject;
  void change(ModifiableInterface _selectedObject) {
    this._selectedObject = _selectedObject;
    notifyListeners();
  }

  List<ModifiableInterface> getModifiableListSetting(BuildContext context) {
    List<ModifiableInterface> printableSettingsObjects = context
        .read<AuthProvider>()
        .getDrawerItemsPermissions
        .whereType<ModifiableInterface>()
        .toList();
    return printableSettingsObjects;
  }
}
