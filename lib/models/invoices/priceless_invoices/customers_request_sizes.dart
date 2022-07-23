import 'package:flutter/material.dart';
import 'package:flutter/src/services/text_input.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/icon_data.dart';
import 'package:flutter_saffoury_paper/models/invoices/invoice_master.dart';
import 'package:flutter_saffoury_paper/models/products/sizes.dart';
import 'package:flutter_saffoury_paper/models/users/customers.dart';
import 'package:flutter_saffoury_paper/models/users/employees.dart';
import 'package:flutter_view_controller/models/va_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
part 'customers_request_sizes.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class CustomerRequestSize extends InvoiceMaster<CustomerRequestSize> {
  List<CustomerRequestSizeDetails>? customers_request_sizes_details;
  int? customers_request_sizes_details_count;

  CustomerRequestSize() : super();
  @override
  String? getTableNameApi() => "customers_request_sizes";

  @override
  List<String>? requireObjectsList() => ["customers_request_sizes_details"];

  @override
  List<String> getMainFields() =>
      ["customers", "employees", "date", "comments"];
  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.customerRequestSizes;

  @override
  CustomerRequestSize fromJsonViewAbstract(Map<String, dynamic> json) {
    // TODO: implement fromJsonViewAbstract
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    // TODO: implement toJsonViewAbstract
    throw UnimplementedError();
  }
}

@JsonSerializable(explicitToJson: true)
@reflector
class CustomerRequestSizeDetails
    extends ViewAbstract<CustomerRequestSizeDetails> {
  int? CustomerReqID;
  int? SizeID;

  CustomerRequestSize? customers_request_sizes;
  Size? sizes;
  String? date;

  CustomerRequestSizeDetails() : super();

  @override
  List<String> getMainFields() => ["sizes", "date"];
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
  String? getSortByFieldName() => "date";

  @override
  SortByType getSortByType() => SortByType.DESC;

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

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    // TODO: implement toJsonViewAbstract
    throw UnimplementedError();
  }

  @override
  CustomerRequestSizeDetails fromJsonViewAbstract(Map<String, dynamic> json) {
    // TODO: implement fromJsonViewAbstract
    throw UnimplementedError();
  }
}
