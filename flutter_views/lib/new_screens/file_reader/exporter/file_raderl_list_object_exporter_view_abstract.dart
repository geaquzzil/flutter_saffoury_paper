import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/file_reader/exporter/file_rader_object_exporter_view_abstract.dart';
import 'package:excel/excel.dart';
import 'package:path/path.dart';

@reflector
class FileExporterListObject extends FileExporterObject {
  late List<ViewAbstract> list;
  FileExporterListObject(
      {required ViewAbstract viewAbstract, required this.list})
      : super(viewAbstract: viewAbstract);

  @override
  Future<void> generateExcel(BuildContext context) async {
    Stopwatch stopwatch = new Stopwatch()..start();
    excel = Excel.createExcel();

    Sheet sh = excel[excel.getDefaultSheet()!];

    CellStyle cellStyle = getCellStyle();

    List<String> fields = viewAbstract
        .getMainFields()
        .where((element) =>
            getFieldValue(element) != null &&
            isRequiredFieldToGenerate(context, element) &&
            !isRequiredFieldDetails(context, element))
        .toList();

    debugPrint('generateExcel Generating  fields => $fields');

    generateExcelHeader(context, cellStyle, sh, fields);
    for (int i = 1; i < list.length; i++) {
      generateExcelCells(context, list[i], sh, fields, rowIndex: i);
    }

    debugPrint('generateExcel Generating executed in ${stopwatch.elapsed}');
    stopwatch.reset();
    var fileBytes = excel.encode();

    debugPrint('generateExcel Encoding executed in ${stopwatch.elapsed}');
    stopwatch.reset();
    if (fileBytes != null) {
      File(join("$fileName-list.xlsx"))
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);
    }
    debugPrint('generateExcel Downloaded executed in ${stopwatch.elapsed}');
  }
}
