import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

abstract class ViewAbstractEnum<T> {
  IconData getMainIconData();
  String getMainLabelText(BuildContext context);
  String getFieldLabelString(BuildContext context, T field);
  List<T> getValues();

  
}

