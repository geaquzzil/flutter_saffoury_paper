import 'package:flutter/material.dart';

abstract class ViewAbstractEnum<T> {
  IconData getMainIconData();

  IconData getFieldLabelIconData(BuildContext context, T field);
  String getMainLabelText(BuildContext context);
  String getFieldLabelString(BuildContext context, T field);
  List<T> getValues();

  
}

