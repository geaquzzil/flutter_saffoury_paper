import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_saffoury_paper/models/invoices/cuts_invoices/cut_requests.dart';
import 'package:flutter_saffoury_paper/models/products/sizes.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/request_options.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sizes_cut_requests.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class SizesCutRequest extends ViewAbstract<SizesCutRequest> {
  // int? CutRequestID;
  // int? SizeID;

  CutRequest? cut_requests;
  ProductSize? sizes;
  double? quantity;

  SizesCutRequest() : super() {
    // sizes = ProductSize();
  }

  @override
  SizesCutRequest getSelfNewInstance() {
    return SizesCutRequest();
  }

  Widget getTitleTextHtml(BuildContext context, CutRequest item,
      {bool withProductType = false}) {
    String? productType = withProductType
        ? item.products?.products_types?.getMainHeaderTextOnly(context)
        : "";
    String? size =
        sizes?.getSizeHtmlFormatString(context, fiberLines: "Length");
    String? gsm = item.products?.gsms?.getMainHeaderTextOnly(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Html(
        data: "$productType $size X $gsm",
        // style: {
        //   "direction":
        // },

        // style:{

        //   "body":Theme.of(context).textTheme.bodySmall
        // }
      ),
    );
  }

  String? getQuantity(BuildContext context) {
    return AppLocalizations.of(context)!.kg_format(quantity.toCurrencyFormat());
  }

  String? getSheets(BuildContext context, CutRequest item) {
    // item.products
    //     ?.getSheets(customSize: sizes, customQuantity: quantity)
    //     .toCurrencyFormat();
    return AppLocalizations.of(context)!.sheets_string_f(item.products
        ?.getSheets(customSize: sizes, customQuantity: quantity)
        .toCurrencyFormat() as Object);
  }

  Widget getQunaityWithSheets(BuildContext context, CutRequest item) {
    return Html(style: {
      "body": Style(
        fontSize: FontSize(12.0),
        // fontWeight: FontWeight.bold,
        // color: item.getCutStatusColor()
      ),
    }, data: "<big>${getSheets(context, item)}/${getQuantity(context)}</big>");
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() => {
        "cut_requests": CutRequest(),
        "sizes": ProductSize(),
        "quantity": 0.toDouble()
      };
  @override
  List<String> getMainFields({BuildContext? context}) => ["sizes", "quantity"];

  @override
  Map<String, IconData> getFieldIconDataMap() => {"quantity": Icons.scale};

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) =>
      {"quantity": AppLocalizations.of(context)!.quantity};

  @override
  String? getMainDrawerGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.invoice;

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.requestedSizeLabel;
  @override
  String getMainHeaderTextOnly(BuildContext context) =>
      "${sizes?.getMainHeaderTextOnly(context)}";
  @override
  IconData getMainIconData() => Icons.screen_rotation_alt_sharp;

  @override
  String? getTableNameApi() => "sizes_cut_requests";

  @override
  Map<String, bool> getTextInputIsAutoCompleteMap() => {};

  @override
  Map<String, bool> getTextInputIsAutoCompleteViewAbstractMap() => {};

  @override
  Map<String, int> getTextInputMaxLengthMap() => {"quantity": 10};

  @override
  Map<String, double> getTextInputMaxValidateMap() {
    debugPrint(
        "getTextInputMaxValidateMap parent is ${parent.runtimeType}  quantity is ${(parent as CutRequest).quantity}");

    return {"quantity": (parent as CutRequest).quantity ?? 0};
  }

  @override
  List<Widget>? getCustomTopWidget(BuildContext context,
      {ServerActions? action,
      ValueNotifier<ViewAbstract?>? onHorizontalListItemClicked,
      ValueNotifier<SecondPaneHelper?>? onClick}) {
    if (isNew()) {
      if (parent is CutRequest) {
        if ((parent as CutRequest).products == null) {
          [
            MaterialBanner(
                content: Text(AppLocalizations.of(context)!.errFieldNotSelected(
                    AppLocalizations.of(context)!.product)),
                actions: const [])
          ];
        }
      }
    }
    return null;
  }

  int getMaxWidth() {
    return (parent as CutRequest).findMaxWidth();
  }

  int getMinWidth() {
    return (parent as CutRequest).findMinWidth();
  }

  @override
  Map<String, double> getTextInputMinValidateMap() => {};

  @override
  Map<String, TextInputType?> getTextInputTypeMap() =>
      {"quantity": TextInputType.number};

  @override
  Map<String, bool> isFieldCanBeNullableMap() => {};

  @override
  Map<String, bool> isFieldRequiredMap() => {};

  factory SizesCutRequest.fromJson(Map<String, dynamic> data) =>
      _$SizesCutRequestFromJson(data);

  Map<String, dynamic> toJson() => _$SizesCutRequestToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  SizesCutRequest fromJsonViewAbstract(Map<String, dynamic> json) =>
      SizesCutRequest.fromJson(json);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SizesCutRequest &&
          runtimeType == other.runtimeType &&
          sizes?.width == other.sizes?.width;

  @override
  int get hashCode => sizes?.width.hashCode ?? super.hashCode;

  @override
  RequestOptions? getRequestOption({required ServerActions action}) {
    return RequestOptions().addSortBy("iD", SortByType.ASC);
  }

  @override
  List<String>? getRequestedForginListOnCall({required ServerActions action}) {
    return null;
  }
}
