import 'package:flutter/cupertino.dart';
import 'package:flutter_view_controller/models/components/form_validator.dart';

class ErrorFieldsProvider with ChangeNotifier {
  late FormValidationManager formValidationManager;
  get getFormValidationManager => formValidationManager;
  get errorFieldsCount => formValidationManager.erroredFields.length;

  void change(FormValidationManager formValidationManager) {
    this.formValidationManager = formValidationManager;
    notifyListeners();
  }
}
