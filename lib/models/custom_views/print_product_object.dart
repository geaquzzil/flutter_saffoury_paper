import 'package:flutter/material.dart';
import 'package:flutter/src/services/text_input.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/icon_data.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_saffoury_paper/models/products/gsms.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_saffoury_paper/models/products/sizes.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/models/view_abstract_inputs_validaters.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
part 'print_product_object.g.dart';

@JsonSerializable(
  explicitToJson: true,
)
@reflector
class ProductPrintObject extends ViewAbstract<ProductPrintObject> {
  String description = "";
  int gsm = 0;
  ProductSize? size;

  String comments = "";
  String customer = "";
  double quantity = 0;
  double sheets = 0;
  String? cutRequestNumber;

  ProductPrintObject();
  @override
  List<String> getMainFields({BuildContext? context}) {
    return [
      "description",
      "customer",
      "size",
      "gsm",
      "quantity",
      "sheets",
      "cutRequestNumber",
      "comments",
    ];
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() => {
        "description": "",
        "size": ProductSize(),
        "comments": "",
        "customer": "",
        "cutRequestNumber": "",
        "gsm": 0,
        "quantity": 0.0,
        "sheets": 0.0
      };

  @override
  ProductPrintObject fromJsonViewAbstract(Map<String, dynamic> json) {
    return ProductPrintObject.fromJson(json);
  }

  @override
  bool getIsSubViewAbstractIsExpanded(String field) {
    if (field == "size" || field == "gsm") return true;
    return super.getIsSubViewAbstractIsExpanded(field);
  }

  @override
  ViewAbstractControllerInputType getInputType(String field) {
    // if (field == "gsm") {
    //   return ViewAbstractControllerInputType.VIEW_ABSTRACT_AS_ONE_FIELD;
    // }
    return super.getInputType(field);
  }

  @override
  Map<String, IconData> getFieldIconDataMap() => {
        "description": Icons.abc,
        "date": Icons.date_range,
        "gsm": Icons.line_weight,
        "sheets": Icons.line_weight_outlined,
        "cutRequestNumber": Icons.numbers,
        "comments": Icons.notes,
        "customer": Icons.account_circle,
        "quantity": Icons.scale
      };

  @override
  void onTextChangeListenerOnSubViewAbstract(
      BuildContext context, ViewAbstract subViewAbstract, String field,
      {GlobalKey<FormBuilderState>? parentformKey}) {
    super
        .onTextChangeListenerOnSubViewAbstract(context, subViewAbstract, field);
    _setSheets(context, formKey: parentformKey);
  }

  void _setSheets(BuildContext context,
      {GlobalKey<FormBuilderState>? formKey}) {
    // return;
    GSM g = GSM()..gsm = gsm;
    Product p = Product()
      ..sizes = size
      ..gsms = g;

    sheets = p.getSheets(customQuantity: quantity);
    debugPrint(
        "onTextChangeListener current quantity $quantity ,sheets : $sheets");
    setFieldValue("sheets", sheets);
    // return;
    notifyOtherControllers(
        context: context, formKey: formKey, notifySpecificField: "sheets");
  }

  @override
  void onTextChangeListener(BuildContext context, String field, String? value,
      {GlobalKey<FormBuilderState>? formKey}) {
    super.onTextChangeListener(context, field, value);
    _setSheets(context, formKey: formKey);
  }

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {
        "description": AppLocalizations.of(context)!.product_type,
        'date': AppLocalizations.of(context)!.date,
        "gsm": AppLocalizations.of(context)!.gsm,
        "cutRequestNumber": AppLocalizations.of(context)!.cutRequest,
        "barcode": AppLocalizations.of(context)!.barcode,
        "customer": AppLocalizations.of(context)!.customer,
        "quantity": AppLocalizations.of(context)!.quantity,
        "sheets": AppLocalizations.of(context)!.totalSheetNumberByReams,
        "comments": AppLocalizations.of(context)!.comments,
      };

  @override
  bool isFieldEnabled(String field) {
    return field != "sheets";
  }

  @override
  String? getMainDrawerGroupName(BuildContext context) => null;

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) {
    return AppLocalizations.of(context)!.product;
  }

  @override
  String getMainHeaderTextOnly(BuildContext context) {
    return AppLocalizations.of(context)!.product;
  }

  @override
  IconData getMainIconData() {
    return Icons.account_balance_wallet_sharp;
  }

  @override
  ProductPrintObject getSelfNewInstance() {
    return ProductPrintObject();
  }

  @override
  String getSortByFieldName() {
    return "date";
  }

  @override
  SortByType getSortByType() {
    return SortByType.DESC;
  }
//  return FloatingActionButton(
//         heroTag: UniqueKey(),
//         child: const Icon(Icons.print),
//         onPressed: () async => await Printing.layoutPdf(
//             onLayout: (PdfPageFormat format) async => loadedFile));
//   FloatingActionButton.small(
//         heroTag: UniqueKey(),
//         child: const Icon(Icons.share),
//         onPressed: () async => await Printing.sharePdf(bytes: loadedFileBytes));

  @override
  String? getTableNameApi() => null;

  @override
  Map<String, bool> getTextInputIsAutoCompleteMap() => {};
  @override
  Map<String, bool> getTextInputIsAutoCompleteViewAbstractMap() => {};

  @override
  Map<String, double> getTextInputMaxValidateMap() => {"quantity": 9999};

  @override
  Map<String, double> getTextInputMinValidateMap() => {"quantity": 1};
  @override
  Map<String, int> getTextInputMaxLengthMap() => {"gsm": 4, "quantity": 4};

  @override
  Map<String, TextInputType?> getTextInputTypeMap() => {
        "quantity": TextInputType.number,
        "date": TextInputType.datetime,
        "products_types": TextInputType.number,
        "comments": TextInputType.text,
        "customer": TextInputType.multiline,
        "sheets": TextInputType.number,
      };

  @override
  Map<String, bool> isFieldRequiredMap() => {
        "description": true,
        "size": true,
        "comments": false,
        "customer": true,
        "gsm": true,
        "quantity": true,
      };

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    return toJson();
  }

  factory ProductPrintObject.fromJson(Map<String, dynamic> data) =>
      _$ProductPrintObjectFromJson(data);

  Map<String, dynamic> toJson() => _$ProductPrintObjectToJson(this);

  @override
  Map<String, bool> isFieldCanBeNullableMap() => {};
}
