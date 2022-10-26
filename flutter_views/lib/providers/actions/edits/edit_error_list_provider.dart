import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/actions/edits/form_validation_manager.dart';
import 'package:flutter_view_controller/ext_utils.dart';

class ErrorFieldsProvider with ChangeNotifier {
  late FormValidationManager2 _formValidationManager = FormValidationManager2();
  FormValidationManager2 get getFormValidationManager => _formValidationManager;

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  GlobalKey<FormBuilderState> get getFormBuilderState => _formKey;

  void addField(ViewAbstract viewAbstract, String field) {
    _formValidationManager.addField(field, viewAbstract);
  }

  void removeError(ViewAbstract viewAbstract) {
    _formValidationManager.removeError(viewAbstract);

    notifyListeners();
  }

  bool hasError(ViewAbstract viewAbstract) {
    return _formValidationManager.hasError(viewAbstract);
  }

  void initState() {
    _formValidationManager = FormValidationManager2();
  }

  void notify(ViewAbstract v, String field, String key) {
    debugPrint("errorFieldsProvider notify called");
    _formValidationManager.notifyField(_formKey, key, v, field);
    notifyListeners();
  }

  bool hasErrorField(ViewAbstract v, String field) {
    return _formValidationManager.hasErrorField(v, field);
  }
}

//

class FormValidationManager {
  final _fieldStates = <String, FormFieldValidationState>{};

  void removeError(ViewAbstract viewAbstract) {
    _fieldStates.entries
        .where((element) => element.value.viewAbstract
                .getGenericClassName()
                .contains((viewAbstract.getGenericClassName()))
            // &&(element.value.hasError)
            )
        .map((e) => e.value.removeError());
  }

  bool checkIfItContains(ViewAbstract viewAbstract, ViewAbstract entry) {
    String entryText = entry.parentsTagThis();
    String viewAbstractText = viewAbstract.parentsTagThis();
    debugPrint("checkIfItContains $entryText  VS $viewAbstractText");
    String pattern = viewAbstractText;
    RegExp regExp = RegExp(pattern);
    bool res = regExp.hasMatch(entryText);
    debugPrint("checkIfItContains results $res ");

    return res;
  }

  bool hasError(ViewAbstract viewAbstract) {
    final res = _fieldStates.entries
        .where((element) =>
            checkIfItContains(viewAbstract, element.value.viewAbstract))
        .toList();
    bool result =
        res.firstWhereOrNull((p0) => p0.value.hasError)?.value.hasError ??
            false;
    debugPrint("hasError Checking $result");
    return result;
  }

  bool hasErrorField(String field) {
    return _fieldStates[field]?.hasError ?? false;
  }

  List<FormFieldValidationState> get erroredFields => _fieldStates.entries
      .where((s) => s.value.hasError)
      .map((s) => s.value)
      .toList();

  void ensureExists(String key, ViewAbstract viewAbstract, String field) {
    debugPrint(
        "_ensureExists key=> $key , va=> ${viewAbstract.getGenericClassName()} , field is => $field");
    _fieldStates[key] ??= FormFieldValidationState(
        key: key, viewAbstract: viewAbstract, field: field);
  }

  void dispose() {
    _fieldStates.clear();
    for (var s in _fieldStates.entries) {
      s.value.focusNode.dispose();
    }
  }

  void notifyField(GlobalKey<FormBuilderState> formKey, String key,
      ViewAbstract v, String field) {
    bool? result = formKey.currentState?.fields[key]?.validate();
    debugPrint("notifyField field =>$field res=>$result");
    _fieldStates[key]?.hasError = !(result!);
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
