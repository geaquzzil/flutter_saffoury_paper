import 'package:flutter/src/widgets/icon_data.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/services/text_input.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/models/prints/printer_options.dart';
import 'package:flutter_view_controller/models/prints/report_options.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

import '../funds/money_funds.dart';
import '../products/products.dart';

part 'print_product_list.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class PrintProductList extends PrintLocalSetting<PrintProductList> {
  bool? hideDate;
  bool? hideQuantity;
  bool? hideWarehouse;
  bool? skipOutOfStock;
  bool? hideUnitPriceAndTotalPrice;

  String? sortByField;
  SortByType? sortByType;

  @JsonKey(ignore: true)
  Product? product;

  PrintProductList() : super();

  @override
  String? getPrintableSortByName() => sortByField;

  @override
  SortByType getPrintableHasSortBy() => sortByType ?? SortByType.ASC;

  @override
  PrintProductList getSelfNewInstance() {
    return PrintProductList();
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      super.getMirrorFieldsMapNewInstance()
        ..addAll({
          "hideDate": false,
          "hideQuantity": false,
          "hideWarehouse": false,
          "skipOutOfStock": false,
          "hideUnitPriceAndTotalPrice": false,
        });

  @override
  List<String> getMainFields({BuildContext? context}) =>
      super.getMainFields(context: context)
        ..addAll([
          "hideDate",
          "hideWarehouse",
          "hideQuantity",
          "hideUnitPriceAndTotalPrice",
          "sortByField",
          "sortByType",
          "skipOutOfStock",
        ]);

  @override
  Map<String, List> getTextInputIsAutoCompleteCustomListMap(
          BuildContext context) =>
      {
        "sortByField": product
                ?.getSelfNewInstance()
                .getPrintableSelfListTableHeaderAndContent(
                    context, product, this)
                .keys
                .toList() ??
            []
      };
  @override
  String getTextCheckBoxDescription(BuildContext context, String field) {
    if (field == "hideDate") {
      return AppLocalizations.of(context)!.hideDateDes;
    } else if (field == "hideWarehouse") {
      return AppLocalizations.of(context)!.hideWarehouseDes;
    } else if (field == "hideQuantity") {
      return AppLocalizations.of(context)!.hideQuantityDes;
    } else if (field == "skipOutOfStock") {
      return AppLocalizations.of(context)!.skipOutofStockDes;
    } else if (field == "hideUnitPriceAndTotalPrice") {
      return AppLocalizations.of(context)!.hideInvoiceUnitAndTotalPriceDes;
    }
    return super.getTextCheckBoxDescription(context, field);
  }

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) =>
      super.getFieldLabelMap(context)
        ..addAll({
          "hideDate": AppLocalizations.of(context)!.hideDate,
          "hideWarehouse": AppLocalizations.of(context)!.hideWarehouse,
          "hideQuantity": AppLocalizations.of(context)!.hideQuantityDes,
          "skipOutOfStock": AppLocalizations.of(context)!.skipOutofStock,
          "hideUnitPriceAndTotalPrice":
              AppLocalizations.of(context)!.hideInvoiceUnitAndTotalPrice,
        });
  @override
  Map<String, IconData> getFieldIconDataMap() => {};

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) => "";

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
  Map<String, TextInputType?> getTextInputTypeMap() => {};

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();
  @override
  PrintProductList fromJsonViewAbstract(Map<String, dynamic> json) =>
      PrintProductList.fromJson(json);

  factory PrintProductList.fromJson(Map<String, dynamic> data) =>
      _$PrintProductListFromJson(data);

  Map<String, dynamic> toJson() => _$PrintProductListToJson(this);

  @override
  PrintProductList onSavedModiablePrintableLoaded(
      BuildContext context, ViewAbstract viewAbstractThatCalledPDF) {
    debugPrint(
        "onSavedModiablePrintableLoaded ${viewAbstractThatCalledPDF.runtimeType}");
    product = viewAbstractThatCalledPDF as Product;
    return this;
  }
}
