import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/ext_utils.dart';
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
  String? getMainDrawerGroupName(BuildContext context) {
    return AppLocalizations.of(context)!.product;
  }

  @override
  IconData getMainIconData() {
    return Icons.type_specimen_outlined;
  }

  @override
  String getMainHeaderTextOnly(BuildContext context) {
    return "$width X $length";
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
  Map<String, bool> getTextInputIsAutoCompleteMap() =>
      // {"width": true, "length": true};
      {};

  @override
  Map<String, bool> getTextInputIsAutoCompleteViewAbstractMap() => {};

  @override
  Map<String, double> getTextInputMaxValidateMap() => {};

  @override
  Map<String, double> getTextInputMinValidateMap() => {"width": 10};

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
  String getWidth(String? fibrelines) {
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
  String getLength(String? fibrelines) {
    if (fibrelines == null) {
      return length.toNonNullable().toString();
    }
    if (fibrelines == "Length") {
      return length.toNonNullable().toString();
    } else {
      return width.toNonNullable().toString();
    }
  }

  pdf.Widget getSizeTextRichWidget(BuildContext context, {String? fiberLines}) {
    return pdf.RichText(
      text: pdf.TextSpan(
        text: "${getWidth(fiberLines)} X ",
        style: pdf.TextStyle(fontWeight: pdf.FontWeight.bold, fontSize: 32),
        children: <pdf.TextSpan>[
          pdf.TextSpan(
              text: getLength(fiberLines),
              style:
                  pdf.TextStyle(fontWeight: pdf.FontWeight.bold, fontSize: 42)),
          // TextSpan(text: ' world!'),
        ],
      ),
    );
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

  Html getSizeHtmlFormat(BuildContext context, {String? fiberLines}) {
    return Html(
      data: getSizeHtmlFormatString(context, fiberLines: fiberLines),
    );
  }

  @override
  String getSortByFieldName() {
    return "width";
  }

  @override
  SortByType getSortByType() {
    return SortByType.ASC;
  }

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
