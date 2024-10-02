// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_saffoury_paper/models/invoices/cuts_invoices/sizes_cut_requests.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/globals.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_auto_rest_horizontal.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pdf/widgets.dart' as pdf;

part 'sizes.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class ProductSize extends ViewAbstract<ProductSize> {
  int? width;
  int? length;

  ProductSize() : super();
  @override
  ProductSize getSelfNewInstance() {
    return ProductSize();
  }

  @override
  ProductSize? getSelfNewInstanceFileImporter(
      {required BuildContext context, String? field, value}) {
    debugPrint("getSelfNewInstanceFileImporter $runtimeType value=>$value");
    if (value is Map) {
      int? isIntWidth = value is int ? value['width'] : null;
      int? isIntLength = value is int ? value['length'] : null;

      int? lengthMap = isIntLength ?? int.tryParse("${value['length']}");
      int? widthMap = isIntWidth ?? int.tryParse("${value['width']}");

      if (lengthMap == null && widthMap == null) {
        throw Exception(
            "${getMainHeaderLabelTextOnly(context)}: Cannot convert the value of length to =${value['length']} and the value of width to =${value['width']} to a number");
      } else if (lengthMap == null) {
        throw Exception(
            "${getMainHeaderLabelTextOnly(context)}: Cannot convert the value of length to =${value['length']} to a number");
      } else if (widthMap == null) {
        throw Exception(
            "${getMainHeaderLabelTextOnly(context)}: Cannot convert the value of length to =${value['widthMap']} to a number");
      } else {
        width = widthMap;
        length = lengthMap;

        String? errorInWidth =
            getTextInputValidator(context, "width", width.toString());
        String? errorInLength =
            getTextInputValidator(context, "length", length.toString());

        if (errorInLength != null || errorInWidth != null) {
          throw Exception(
              "${getMainHeaderLabelTextOnly(context)}: error on validate one or more field(s)=> $errorInLength , $errorInWidth");
        }
        return this;
      }
    } else {
      throw Exception(
          "${getMainHeaderLabelTextOnly(context)}: ProductSize.getSelfNewInstance is not a Map");
    }
  }

  @override
  String? getMainDrawerGroupName(BuildContext context) {
    return AppLocalizations.of(context)!.product;
  }

  @override
  IconData getMainIconData() {
    return Icons.type_specimen_outlined;
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
  String getMainHeaderTextOnly(BuildContext context) {
    if ((width == null && length == null) || (width == 0 && length == 0)) {
      return "0 X 0";
    }
    if (length == 0 || length == null) {
      return "$width ";
    } else if (width == 0 || width == null) {
      return "0 X $length";
    } else {
      return "$width X $length";
    }
  }

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) {
    return AppLocalizations.of(context)!.size;
  }

  @override
  List<String> getMainFields({BuildContext? context}) {
    return ['width', 'length'];
  }

  @override
  String getForeignKeyName() {
    return "SizeID";
  }

  @override
  Map<String, bool> isFieldRequiredMap() => {"width": true, "length": true};

  @override
  Map<String, TextInputType?> getTextInputTypeMap() => {
        "width": TextInputType.number,
        "length": TextInputType.number,
      };
  @override
  Map<String, int> getTextInputMaxLengthMap() =>
      {"width": 4, "length": 4, "purchasePrice": 8};

  @override
  String? getImageUrl(BuildContext context) {
    return null;
  }

  @override
  String? getTableNameApi() {
    return "sizes";
  }

  @override
  Map<String, IconData> getFieldIconDataMap() => {
        "width": Icons.border_left,
        "length": Icons.border_top,
      };

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {
        "width": AppLocalizations.of(context)!.width,
        "length": AppLocalizations.of(context)!.length,
      };

  @override
  Map<String, bool> getTextInputIsAutoCompleteMap() => {};

  @override
  Map<String, bool> getTextInputIsAutoCompleteViewAbstractMap() => {};

  @override
  Map<String, double> getTextInputMaxValidateMap() {
    int maxWidth = 9999;
    if (parent is SizesCutRequest) {
      maxWidth = (parent as SizesCutRequest).getMaxWidth();
    }

    return {"width": maxWidth.toDouble(), "length": 9999};
  }

  @override
  Map<String, double> getTextInputMinValidateMap() {
    double minLength = 0;
    int minWidth = 10;
    if (parent != null) {
      if (parent is SizesCutRequest) {
        minLength = 100;
        minWidth = (parent as SizesCutRequest).getMinWidth();
      }
    }
    return {"width": minWidth.toDouble(), "length": minLength};
  }

  @override
  Map<String, bool> isFieldCanBeNullableMap() => {};

  factory ProductSize.fromJson(Map<String, dynamic> data) =>
      _$ProductSizeFromJson(data);

  Map<String, dynamic> toJson() => _$ProductSizeToJson(this);

  @override
  ProductSize fromJsonViewAbstract(Map<String, dynamic> json) {
    return ProductSize.fromJson(json);
  }

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    return toJson();
  }

  ///check fiberLines if on the width then return length
  ///
  String getWidth({String? fibrelines}) {
    if (fibrelines == null) {
      return width.toNonNullable().toString();
    }
    if (fibrelines == "Length") {
      return width.toNonNullable().toString();
    } else {
      return length.toNonNullable().toString();
    }
  }

  ///check fiberLines if on the width then return length
  ///
  String getLength({String? fibrelines}) {
    if (fibrelines == null) {
      return length.toNonNullable().toString();
    }
    if (fibrelines == "Length") {
      return length.toNonNullable().toString();
    } else {
      return width.toNonNullable().toString();
    }
  }

  pdf.Widget getSizeTextRichWidget(BuildContext context,
      {String? fiberLines, bool isLabel = false}) {
    if (Globals.isArabic(context)) {
      return pdf.RichText(
        text: pdf.TextSpan(
          text: getWidth(fibrelines: fiberLines),
          style: pdf.TextStyle(
              fontWeight: pdf.FontWeight.bold, fontSize: isLabel ? 10 : 32),
          children: <pdf.TextSpan>[
            pdf.TextSpan(
                text: "${getLength(fibrelines: fiberLines)} X ",
                style: pdf.TextStyle(
                    fontWeight: pdf.FontWeight.bold, fontSize: 42)),
            // TextSpan(text: ' world!'),
          ],
        ),
      );
    } else {
      return pdf.RichText(
        text: pdf.TextSpan(
          text: "${getWidth(fibrelines: fiberLines)} X ",
          style: pdf.TextStyle(
              fontWeight: pdf.FontWeight.bold, fontSize: isLabel ? 10 : 32),
          children: <pdf.TextSpan>[
            pdf.TextSpan(
                text: getLength(fibrelines: fiberLines),
                style: pdf.TextStyle(
                    fontWeight: pdf.FontWeight.bold,
                    fontSize: isLabel ? 12 : 42)),
            // TextSpan(text: ' world!'),
          ],
        ),
      );
    }
  }

  String getSizeHtmlFormatString(BuildContext context, {String? fiberLines}) {
    int widthNon = width.toNonNullable();
    int lengthNon = length.toNonNullable();
    if (length.toNonNullable() == 0) {
      return "$widthNon";
    }
    if (fiberLines == null) {
      return "$widthNon X $lengthNon";
    } else {
      if (fiberLines == "Width") {
        return "<big>$widthNon</big> X $lengthNon";
      } else {
        return "$widthNon X <big>$lengthNon</big>";
      }
    }
  }

  bool isRoll() {
    return length == 0;
  }

  Html getSizeHtmlFormat(BuildContext context, {String? fiberLines}) {
    return Html(
      data: getSizeHtmlFormatString(context, fiberLines: fiberLines),
    );
  }

  @override
  SortFieldValue? getSortByInitialType() =>
      SortFieldValue(field: "width", type: SortByType.ASC);

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      {"width": 0, "length": 0};
}

enum ProductSizeType implements ViewAbstractEnum<ProductSizeType> {
  PALLET,
  REEL;

  @override
  IconData getMainIconData() => Icons.type_specimen;
  @override
  String getMainLabelText(BuildContext context) =>
      AppLocalizations.of(context)!.type;

  @override
  String getFieldLabelString(BuildContext context, ProductSizeType field) {
    switch (field) {
      case PALLET:
        return AppLocalizations.of(context)!.pallet;
      case REEL:
        return AppLocalizations.of(context)!.reel;
    }
  }

  @override
  IconData getFieldLabelIconData(BuildContext context, ProductSizeType field) {
    switch (field) {
      case PALLET:
        return Icons.stacked_line_chart_outlined;
      case REEL:
        return Icons.stacked_line_chart_outlined;
    }
  }

  @override
  List<ProductSizeType> getValues() {
    return ProductSizeType.values;
  }
}
