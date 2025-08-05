import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/custom_views/product_from_excel_printer.dart';
import 'package:flutter_saffoury_paper/models/prints/print_product_list.dart';
import 'package:flutter_saffoury_paper/models/products/gsms.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_saffoury_paper/models/products/products_types.dart';
import 'package:flutter_saffoury_paper/models/products/sizes.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/interfaces/excelable_reader_interface.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/request_options.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:flutter_view_controller/models/view_apstract_stand_alone_without_api.dart';
import 'package:flutter_view_controller/new_screens/file_reader/base_file_reader_page.dart';
import 'package:flutter_view_controller/new_screens/file_reader/file_rader_object_view_abstract.dart';
import 'package:flutter_view_controller/new_screens/file_reader/file_reader_validation.dart';
import 'package:flutter_view_controller/printing_generator/page/pdf_self_list_page.dart';
import 'package:introduction_screen/src/model/page_view_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'excel_to_product_converter.g.dart';

@reflector
@JsonSerializable(explicitToJson: true)
class ExcelToProductConverter
    extends ViewAbstractStandAloneCustomView<ExcelToProductConverter>
    implements ExcelableReaderInteraceCustom {
  String? product;
  @JsonKey(fromJson: convertToDouble)
  int? quantity;
  ExcelToProductConverter();
  factory ExcelToProductConverter.fromJson(Map<String, dynamic> json) =>
      _$ExcelToProductConverterFromJson(json);

  Map<String, dynamic> toJson() => _$ExcelToProductConverterToJson(this);

  @override
  ExcelToProductConverter fromJsonViewAbstract(Map<String, dynamic> json) {
    return ExcelToProductConverter.fromJson(json);
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() => {
    "product": "",
    "quantity": 0,
  };

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    return toJson();
  }

  @override
  List<String> getExcelableFields(BuildContext context) {
    return getMainFields(context: context);
  }

  @override
  List<String> getMainFields({BuildContext? context}) => [
    "product",
    "quantity",
  ];

  @override
  Map<String, bool> isFieldRequiredMap() => {"product": true, "quantity": true};

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {
    "product": AppLocalizations.of(context)!.description,
    "quantity": AppLocalizations.of(context)!.quantity,
  };

  @override
  Map<String, IconData> getFieldIconDataMap() => {
    "product": Icons.abc,
    "quantity": Icons.scale,
  };

  @override
  Widget? getCustomFloatingActionWidget(BuildContext context) => null;

  @override
  Widget getCustomStandAloneWidget(BuildContext context) {
    // return AnimatedSwitcher(
    //     // key: UniqueKey(),
    //     duration: const Duration(milliseconds: 250),
    //     child: FileReaderPage(
    //       viewAbstract: this,
    //     ));
    return FileReaderPage(extras: this);
  }

  @override
  bool getCustomStandAloneWidgetIsPadding() {
    return true;
  }

  @override
  String? getMainDrawerGroupName(BuildContext context) => null;

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.excel;

  @override
  String getMainHeaderTextOnly(BuildContext context) =>
      getMainHeaderLabelTextOnly(context);

  @override
  IconData getMainIconData() => Icons.table_chart;

  @override
  ExcelToProductConverter getSelfNewInstance() => ExcelToProductConverter();
  static int? convertToDouble(dynamic number) =>
      number == null ? 0 : int.tryParse(number.toString());
  @override
  List<PageViewModel> getExceableAddOnList(
    BuildContext context,
    FileReaderObject? validatedObject,
  ) {
    List list = [];
    if (validatedObject != null) {
      list = FileReaderValidationWidget.getDataFromExcelTable(
        context,
        validatedObject,
      );
    }
    debugPrint(
      "getExceableAddOnList validatedObject is null ${validatedObject == null} list is $list",
    );
    List<Product> productList = [];
    for (var element in list) {
      // debugPrint("procces product is $element");
      // var split = element.product.split(RegExp(r'[+-\s]'));
      element.product = element.product
          .replaceAll(".", "")
          .toString()
          .toUpperCase();
      element.product = element.product.toUpperCase();
      //get the first is the product type
      List split = element.product.split(RegExp(r'\d+'));

      debugPrint("procces product $split");
      //get the first is the product type
      split = element.product.split(RegExp(r'\s+'));

      debugPrint("procces product digits $split");

      //if split is length 2 then the first is the product type and the second is size and width;
      String? productType;
      String? productTypeDesc;

      String? comments;
      String? gsm;
      String? length;
      String? width;

      if (split.length == 2) {
        productType = split[0];
        if (productType != null) {
          if (RegExp(r'(F)').hasMatch(productType)) {
            // productType = productType.split(RegExp(r'(F)'))[0].trim();
            comments = "فرزة";
          } else if (RegExp(r'(N)').hasMatch(productType)) {
            // productType = productType.split(RegExp(r'(N)'))[0].trim();
            comments = "نقال";
          } else if (RegExp(r'(S)').hasMatch(productType)) {
            // productType = productType.split(RegExp(r'(S)'))[0].trim();
            comments = "سولفيت";
          } else {
            comments = "";
          }
          productTypeDesc = findProductTypeDesc(productType);
        }

        List size = split[1].split(RegExp(r'X'));
        debugPrint("procces product size $size");
        if (size.length == 3) {
          width = size[0];
          length = size[1];
          gsm = size[2];
        }
        if (size.length == 2) {
          width = size[0];
          length = 0.toString();
          gsm = size[1];
        }
        if (productType != null &&
            gsm != null &&
            width != null &&
            length != null) {
          // continue;
        } else {
          debugPrint(
            "procces product not completed size $size length ${size.length}",
          );
          if (size.length == 1) {
            size = size[0].split(RegExp(r'X'));
            debugPrint("procces product not completed size after split $size");
            if (size.length == 3) {
              width = size[0];
              length = size[1];
              gsm = size[2];
              debugPrint(
                "procces product not completed size try to sucess $size",
              );
            }
          } else {
            debugPrint(
              "procces product not completed size try to split cant space $size",
            );
          }
        }
        ProductType ptype = ProductType();
        ProductSize psize = ProductSize();
        GSM pgsm = GSM();
        ProductFromExcel p = ProductFromExcel();

        ptype.name = productType;
        ptype.comments = productTypeDesc;
        pgsm.gsm = gsm.toIntFromString();

        psize.width = width.toIntFromString();
        psize.length = length.toIntFromString();

        p.sizes = psize;
        p.gsms = pgsm;
        p.products_types = ptype;

        p.comments = comments;
        p.addInStock(element.quantity);
        productList.add(p);
        debugPrint(
          "procces product result final $productType gsm $gsm  length $length width $width comments $comments  productTypeDes  $productTypeDesc  quantity ${element.quantity}",
        );
      }
    }

    return [
      PageViewModel(
        title: AppLocalizations.of(context)!.validating,
        bodyWidget: SizedBox(
          height: 800,
          child: PdfSelfListPage<PrintProductList>(
            list: productList,
            setting: PrintProductList()
              ..groupedByField = AppLocalizations.of(context)!.description
              ..hideQuantity = false
              ..hideUnitPriceAndTotalPrice = true
              ..sortByField = AppLocalizations.of(context)!.description
              ..skipOutOfStock = false,
          ),
        ),
      ),
    ];
  }

  String? findProductTypeDesc(String productType) {
    if (productType.contains("XTL") || productType.contains("TL")) {
      return "تيست لاينر ورق صناديق";
    } else if (productType.contains("US-SBS")) {
      return "امريكي سكري خلف ابيض";
    } else if (productType.contains("LETTIO")) {
      return "امريكي سكري خلف ابيض";
    } else if (productType.contains("US")) {
      return "امريكي دوبلكس رمادي";
    } else if (productType.contains("SP")) {
      return "اسباني دوبلكس رمادي";
    } else if (productType.contains("IPS")) {
      return "ايطالي دوبلكس رمادي";
    } else if (productType.contains("SAP")) {
      return "سابي سكري وجهين مطلي ابيض";
    } else if (productType.contains("NP")) {
      return "ورق جريدة";
    } else if (productType.contains("FP")) {
      return "ورق جريدة وورق فايالت";
    } else if (productType.contains("FLD")) {
      return "فلندي خلف وحشوة كرفت";
    } else if (productType.contains("IND")) {
      return "هندي سكري";
    } else if (productType.contains("BILL")) {
      return "رقايق خلف كرفت ربع لمعة";
    } else if (productType.contains("ALT")) {
      return "غذائي";
    } else {
      return "-";
    }
  }

  @override
  RequestOptions? getRequestOption({
    required ServerActions action,
    RequestOptions? generatedOptionFromListCall,
  }) {
    return null;
  }

  @override
  List<String>? getRequestedForginListOnCall({required ServerActions action}) {
    return null;
  }
}
