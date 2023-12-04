import 'package:flutter/material.dart';
import 'package:flutter_view_controller/new_screens/file_reader/file_rader_object_view_abstract.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'listable_interface.dart';

abstract class ExcelableReaderInterace {
  List<String> getExcelableRemovedFields();
}

abstract class ExcelableReaderInteraceCustom extends ExcelableReaderInterace {
  List<PageViewModel> getExceableAddOnList(
      BuildContext context, FileReaderObject? validatedObject);
}
