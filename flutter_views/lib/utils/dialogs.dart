import 'package:flutter/material.dart';
import 'package:flutter_view_controller/size_config.dart';

Future<T?> showBottomSheetExt<T>(
    {required BuildContext context,
    required Widget Function(BuildContext) builder}) {
  return showModalBottomSheet<T>(
    isScrollControlled: true,
    context: context,
    elevation: 4,
    enableDrag: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    builder: (context) {
      return FractionallySizedBox(
          heightFactor: 0.9, child: builder.call(context));
    },
  );
}

Future<T?> showDialogExt<T>(
    {required BuildContext context,
    required Widget Function(BuildContext) builder}) {
  return showDialog(
      context: context, barrierDismissible: false, builder: builder);
}
