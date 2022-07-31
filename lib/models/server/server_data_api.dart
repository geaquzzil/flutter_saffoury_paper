import 'package:flutter_saffoury_paper/models/customs/customs_declarations.dart';
import 'package:flutter_saffoury_paper/models/products/grades.dart';
import 'package:flutter_saffoury_paper/models/products/products_types.dart';
import 'package:flutter_saffoury_paper/models/products/qualities.dart';
import 'package:flutter_view_controller/models/servers/server_data.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:json_annotation/json_annotation.dart';
part 'server_data_api.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class FilterableDataApi extends FilterableData<FilterableDataApi> {
  List<ProductType> product_types = [];
  List<Quality> qualities = [];

  List<Grades> grades = [];
  List<CustomsDeclaration> customs_declarations = [];

  FilterableDataApi() : super();
  factory FilterableDataApi.fromJson(Map<String, dynamic> data) =>
      _$ServerDataApiFromJson(data);

  Map<String, dynamic> toJson() => _$ServerDataApiToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  FilterableDataApi fromJsonViewAbstract(Map<String, dynamic> json) =>
      FilterableDataApi.fromJson(json);

  @override
  String? getTableNameApi() => "";
  @override
  String? getCustomAction() => "list_server_data";
}
