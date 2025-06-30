// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_saffoury_paper/models/invoices/cuts_invoices/sizes_cut_requests.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/globals.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/request_options.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_view_abstract_new.dart';
import 'package:flutter_view_controller/printing_generator/ext.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pdf/pdf.dart' as pdf2;
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
      SliverApiMixinViewAbstractWidget(
          isGridView: true,
          scrollDirection: Axis.horizontal,
          toListObject: Product().getSelfInstanceWithSimilarOption(context: context,
              obj: this, copyWith: RequestOptions(countPerPage: 5))),
    ];
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
      {String? fiberLines, pdf2.PdfPageFormat? format}) {
    bool isArabic = Globals.isArabic(context);
    bool isLabel = printableIsLabel(format: format);
    String? length = isRoll()
        ? null
        : isArabic
            ? "${getLength(fibrelines: fiberLines)} X "
            : getLength(fibrelines: fiberLines);

    String width = isArabic
        ? getWidth(fibrelines: fiberLines)
        : isRoll()
            ? getWidth(fibrelines: fiberLines)
            : "${getWidth(fibrelines: fiberLines)} X ";

    return pdf.RichText(
      text: pdf.TextSpan(
        text: width,
        style: pdf.TextStyle(
            fontWeight: pdf.FontWeight.bold,
            fontSize: printableFindTextSize(format: format)),
        children: length == null
            ? null
            : <pdf.TextSpan>[
                pdf.TextSpan(
                    text: length,
                    style: pdf.TextStyle(
                        fontWeight: pdf.FontWeight.bold,
                        fontSize: printableFindTextSize(format: format) +
                            (isLabel ? 5 : 10))),
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

  bool isRoll() {
    return length == 0;
  }

  Html getSizeHtmlFormat(BuildContext context, {String? fiberLines}) {
    return Html(
      data: getSizeHtmlFormatString(context, fiberLines: fiberLines),
    );
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      {"width": 0, "length": 0};

  @override
  List<String>? getRequestedForginListOnCall({required ServerActions action}) {
    return null;
  }

  @override
  RequestOptions? getRequestOption({required ServerActions action}) {
    return RequestOptions(
        sortBy: SortFieldValue(field: "width", type: SortByType.ASC));
  }

  Map<int, FromToBetweenRequest> _generate(int initialValue,
      {int maxWaste = 100, int maxMin = 20}) {
    var list = List<int>.empty(growable: true);
    Map<int, FromToBetweenRequest> map = {};

    int sugg = initialValue;
    int idx = 1;
    do {
      int w = (idx * initialValue);
      list.add(w + maxWaste);
      list.add(w - maxMin);

      map[idx] = FromToBetweenRequest(
          from: w.toString(), to: (w + maxWaste).toString());
      sugg = w;
      idx = idx + 1;
    } while (sugg > 3000);

    return map;
  }

  List<List<BetweenRequest>> getListOfSizesWithMaxWaste(
      {ProductSize? customSize, int maxWaste = 100, int maxMin = 20}) {
    List<List<BetweenRequest>> main = List.empty(growable: true);
    var lengthList = isRoll()
        ? {}
        : _generate(customSize?.length ?? length.toNonNullable(),
            maxWaste: maxWaste, maxMin: maxMin);
    var widthList = _generate(customSize?.width ?? width.toNonNullable(),
        maxWaste: maxWaste, maxMin: maxMin);

    widthList.forEach(
      (key, value) {
        bool containsLength = false;
        List<BetweenRequest> v = List.empty(growable: true);
        v.add(BetweenRequest(field: "width", fromTo: [value]));
        if (lengthList.containsKey(key)) {
          containsLength = true;
          v.add(BetweenRequest(field: "length", fromTo: [lengthList[key]]));
        } else {
          v.add(BetweenRequest(
              field: "length",
              fromTo: [FromToBetweenRequest(from: "0", to: "0")]));
        }

        main.add(v);
        if (containsLength) {
          main.add(List.of([
            BetweenRequest(field: "width", fromTo: [value]),
            BetweenRequest(
                field: "length",
                fromTo: [FromToBetweenRequest(from: "0", to: "0")])
          ]));
        }
      },
    );
    debugPrint(main.toString());
    return main;
  }
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
