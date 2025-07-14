import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:reactive_forms/reactive_forms.dart';

class NotRequiredValidator extends Validator<dynamic> {
  final ViewAbstract parent;
  final String field;
  final BuildContext context;
  // final Map<String, AbstractControl>? _savedValidaters;
  const NotRequiredValidator(
      {required this.context, required this.parent, required this.field})
      : super();

  @override
  Map<String, dynamic>? validate(AbstractControl<dynamic> control) {
    FormGroup form = control as FormGroup;
    bool canBeNullable = parent.isFieldCanBeNullable(context, field);
    debugPrint(
        "NotRequiredValidator field:$field, parent:${parent.getTableNameApi()} canBeNullable:$canBeNullable");
    if (canBeNullable) {
      form.forEachChild((p0) {
        debugPrint("NotRequiredValidator subControl ${p0.validators}");
        p0.clearValidators();
      });
      debugPrint("\n\n");
      return null;
    }

    debugPrint("\n\n");

    // control.

    return null;
  }
}

//Test extends Validator<dynamic> {
//   final List<Validator<dynamic>> validators;

//   /// Constructs an instance of the validator.
//   ///
//   /// The argument [validators] must not be null.
//   const ComposeOrValidator(this.validators) : super();

//   @override
//   Map<String, dynamic>? validate(AbstractControl<dynamic> control) {
//     final composedError = <String, dynamic>{};

//     for (final validator in validators) {
//       final error = validator.validate(control);
//       if (error != null) {
//         composedError.addAll(error);
//       } else {
//         return null;
//       }
//     }

//     return composedError.isEmpty ? null : composedError;
//   }
// }
