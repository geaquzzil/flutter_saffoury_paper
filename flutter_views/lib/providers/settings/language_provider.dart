import 'package:flutter/material.dart';

class LangaugeProvider with ChangeNotifier {
  Locale? _local;
  Locale? get getLocale => _local;
  void change(Locale locale) {
    _local = locale;
    notifyListeners();
  }
}
