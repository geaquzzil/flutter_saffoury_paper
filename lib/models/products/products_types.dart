// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/products/grades.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_saffoury_paper/models/server/server_data_api.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/interfaces/web/category_gridable_interface.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/request_options.dart';
import 'package:flutter_view_controller/models/servers/server_data.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/models/view_abstract_inputs_validaters.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_api_master_new.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_view_abstract_new.dart';
import 'package:flutter_view_controller/providers/filterables/fliterable_list_provider_api.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:provider/provider.dart';

part 'products_types.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class ProductType extends ViewAbstract<ProductType>
    implements WebCategoryGridableInterface<ProductType> {
  // int? GradeID;

  String? name;
  ProductTypeUnit? unit;

  double? purchasePrice;
  double? sellPrice;

  String? image;
      @JsonKey(fromJson: convertToStringFromString)
  String? comments;
  double? availability;

  Grades? grades;

  List<Product>? products;
  int? products_count;

  @JsonKey(includeToJson: true, includeFromJson: false)
  bool requestAvailablity = false;
  ProductType() : super();
  @override
  ProductType getSelfNewInstance() {
    return ProductType();
  }

  ProductType.init(this.requestAvailablity);

  @override
  ProductType? getSelfNewInstanceFileImporter({
    required BuildContext context,
    String? field,
    value,
  }) {
    debugPrint("getSelfNewInstanceFileImporter $runtimeType value=>$value");
    FilterableDataApi? filterData =
        context
                .read<FilterableListApiProvider<FilterableData>>()
                .getLastFilterableData()
            as FilterableDataApi?;
    if (value == null) {
      throw Exception(
        "${getMainHeaderLabelTextOnly(context)}: Cannot be empty",
      );
    }
    if (filterData != null) {
      ProductType? getSearchedValue = filterData.searchForValue(
        this,
        value,
        (p0) =>
            p0.name == value.toString() || p0.iD.toString() == value.toString(),
      );
      if (getSearchedValue != null) {
        return getSearchedValue;
      }
    }
    throw Exception(
      "${getMainHeaderLabelTextOnly(context)}: not found for value => $value",
    );
  }

  @override
  List<Widget>? getCustomBottomWidget(
    BuildContext context, {
    ServerActions? action,
    ValueNotifier<ViewAbstract?>? onHorizontalListItemClicked,
  }) {
    if (action == ServerActions.add ||
        action == ServerActions.edit ||
        action == ServerActions.list) {
      return null;
    }
    return [
      SliverApiMixinViewAbstractWidget(
        cardType: CardItemType.grid,
        scrollDirection: Axis.horizontal,
        toListObject: Product().getSelfInstanceWithSimilarOption(
          context: context,
          obj: this,
          copyWith: RequestOptions(countPerPage: 5),
        ),
      ),
    ];
  }

  // @override
  // Future<List<ProductType>?> listCall(
  //     {int? count, int? page, OnResponseCallback? onResponse}) async {
  //   try {
  //     Iterable l = jsonDecode(jsonEncode(availabilityType));
  //     return List<ProductType>.from(
  //         l.map((model) => fromJsonViewAbstract(model)));
  //   } catch (e) {
  //     debugPrint("listCallFake ${e.toString()}");
  //   }
  //   return null;
  // }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() => {
    "name": "",
    "unit": ProductTypeUnit.KG,
    "purchasePrice": 0,
    "sellPrice": 0,
    "image": "",
    "comments": "",
    "availability": 0,
    "grades": Grades(),
    "products": List<Product>.empty(),
    "products_count": 0,
  };

  @override
  String getForeignKeyName() {
    return "ProductTypeID";
  }

  //tODO api
  @override
  List<String>? getCustomAction() {
    if (requestAvailablity) {
      return ["available_product_type"];
    }
    return null;
  }

  @override
  String? getMainDrawerGroupName(BuildContext context) {
    return AppLocalizations.of(context)!.product;
  }

  @override
  IconData getMainIconData() {
    return Icons.stacked_line_chart_outlined;
  }

  @override
  String getMainHeaderTextOnly(BuildContext context) {
    return name ?? "";
  }

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) {
    // ViewAbstract v = context.read<DrawerMenuControllerProvider>().getObject;
    // var d = v.getCustomMap;
    // if (d.containsKey("ASC")) {
    //   String k = d["ASC"]!;
    //   return "${getFieldLabel(context, k)}: ${getFieldValueCheckType(context, k)}";
    // }
    // if (d.containsKey("DESC")) {
    //   String k = d["DESC"]!;
    //   return "${getFieldLabel(context, k)}: ${getFieldValueCheckType(context, k)}";
    // }
    return AppLocalizations.of(context)!.products_type;
  }

  @override
  List<String> getMainFields({BuildContext? context}) {
    return [
      'name',
      'grades',
      'purchasePrice',
      "sellPrice",
      "image",
      "comments",
      "unit",
    ];
  }

  @override
  Map<String, bool> isFieldRequiredMap() => {
    "name": true,
    "sellPrice": true,
    "purchasePrice": true,
  };

  @override
  Map<String, TextInputType?> getTextInputTypeMap() => {
    "name": TextInputType.text,
    "sellPrice": TextInputType.number,
    "purchasePrice": TextInputType.number,
    "comments": TextInputType.multiline,
  };
  @override
  Map<String, int> getTextInputMaxLengthMap() => {
    "name": 50,
    "sellPrice": 8,
    "purchasePrice": 8,
  };
  @override
  bool hasImageLoadButton() {
    return true;
  }

  @override
  String? getImageUrl(BuildContext context) {
    if (image == null) return null;
    if (image?.isEmpty ?? true) return null;
    return "$image";
  }

  @override
  String? getTableNameApi() {
    return "products_types";
  }

  @override
  Map<String, IconData> getFieldIconDataMap() => {
    "name": Icons.text_fields,
    "sellPrice": Icons.price_change,
    "purchasePrice": Icons.price_change,
    "image": Icons.image,
    "comments": Icons.notes,
  };

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {
    "name": AppLocalizations.of(context)!.name,
    "sellPrice": AppLocalizations.of(context)!.sellPrice,
    "purchasePrice": AppLocalizations.of(context)!.purchases_price,
    "image": AppLocalizations.of(context)!.loadImage,
    "comments": AppLocalizations.of(context)!.comments,
  };

  @override
  Map<String, bool> getTextInputIsAutoCompleteMap() => {};

  @override
  Map<String, bool> getTextInputIsAutoCompleteViewAbstractMap() => {
    "name": true,
  };

  @override
  Map<String, double> getTextInputMaxValidateMap() => {};

  @override
  Map<String, double> getTextInputMinValidateMap() => {};

  @override
  Map<String, bool> isFieldCanBeNullableMap() => {"grades": true};

  factory ProductType.fromJson(Map<String, dynamic> data) =>
      _$ProductTypeFromJson(data);

  Map<String, dynamic> toJson() => _$ProductTypeToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  ProductType fromJsonViewAbstract(Map<String, dynamic> json) =>
      ProductType.fromJson(json);

  String getUnit(BuildContext context) {
    if (unit == null) return "-";
    return unit!.getFieldLabelString(context, unit!);
  }

  @override
  ViewAbstract? getWebCategoryGridableIsMasterToList(BuildContext context) {
    return Product().getSelfInstanceWithSimilarOption(
      context: context,
      obj: this,
    );
  }

  @override
  String? getWebCategoryGridableDescription(BuildContext context) {
    return availability?.toCurrencyFormat();
  }

  @override
  ProductType getWebCategoryGridableInterface(BuildContext context) {
    return ProductType.init(true);
  }

  @override
  String getWebCategoryGridableTitle(BuildContext context) {
    return getMainHeaderTextOnly(context);
  }

  @override
  FormFieldControllerType getInputType(String field) {
    if ("name" == field) {
      return FormFieldControllerType.AUTO_COMPLETE_VIEW_ABSTRACT_RESPONSE;
    }
    return field == "grades"
        ? FormFieldControllerType.DROP_DOWN_TEXT_SEARCH_API
        : super.getInputType(field);
  }

  @override
  RequestOptions? getRequestOption({
    required ServerActions action,
    RequestOptions? generatedOptionFromListCall,
  }) {
    return RequestOptions().addSortBy("name", SortByType.ASC);
  }

  @override
  List<String>? getRequestedForginListOnCall({required ServerActions action}) {
    return null;
  }
}

// enum ProductTypeUnit {
//   @JsonValue("KG")
//   KG,
//   @JsonValue("Sheet")
//   Sheet,
//   @JsonValue("Ream")
//   Ream
// }
enum ProductTypeUnit implements ViewAbstractEnum<ProductTypeUnit> {
  KG,
  Sheet,
  Ream;

  @override
  IconData getMainIconData() => Icons.stacked_line_chart_outlined;
  @override
  String getMainLabelText(BuildContext context) =>
      AppLocalizations.of(context)!.status;

  @override
  String getFieldLabelString(BuildContext context, ProductTypeUnit field) {
    switch (field) {
      case KG:
        return AppLocalizations.of(context)!.kg;
      case Sheet:
        return AppLocalizations.of(context)!.sheets;
      case Ream:
        return AppLocalizations.of(context)!.reams;
    }
  }

  @override
  IconData getFieldLabelIconData(BuildContext context, ProductTypeUnit field) {
    switch (field) {
      case KG:
        return Icons.scale;
      case Sheet:
        return Icons.line_weight_rounded;
      case Ream:
        return Icons.table_rows_rounded;
    }
  }

  @override
  List<ProductTypeUnit> getValues() {
    return ProductTypeUnit.values;
  }
}
