import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/icon_data.dart';
import 'package:flutter_view_controller/interfaces/excelable_reader_interface.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_apstract_stand_alone_without_api.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/new_components/tables_widgets/view_table_view_abstract.dart';
import 'package:flutter_view_controller/new_screens/file_reader/base_file_reader_page.dart';
import 'package:flutter_view_controller/new_screens/file_reader/file_rader_object_view_abstract.dart';
import 'package:flutter_view_controller/new_screens/file_reader/file_reader_validation.dart';
import 'package:introduction_screen/src/model/page_view_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
part 'excel_to_product_converter.g.dart';

@reflector
@JsonSerializable(explicitToJson: true)
class ExcelToProductConverter
    extends ViewAbstractStandAloneCustomView<ExcelToProductConverter>
    implements ExcelableReaderInteraceCustom {
  String? product;
  @JsonKey(fromJson: convertToDouble)
  int? quantity;
  ExcelToProductConverter();
  factory ExcelToProductConverter.fromJson(Map<String, dynamic> json) =>
      _$ExcelToProductConverterFromJson(json);

  Map<String, dynamic> toJson() => _$ExcelToProductConverterToJson(this);

  @override
  ExcelToProductConverter fromJsonViewAbstract(Map<String, dynamic> json) {
    return ExcelToProductConverter.fromJson(json);
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() => {
        "product": "",
        "quantity": 0,
      };

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    return toJson();
  }

  @override
  List<String> getMainFields({BuildContext? context}) =>
      ["product", "quantity"];

  @override
  Map<String, bool> isFieldRequiredMap() => {"product": true, "quantity": true};

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {
        "product": AppLocalizations.of(context)!.description,
        "quantity": AppLocalizations.of(context)!.quantity
      };

  @override
  Map<String, IconData> getFieldIconDataMap() =>
      {"product": Icons.abc, "quantity": Icons.scale};

  @override
  Widget? getCustomFloatingActionWidget(BuildContext context) => null;

  @override
  Widget getCustomStandAloneWidget(BuildContext context) {
    
    // return AnimatedSwitcher(
    //     // key: UniqueKey(),
    //     duration: const Duration(milliseconds: 250),
    //     child: FileReaderPage(
    //       viewAbstract: this,
    //     ));
    return FileReaderPage(
      viewAbstract: this,
    );
  }

  @override
  bool getCustomStandAloneWidgetIsPadding() {
    return true;
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
  static int? convertToDouble(dynamic number) =>
      number == null ? 0 : int.tryParse(number.toString());
  @override
  List<PageViewModel> getExceableAddOnList(
      BuildContext context, FileReaderObject? validatedObject) {
    List list = [];
    if (validatedObject != null) {
      list = FileReaderValidationWidget.getDataFromExcelTable(
          context, validatedObject);
    }
    debugPrint(
        "getExceableAddOnList validatedObject is null ${validatedObject == null} list is $list");
    return [
      PageViewModel(
          title: "Validations",
          bodyWidget: ViewableTableViewAbstractWidget(
            viewAbstract: list.cast(),
            usePag: true,
          ))
    ];
  }
}
