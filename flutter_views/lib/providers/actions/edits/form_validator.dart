import 'package:flutter/material.dart';
import 'package:flutter_view_controller/flutter_view_controller.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

class FormValidationManager {
  final _fieldStates = <String, FormFieldValidationState>{};

  FocusNode getFocusNodeForField(key, ViewAbstract viewAbstract, String field) {
    _ensureExists(key, viewAbstract, field);
    return _fieldStates[key]!.focusNode;
  }

  FormFieldValidator<T> wrapValidator<T>(String key, ViewAbstract viewAbstract,
      String field, FormFieldValidator<T> validator) {
    _ensureExists(key, viewAbstract, field);
    debugPrint("wrapValidator list before input");
    return (input) {
      final result = validator(input);
      _fieldStates[key]?.errorMessage = result;
      _fieldStates[key]?.hasError = (result?.isNotEmpty ?? false);
      debugPrint(
          "wrapValidator key=> $key has error ${_fieldStates[key]?.hasError}");
      return result;
    };
  }

  void removeError(ViewAbstract viewAbstract) {
    _fieldStates.entries
        .where((element) => element.value.viewAbstract
                .getGenericClassName()
                .contains((viewAbstract.getGenericClassName()))
            // &&(element.value.hasError)
            )
        .map((e) => e.value.removeError());
  }

  bool hasError(ViewAbstract viewAbstract) {
    debugPrint(
        "hasError Checking before name=> ${viewAbstract.getGenericClassName()}");
    final res = _fieldStates.entries
        .where((element) => element.value.viewAbstract
                .getGenericClassName()
                .contains((viewAbstract.getGenericClassName()))
            // &&(element.value.hasError)
            )
        .toList();
    bool result =
        res.firstWhereOrNull((p0) => p0.value.hasError)?.value.hasError ??
            false;
    debugPrint("hasError Checking $result");
    return result;
  }

  List<FormFieldValidationState> get erroredFields => _fieldStates.entries
      .where((s) => s.value.hasError)
      .map((s) => s.value)
      .toList();

  void _ensureExists(String key, ViewAbstract viewAbstract, String field) {
    _fieldStates[key] ??= FormFieldValidationState(
        key: key, viewAbstract: viewAbstract, field: field);
  }

  void dispose() {
    _fieldStates.clear();
    for (var s in _fieldStates.entries) {
      s.value.focusNode.dispose();
    }
  }
}

class FormFieldValidationState {
  ViewAbstract viewAbstract;
  String field;
  final String key;
  bool hasError;
  FocusNode focusNode;

  String? errorMessage;

  @override
  String toString() {
    return 'FormFieldValidationState{key: $key, hasError: $hasError}';
  }

  FormFieldValidationState(
      {required this.key, required this.viewAbstract, required this.field})
      : hasError = false,
        focusNode = FocusNode();

  String? getErrorMessage(BuildContext context) {
    return errorMessage;
  }

  void removeError() {
    hasError = false;
  }
}
