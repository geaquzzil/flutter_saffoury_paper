import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_view_controller/models/request_options.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/slivers_widget/sliver_custom_scroll_widget.dart';
import 'package:sliver_tools/sliver_tools.dart';

class ProductCalculater extends ViewAbstract<ProductCalculater> {
  Product product;

  ProductCalculater({required this.product}) : super();

  @override
  ProductCalculater fromJsonViewAbstract(Map<String, dynamic> json) {
    // TODO: implement fromJsonViewAbstract
    throw UnimplementedError();
  }

  @override
  Map<String, IconData> getFieldIconDataMap() {
    // TODO: implement getFieldIconDataMap
    throw UnimplementedError();
  }

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) {
    // TODO: implement getFieldLabelMap
    throw UnimplementedError();
  }

  @override
  String? getMainDrawerGroupName(BuildContext context) {
    // TODO: implement getMainDrawerGroupName
    throw UnimplementedError();
  }

  @override
  List<String> getMainFields({BuildContext? context}) {
    // TODO: implement getMainFields
    throw UnimplementedError();
  }

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) {
    return product.getMainHeaderLabelTextOnly(context);
  }

  @override
  String getMainHeaderTextOnly(BuildContext context) {
    return product.getMainHeaderTextOnly(context);
  }

  @override
  IconData getMainIconData() {
    // TODO: implement getMainIconData
    throw UnimplementedError();
  }

  @override
  ProductCalculater getSelfNewInstance() {
    // TODO: implement getSelfNewInstance
    throw UnimplementedError();
  }

  @override
  SortFieldValue? getSortByInitialType() {
    // TODO: implement getSortByInitialType
    throw UnimplementedError();
  }

  @override
  String? getTableNameApi() {
    // TODO: implement getTableNameApi
    throw UnimplementedError();
  }

  @override
  Map<String, bool> getTextInputIsAutoCompleteMap() {
    // TODO: implement getTextInputIsAutoCompleteMap
    throw UnimplementedError();
  }

  @override
  Map<String, bool> getTextInputIsAutoCompleteViewAbstractMap() {
    // TODO: implement getTextInputIsAutoCompleteViewAbstractMap
    throw UnimplementedError();
  }

  @override
  Map<String, int> getTextInputMaxLengthMap() {
    // TODO: implement getTextInputMaxLengthMap
    throw UnimplementedError();
  }

  @override
  Map<String, double> getTextInputMaxValidateMap() {
    // TODO: implement getTextInputMaxValidateMap
    throw UnimplementedError();
  }

  @override
  Map<String, double> getTextInputMinValidateMap() {
    // TODO: implement getTextInputMinValidateMap
    throw UnimplementedError();
  }

  @override
  Map<String, TextInputType?> getTextInputTypeMap() {
    // TODO: implement getTextInputTypeMap
    throw UnimplementedError();
  }

  @override
  Map<String, bool> isFieldCanBeNullableMap() {
    // TODO: implement isFieldCanBeNullableMap
    throw UnimplementedError();
  }

  @override
  Map<String, bool> isFieldRequiredMap() {
    // TODO: implement isFieldRequiredMap
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    // TODO: implement toJsonViewAbstract
    throw UnimplementedError();
  }

  @override
  RequestOptions? getRequestOption({required ServerActions action}) {
    // TODO: implement getRequestOption
    throw UnimplementedError();
  }

  @override
  List<String>? getRequestedForginListOnCall({required ServerActions action}) {
    // TODO: implement getRequestedForginListOnCall
    throw UnimplementedError();
  }
}

class ProductCalculaterWidget extends StatelessWidget {
  const ProductCalculaterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiSliver(
      children: [],
    );
  }
}
