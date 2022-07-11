import 'package:flutter/cupertino.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/actions/edits/form_validator.dart';

class ErrorFieldsProvider with ChangeNotifier {
  late FormValidationManager _formValidationManager = FormValidationManager();
  FormValidationManager get getFormValidationManager => _formValidationManager;
  int get getErrorFieldsCount => _formValidationManager.erroredFields.length;

  FormFieldValidator<T> wrapValidator<T>(String key, ViewAbstract viewAbstract,
      String field, FormFieldValidator<T> validator) {
    return _formValidationManager.wrapValidator(
        key, viewAbstract, field, validator);
  }

  FocusNode getFocusNodeForField(key, ViewAbstract viewAbstract, String field) {
    return _formValidationManager.getFocusNodeForField(
        key, viewAbstract, field);
  }

  bool hasError(ViewAbstract viewAbstract) {
    return _formValidationManager.hasError(viewAbstract);
  }

  void initState() {
    _formValidationManager = FormValidationManager();
  }

  void notify() {
    debugPrint("errorFieldsProvider notify called");
    notifyListeners();
  }

  void clear() {
    _formValidationManager.dispose();
  }
}
