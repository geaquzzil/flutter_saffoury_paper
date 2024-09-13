import 'package:flutter/material.dart';
import 'package:flutter_view_controller/new_screens/file_reader/file_rader_object_view_abstract.dart';
import 'package:introduction_screen/introduction_screen.dart';


abstract class ExcelableReaderInterace {
  List<String> getExcelableFields(BuildContext context);
}

abstract class ExcelableReaderInteraceCustom extends ExcelableReaderInterace {
  List<PageViewModel> getExceableAddOnList(
      BuildContext context, FileReaderObject? validatedObject);
}
