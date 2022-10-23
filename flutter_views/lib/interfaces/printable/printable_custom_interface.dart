import 'package:flutter/material.dart' as mt;
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

abstract class PrintableCustomInterface<T extends PrintLocalSetting> extends PrintableMaster<T> {
  Future<List<Widget>> getPrintableCustomPage(mt.BuildContext context,
      {PdfPageFormat? format});
  Future<Widget?>? getPrintableCustomFooter(mt.BuildContext context,
      {PdfPageFormat? format});
  Future<Widget?>? getPrintableCustomHeader(mt.BuildContext context,
      {PdfPageFormat? format});
}
