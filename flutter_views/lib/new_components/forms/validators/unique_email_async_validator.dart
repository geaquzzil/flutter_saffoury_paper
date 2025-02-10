import 'dart:async';

import 'package:flutter_view_controller/ext_utils.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// Validator that validates the user's email is unique, sending a request to
/// the Server.
class UniqueValidator2 extends AsyncValidator<dynamic> {
  FutureOr<List> future;
  UniqueValidator2({
    required this.future,
  });

  @override
  Future<Map<String, dynamic>?> validate(
      AbstractControl<dynamic> control) async {
    final error = {'unique': false};

    final isFounded = await _getIsUnique(control.value.toString());
    if (isFounded) {
      control.markAsTouched();
      return error;
    }

    return null;
  }

  /// Simulates a time consuming operation (i.e. a Server request)
  Future<bool> _getIsUnique(String value) async {
    // simple array that simulates emails stored in the Server DB.

    final list = await future;

    return list.firstWhereOrNull(
          (p0) => p0.toString().contains(value),
        ) !=
        null;
  }
}
