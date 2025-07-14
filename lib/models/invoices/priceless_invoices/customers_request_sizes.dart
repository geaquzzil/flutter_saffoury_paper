import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/invoices/cargo_transporters.dart';
import 'package:flutter_saffoury_paper/models/invoices/invoice_master.dart';
import 'package:flutter_saffoury_paper/models/invoices/invoice_master_details.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_saffoury_paper/models/products/sizes.dart';
import 'package:flutter_saffoury_paper/models/products/warehouse.dart';
import 'package:flutter_saffoury_paper/models/users/customers.dart';
import 'package:flutter_saffoury_paper/models/users/employees.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:json_annotation/json_annotation.dart';

part 'customers_request_sizes.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class CustomerRequestSize extends InvoiceMaster<CustomerRequestSize> {
  List<CustomerRequestSizeDetails>? customers_request_sizes_details;
  int? customers_request_sizes_details_count;

  CustomerRequestSize() : super() {
    customers_request_sizes_details = <CustomerRequestSizeDetails>[];
  }

  @override
  CustomerRequestSize getSelfNewInstance() {
    return CustomerRequestSize();
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      super.getMirrorFieldsMapNewInstance()
        ..addAll({
          "customers_request_sizes_details":
              List<CustomerRequestSizeDetails>.empty(),
          "customers_request_sizes_details_count": 0
        });

  @override
  String? getTableNameApi() => "customers_request_sizes";

  @override
  List<String> getMainFields({BuildContext? context}) =>
      ["customers", "employees", "date", "comments"];
  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.customerRequestSizes;

  factory CustomerRequestSize.fromJson(Map<String, dynamic> data) =>
      _$CustomerRequestSizeFromJson(data);

  Map<String, dynamic> toJson() => _$CustomerRequestSizeToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  CustomerRequestSize fromJsonViewAbstract(Map<String, dynamic> json) =>
      CustomerRequestSize.fromJson(json);

  @override
  List<String>? getRequestedForginListOnCall({required ServerActions action}) {
    return ["customers_request_sizes_details"];
  }
}

@JsonSerializable(explicitToJson: true)
@reflector
class CustomerRequestSizeDetails
    extends InvoiceMasterDetails<CustomerRequestSizeDetails> {
  // int? CustomerReqID;
  // int? SizeID;

  CustomerRequestSize? customers_request_sizes;
  ProductSize? sizes;
  String? date;

  CustomerRequestSizeDetails() : super() {
    date = "".toDateTimeNowString();
  }
  @override
  CustomerRequestSizeDetails getSelfNewInstance() {
    return CustomerRequestSizeDetails();
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() => {
        "customers_request_sizes": CustomerRequestSize(),
        "sizes": ProductSize(),
        "date": ""
      };

  @override
  List<String> getMainFields({BuildContext? context}) => ["sizes", "date"];
  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {
        "date": AppLocalizations.of(context)!.date,
      };
  @override
  Map<String, IconData> getFieldIconDataMap() => {
        "date": getMainIconData(),
      };
  @override
  Map<String, TextInputType?> getTextInputTypeMap() => {
        "date": TextInputType.datetime,
      };

  @override
  String? getMainDrawerGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.customer;


  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.customerRequestSizesDetails;

  @override
  String getMainHeaderTextOnly(BuildContext context) => "$sizes";

  @override
  IconData getMainIconData() => Icons.aspect_ratio;

  @override
  String? getTableNameApi() => "customers_request_sizes_details";

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
  Map<String, bool> isFieldCanBeNullableMap() => {};

  @override
  Map<String, bool> isFieldRequiredMap() => {};

  factory CustomerRequestSizeDetails.fromJson(Map<String, dynamic> data) =>
      _$CustomerRequestSizeDetailsFromJson(data);

  Map<String, dynamic> toJson() => _$CustomerRequestSizeDetailsToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  CustomerRequestSizeDetails fromJsonViewAbstract(Map<String, dynamic> json) =>
      CustomerRequestSizeDetails.fromJson(json);
}
