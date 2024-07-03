import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/products/warehouse.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_saffoury_paper/models/invoices/cargo_transporters.dart';
import 'package:flutter_saffoury_paper/models/users/customers.dart';
import 'package:flutter_saffoury_paper/models/users/employees.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';

import '../invoice_master.dart';
import '../invoice_master_details.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

part 'products_inputs.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class ProductInput extends InvoiceMaster<ProductInput> {
  // int? WarehouseID;

  List<ProductInputDetails>? products_inputs_details;
  int? products_inputs_details_count;

  Warehouse? warehouse;

  ProductInput() : super() {
    products_inputs_details = <ProductInputDetails>[];
  }

  @override
  ProductInput getSelfNewInstance() {
    return ProductInput();
  }

  @override
  String getForeignKeyName() {
    return "ProductInputID";
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      super.getMirrorFieldsMapNewInstance()
        ..addAll({
          "products_inputs_details": List<ProductInputDetails>.empty(),
          "products_inputs_details_count": 0,
          "warehouse": Warehouse()
        });

  @override
  String? getTableNameApi() => "products_inputs";
  @override
  Map<ServerActions, List<String>>? isRequiredObjectsList() => {
        ServerActions.list: ["products_inputs_details"],
      };

  @override
  List<String> getMainFields({BuildContext? context}) {
    List<String> list = super.getMainFields(context: context);
    list.add("warehouse");
    return list;
  }

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.productsInput;

  factory ProductInput.fromJson(Map<String, dynamic> data) =>
      _$ProductInputFromJson(data);

  Map<String, dynamic> toJson() => _$ProductInputToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  ProductInput fromJsonViewAbstract(Map<String, dynamic> json) =>
      ProductInput.fromJson(json);

  @override
  List<ProductInputDetails> getListableList() {
    return products_inputs_details ?? [];
  }

  // @override
  // void onListableDelete(ProductInputDetails item) {
  //   if (item.isEditing()) {
  //     deletedList ??= [];
  //     item.delete = true;
  //     deletedList?.add(item);
  //   }
  //   products_inputs_details
  //       ?.removeWhere((element) => item.products?.iD == element.products?.iD);
  // }

  // @override
  // void onListableUpdate(ProductInputDetails item) {
  //   try {
  //     ProductInputDetails? d = products_inputs_details!.firstWhereOrNull(
  //       (element) => element.products?.iD == item.products?.iD,
  //     );
  //     d = item;
  //   } catch (e) {}
  // }

  // @override
  // List<ProductInputDetails>? deletedList;

  // @override
  // Product getListablePickObject() {
  //   return Product();
  // }

  // @override
  // void onListableSelectedListAdded(List<ViewAbstract> list) {
  //   List<Product> products = list.cast();
  //   products_inputs_details ??= [];
  //   for (var element in products) {
  //     products_inputs_details!.add(ProductInputDetails()..setProduct(element));
  //   }
  // }
}

@JsonSerializable(explicitToJson: true)
@reflector
class ProductInputDetails extends InvoiceMasterDetails<ProductInputDetails> {
  // int? ProductInputID;
  ProductInput? products_inputs;

  ProductInputDetails() : super();
  @override
  ProductInputDetails getSelfNewInstance() {
    return ProductInputDetails();
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      super.getMirrorFieldsMapNewInstance()
        ..addAll({
          "products_inputs": ProductInput(),
        });

  @override
  List<String> getMainFields({BuildContext? context}) =>
      ["products", "quantity", "comments"];
  @override
  String? getTableNameApi() => "products_inputs_details";

  factory ProductInputDetails.fromJson(Map<String, dynamic> data) =>
      _$ProductInputDetailsFromJson(data);

  Map<String, dynamic> toJson() => _$ProductInputDetailsToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  ProductInputDetails fromJsonViewAbstract(Map<String, dynamic> json) =>
      ProductInputDetails.fromJson(json);
}
