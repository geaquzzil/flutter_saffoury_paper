import 'package:flutter/src/widgets/icon_data.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_api.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_types.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class ProductType extends ViewAbstract<ProductType> {
  factory ProductType.fromJson(Map<String, dynamic> data) =>
      _$ProductTypeFromJson(data);

  Map<String, dynamic> toJson() => _$ProductTypeToJson(this);

  String? date;
  String? image;
  String? name;
  String? comments;

  ProductType() : super();
  @override
  ProductType fromJsonViewAbstract(Map<String, dynamic> json) {
    // TODO: implement fromJsonViewAbstract
    throw UnimplementedError();
  }

  @override
  String getFieldLabel(String label, BuildContext context) {
    // TODO: implement getFieldLabel
    throw UnimplementedError();
  }

  @override
  List<String> getFields() {
    // TODO: implement getFields
    throw UnimplementedError();
  }

  @override
  IconData getIconData(BuildContext context) {
    // TODO: implement getIconData
    throw UnimplementedError();
  }

  @override
  IconData getIconDataField(String label, BuildContext context) {
    // TODO: implement getIconDataField
    throw UnimplementedError();
  }

  @override
  String? getTableNameApi() {
    // TODO: implement getTableNameApi
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    // TODO: implement toJsonViewAbstract
    throw UnimplementedError();
  }
}
