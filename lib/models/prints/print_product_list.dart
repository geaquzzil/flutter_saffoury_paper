import 'package:flutter/material.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/models/prints/printer_options.dart';
import 'package:flutter_view_controller/models/prints/report_options.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:json_annotation/json_annotation.dart';

import '../products/products.dart';

part 'print_product_list.g.dart';

//todo disable some settings on inventory process
///Disable hidQuantiy
///Disable wareHouse
///Disable
///Disable Date
@JsonSerializable(explicitToJson: true)
@reflector
class PrintProductList extends PrintLocalSetting<PrintProductList> {
  bool? hideDate;
  bool? hideQuantity;
  bool? hideWarehouse;
  bool? skipOutOfStock;
  bool? hideUnitPriceAndTotalPrice;

  String? sortByField;
  String? groupedByField;
  SortByType? sortByType;

  @JsonKey(includeFromJson: false, includeToJson: false)
  Product? product;

  PrintProductList() : super();

  @override
  String? getPrintableSortByName(BuildContext context) => sortByField;

  @override
  String? getPrintableGroupByName() => groupedByField;

  @override
  SortByType getPrintableHasSortBy() => sortByType ?? SortByType.ASC;

  @override
  PrintProductList getSelfNewInstance() {
    return PrintProductList();
  }

  // @override
  // List<TabControllerHelper> getCustomTabList(BuildContext context,
  //     {ServerActions? action}) {
  //   return [
  //     TabControllerHelper(
  //       AppLocalizations.of(context)!.findSimilar,
  //       widget: ListApiAutoRestWidget(
  //         autoRest: AutoRest<Order>(
  //             obj: Order()..setCustomMap({"<CustomerID>": ""}),
  //             key: "CustomerByOrder"),
  //       ),
  //     ),

  //     //  ChartItem(
  //     //   autoRest: AutoRest<Order>(
  //     //     obj: Order()..setCustomMap({"<CustomerID>": "${customers?.iD}"}),
  //     //     key: "CustomerByOrder$iD"),
  //     // ),
  //   ];
  // }

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
          "skipOutOfStock",
          "groupedByField",
          "sortByField",
          "sortByType",
        ]);

  @override
  Map<String, IconData> getFieldIconDataMap() => super.getFieldIconDataMap()
    ..addAll({"sortByField": Icons.sort, "groupedByField": Icons.group_work});

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
            [],
        "groupedByField": product
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
          "sortByField": AppLocalizations.of(context)!.sortBy,
          //todo translate
          "groupedByField": "Group by todo"
        });

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
