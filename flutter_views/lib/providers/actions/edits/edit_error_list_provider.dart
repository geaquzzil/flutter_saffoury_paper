import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/actions/edits/form_validator.dart';

class ErrorFieldsProvider with ChangeNotifier {
  late FormValidationManager _formValidationManager = FormValidationManager();
  FormValidationManager get getFormValidationManager => _formValidationManager;
  int get getErrorFieldsCount => _formValidationManager.erroredFields.length;

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  GlobalKey<FormBuilderState> get getFormBuilderState => _formKey;

  FormFieldValidator<T> wrapValidator<T>(String key, ViewAbstract viewAbstract,
      String field, FormFieldValidator<T> validator) {
    return _formValidationManager.wrapValidator(
        key, viewAbstract, field, validator);
  }

  FocusNode getFocusNodeForField(key, ViewAbstract viewAbstract, String field) {
    return _formValidationManager.getFocusNodeForField(
        key, viewAbstract, field);
  }

  void removeError(ViewAbstract viewAbstract) {
    _formValidationManager.removeError(viewAbstract);
    notifyListeners();
  }

  bool hasErrorField(String field) {
    return _formValidationManager.hasErrorField(field);
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
