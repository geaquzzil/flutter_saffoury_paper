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
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
part 'print_product_object.g.dart';

@JsonSerializable(
  explicitToJson: true,
)
@reflector
class ProductPrintObject extends ViewAbstract<ProductPrintObject> {
  String description = "";
  GSM gsm;
  ProductSize size;

  String comments = "";
  String customer = "";
  double quantity = 0;
  double sheets = 0;

  ProductPrintObject(this.size, this.gsm);
  @override
  List<String> getMainFields({BuildContext? context}) {
    return [
      "description",
      "customer",
      "size",
      "gsm",
      "quantity",
      "sheets",
      "comments",
    ];
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() => {
        "description": "",
        "size": ProductSize(),
        "comments": "",
        "customer": "",
        "gsm": GSM(),
        "quantity": 0.0,
        "sheets": 0.0
      };

  @override
  ProductPrintObject fromJsonViewAbstract(Map<String, dynamic> json) {
    return ProductPrintObject.fromJson(json);
  }

  @override
  Map<String, IconData> getFieldIconDataMap() => {
        "description": Icons.abc,
        "date": Icons.date_range,
        "sheets": Icons.line_weight_outlined,
        "comments": Icons.notes,
        "customer": Icons.account_circle,
        "quantity": Icons.scale
      };

  @override
  void onTextChangeListener(BuildContext context, String field, String? value,
      {GlobalKey<FormBuilderState>? formKey}) {
    super.onTextChangeListener(context, field, value);

    if (field == "quantity") {
      // setFieldValue(field, double.tryParse(value ?? "0") ?? 0);

      Product p = Product()
        ..sizes = size
        ..gsms = gsm;

      sheets = p.getSheets(customQuantity: quantity);
      debugPrint("sheets : $sheets");
      setFieldValue("sheets", sheets);

      notifyOtherControllers(
          context: context, formKey: formKey, notifySpecificField: "sheets");
    }
  }

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {
        "description": AppLocalizations.of(context)!.product_type,
        'date': AppLocalizations.of(context)!.date,
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
    return ProductPrintObject(ProductSize(), GSM());
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
  Map<String, int> getTextInputMaxLengthMap() => {};

  @override
  Map<String, double> getTextInputMaxValidateMap() => {};

  @override
  Map<String, double> getTextInputMinValidateMap() => {};

  @override
  Map<String, TextInputType?> getTextInputTypeMap() => {
        "quantity": TextInputType.number,
        "date": TextInputType.datetime,
        "products_types": TextInputType.number,
        "comments": TextInputType.multiline,
        "customer": TextInputType.multiline,
        "sheets": TextInputType.number,
      };

  @override
  Map<String, bool> isFieldCanBeNullableMap() => {
        "gsms": true,
      };

  @override
  Map<String, bool> isFieldRequiredMap() => {
        "description": true,
        "size": true,
        "comments": false,
        "customer": true,
        "gsm": true,
        "quantity": true,
        "sheets": true,
      };

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    return toJson();
  }

  factory ProductPrintObject.fromJson(Map<String, dynamic> data) =>
      _$ProductPrintObjectFromJson(data);

  Map<String, dynamic> toJson() => _$ProductPrintObjectToJson(this);
}
