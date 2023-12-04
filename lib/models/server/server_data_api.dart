import 'package:flutter_saffoury_paper/models/cities/countries.dart';
import 'package:flutter_saffoury_paper/models/cities/governorates.dart';
import 'package:flutter_saffoury_paper/models/cities/manufactures.dart';
import 'package:flutter_saffoury_paper/models/customs/customs_declarations.dart';
import 'package:flutter_saffoury_paper/models/funds/accounts/account_names.dart';
import 'package:flutter_saffoury_paper/models/funds/currency/currency.dart';
import 'package:flutter_saffoury_paper/models/invoices/cargo_transporters.dart';
import 'package:flutter_saffoury_paper/models/products/grades.dart';
import 'package:flutter_saffoury_paper/models/products/gsms.dart';
import 'package:flutter_saffoury_paper/models/products/products_types.dart';
import 'package:flutter_saffoury_paper/models/products/qualities.dart';
import 'package:flutter_saffoury_paper/models/products/warehouse.dart';
import 'package:flutter_saffoury_paper/models/users/customers.dart';
import 'package:flutter_saffoury_paper/models/users/employees.dart';
import 'package:flutter_view_controller/models/servers/server_data.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:json_annotation/json_annotation.dart';
part 'server_data_api.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class FilterableDataApi extends FilterableData<FilterableDataApi> {
  List<ProductType>? products_types;
  List<Quality>? qualities;

  List<Grades>? grades;
  List<CustomsDeclaration>? customs_declarations;

  List<GSM>? gsms;
  List<CargoTransporter>? cargo_transporters;
  List<Governorate>? governorates;
  List<AccountNameType>? account_names_types;
  List<AccountName>? account_names;
  List<Currency>? currency;
  List<Customer>? customers;
  List<Employee>? employees;
  List<Warehouse>? warehouse;
  List<Country>? countries;
  List<Manufacture>? manufactures;

  FilterableDataApi() : super();

  @override
  FilterableDataApi getSelfNewInstance() {
    return FilterableDataApi();
  }

  factory FilterableDataApi.fromJson(Map<String, dynamic> data) =>
      _$FilterableDataApiFromJson(data);

  Map<String, dynamic> toJson() => _$FilterableDataApiToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  FilterableDataApi fromJsonViewAbstract(Map<String, dynamic> json) =>
      FilterableDataApi.fromJson(json);

  @override
  String? getTableNameApi() => "";
  @override
  String? getCustomAction() => "list_server_data";

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() {
    // TODO: implement getMirrorFieldsMapNewInstance
    throw UnimplementedError();
  }
}
