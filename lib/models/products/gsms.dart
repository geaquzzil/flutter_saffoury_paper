import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_saffoury_paper/models/server/server_data_api.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/servers/server_data.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_auto_rest_horizontal.dart';
import 'package:flutter_view_controller/providers/filterables/fliterable_list_provider_api.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:provider/provider.dart';

part 'gsms.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class GSM extends ViewAbstract<GSM> {
  int? gsm;

  List<Product>? products;
  int? products_count;

  GSM() : super();

  @override
  GSM getSelfNewInstance() {
    return GSM();
  }

  @override
  List<Widget>? getCustomBottomWidget(BuildContext context,
      {ServerActions? action,
      ValueNotifier<ViewAbstract?>? onHorizontalListItemClicked}) {
    if (action == ServerActions.add ||
        action == ServerActions.edit ||
        action == ServerActions.list) {
      return null;
    }
    return [
      ListHorizontalApiAutoRestWidget(
        valueNotifier: onHorizontalListItemClicked,
        titleString: AppLocalizations.of(context)!
            .moreFromFormat(getMainHeaderTextOnly(context)),
        autoRest: AutoRest<Product>(
            range: 5,
            obj: Product()..setCustomMap(getSimilarCustomParams(context)),
            key: "similarProducts${getSimilarCustomParams(context)}"),
      ),
    ];
  }

  Map<String, String> getSimilarCustomParams(BuildContext context) {
    Map<String, String> hashMap = getCustomMap;
    hashMap["<${getForeignKeyName()}>"] = ("$iD");
    return hashMap;
  }

  @override
  GSM? getSelfNewInstanceFileImporter(
      {required BuildContext context, String? field, value}) {
    if (value == null) return null;
    FilterableDataApi? filterData = context
        .read<FilterableListApiProvider<FilterableData>>()
        .getLastFilterableData() as FilterableDataApi?;
    if (value == null) {
      return null;
    }
    if (filterData != null) {
      GSM? getSearchedValue = filterData.searchForValue(
        this,
        value,
        (p0) => p0.gsm.toString() == value.toString(),
      );
      if (getSearchedValue != null) {
        return getSearchedValue;
      }
    }
    int? gs = int.tryParse(value.toString());
    if (gs != null) {
      iD = -1;
      gsm = gs;
      return this;
    } else {
      throw Exception(
          "${getMainHeaderLabelTextOnly(context)}: Cannot convert value of gsm to => $value to a number");
    }
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      {"products": List<Product>.empty(), "products_count": 0, "gsm": 0};

  @override
  String getForeignKeyName() {
    return "GSMID";
  }

  @override
  String? getMainDrawerGroupName(BuildContext context) {
    return AppLocalizations.of(context)!.product;
  }

  @override
  IconData getMainIconData() {
    return Icons.view_headline;
  }

  @override
  String getMainHeaderTextOnly(BuildContext context) {
    return gsm == null ? "-" : gsm.toString();
  }

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) {
    return AppLocalizations.of(context)!.gsm;
  }

  @override
  List<String> getMainFields({BuildContext? context}) {
    return ['gsm'];
  }

  @override
  Map<String, bool> isFieldRequiredMap() => {"gsm": true};

  @override
  Map<String, TextInputType?> getTextInputTypeMap() => {
        "gsm": TextInputType.number,
      };
  @override
  Map<String, int> getTextInputMaxLengthMap() => {"gsm": 4};

  @override
  String? getImageUrl(BuildContext context) {
    return null;
  }

  @override
  String? getTableNameApi() {
    return "gsms";
  }

  @override
  Map<String, IconData> getFieldIconDataMap() => {
        "gsm": Icons.line_weight,
      };

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {
        "gsm": AppLocalizations.of(context)!.gsm,
      };

  @override
  Map<String, bool> getTextInputIsAutoCompleteMap() => {};

  @override
  Map<String, bool> getTextInputIsAutoCompleteViewAbstractMap() =>
      {"gsm": true};

  @override
  Map<String, double> getTextInputMaxValidateMap() => {};

  @override
  Map<String, double> getTextInputMinValidateMap() => {};

  @override
  Map<String, bool> isFieldCanBeNullableMap() => {};

  factory GSM.fromJson(Map<String, dynamic> data) => _$GSMFromJson(data);

  Map<String, dynamic> toJson() => _$GSMToJson(this);

  @override
  GSM fromJsonViewAbstract(Map<String, dynamic> json) {
    return GSM.fromJson(json);
  }

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    return toJson();
  }

  @override
  String getSortByFieldName() {
    return "gsm";
  }

  @override
  SortByType getSortByType() {
    return SortByType.ASC;
  }
}
