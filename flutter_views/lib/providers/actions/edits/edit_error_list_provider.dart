import 'package:flutter/cupertino.dart';
import 'package:flutter_view_controller/models/components/form_validator.dart';

class ErrorFieldsProvider with ChangeNotifier {
  late FormValidationManager formValidationManager;
  get getFormValidationManager => formValidationManager;
  get getErrorFieldsCount => formValidationManager.erroredFields.length;
  void initState() {
    formValidationManager = FormValidationManager();
  }

  void clear() {
    formValidationManager.dispose();
  }
}
