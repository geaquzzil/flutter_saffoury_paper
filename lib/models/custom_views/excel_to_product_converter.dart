import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/icon_data.dart';
import 'package:flutter_view_controller/interfaces/excelable_reader_interface.dart';
import 'package:flutter_view_controller/models/view_apstract_stand_alone_without_api.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/new_screens/file_reader/base_file_reader_page.dart';

class ExcelToProductConverter
    extends ViewAbstractStandAloneCustomView<ExcelToProductConverter>
    implements ExcelableReaderInterace {
  String? product;
  String? quantity;

  @override
  List<String> getMainFields({BuildContext? context}) =>
      ["product", "quantity"];

  @override
  Map<String, bool> isFieldRequiredMap() => {"product": true, "quantity": true};

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {
        "product": AppLocalizations.of(context)!.excel,
        "quantity": AppLocalizations.of(context)!.quantity
      };

  @override
  Map<String, IconData> getFieldIconDataMap() =>
      {"product": Icons.abc, "quantity": Icons.scale};

  @override
  Widget? getCustomFloatingActionWidget(BuildContext context) {
    return FileReaderPage(
      viewAbstract: this,
    );
  }

  @override
  List<String> getExcelableRemovedFields() => [];

  @override
  String? getMainDrawerGroupName(BuildContext context) => null;

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.excel;

  @override
  String getMainHeaderTextOnly(BuildContext context) =>
      getMainHeaderLabelTextOnly(context);

  @override
  IconData getMainIconData() => Icons.table_chart;

  @override
  ExcelToProductConverter getSelfNewInstance() => ExcelToProductConverter();
}
