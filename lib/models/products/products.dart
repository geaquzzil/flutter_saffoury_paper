import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_saffoury_paper/models/cities/countries_manufactures.dart';
import 'package:flutter_saffoury_paper/models/customs/customs_declarations.dart';
import 'package:flutter_saffoury_paper/models/prints/print_product.dart';
import 'package:flutter_saffoury_paper/models/products/grades.dart';
import 'package:flutter_saffoury_paper/models/products/gsms.dart';
import 'package:flutter_saffoury_paper/models/products/products_types.dart';
import 'package:flutter_saffoury_paper/models/products/products_color.dart';
import 'package:flutter_saffoury_paper/models/products/qualities.dart';
import 'package:flutter_saffoury_paper/models/products/stocks.dart';
import 'package:flutter_saffoury_paper/models/products/warehouse.dart';
import 'package:flutter_view_controller/interfaces/cartable_interface.dart';
import 'package:flutter_view_controller/interfaces/settings/ModifiableInterfaceAndPrintingSetting.dart';
// import 'package:flutter_view_controller/interfaces/settings/printable_setting.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/new_screens/edit/base_edit_screen.dart';
import 'package:flutter_view_controller/providers/cart/cart_provider.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../invoices/orders.dart';
import 'sizes.dart';
part 'products.g.dart';

@JsonSerializable(
  explicitToJson: true,
)
@reflector
class Product extends ViewAbstract<Product>
    implements CartableProductItemInterface, ModifiableInterface {
  // int? ParentID;
  // int? ProductTypeID;
  // int? CustomsDeclarationID;
  // int? Country_Manufacture_CompanyID;
  // int? SizeID;
  // int? GSMID;
  // int? QualityID;
  // int? ProductColorID;

  ProductStatus? status;
  String? date;
  int? sheets;
  @JsonKey(fromJson: intFromString)
  String? barcode;
  String? fiberLines;
  String? comments;

  double? pending_reservation_invoice;
  double? pending_cut_requests;

  // Product parent;
  ProductType? products_types;
  CustomsDeclaration? customs_declarations;
  CountryManufacture? countries_manufactures;
  Size? sizes;
  GSM? gsms;
  Quality? qualities;
  Grades? grades;
  ProductsColor? products_colors;
  List<Stocks>? inStock;

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() => {
        "status": ProductStatus.NONE,
        "date": "",
        "sheets": 0,
        "barcode": "",
        "fiberLines": "",
        "comments": "",
        "pending_reservation_invoice": 0,
        "pending_cut_requests": 0,
        "products_types": ProductType(),
        "customs_declarations": CustomsDeclaration(),
        "countries_manufactures": CountryManufacture(),
        "sizes": Size(),
        "gsms": GSM(),
        "qualities": Quality(),
        "grades": Grades(),
        "products_colors": ProductsColor(),
        "inStock": List<Stocks>.empty()
      };

  Product() : super();

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) {
    return AppLocalizations.of(context)!.product;
  }

  String getQuantityStringAndLabel(BuildContext context) {
    double quantity = getQuantity();
    if (quantity > 0) {
      return "${AppLocalizations.of(context)!.instock}: ${quantity.toStringAsFixed(2)}";
    }
    return "${AppLocalizations.of(context)!.outOfStock}";
  }

  @override
  Text? getMainSubtitleHeaderText(BuildContext context) {
    double quantity = getQuantity();
    return Text(
      getQuantityStringAndLabel(context),
      style: TextStyle(color: quantity > 0 ? Colors.green : Colors.red),
    );
  }

  Widget getTitleTextHtml(BuildContext context) {
    String? productType = products_types?.getMainHeaderTextOnly(context);
    String? size =
        sizes?.getSizeHtmlFormatString(context, fiberLines: fiberLines);
    String? gsm = gsms?.getMainHeaderTextOnly(context);
    return Html(
      data: "$productType $size X $gsm",
    );
  }

  @override
  Widget getMainHeaderText(BuildContext context) {
    return getTitleTextHtml(context);
  }

  @override
  IconData? getMainDrawerGroupIconData() => Icons.waterfall_chart_outlined;

  @override
  String getMainHeaderTextOnly(BuildContext context) {
    String? productType = products_types?.getMainHeaderTextOnly(context);
    String? size = sizes?.getMainHeaderTextOnly(context);
    String? gsm = gsms?.getMainHeaderTextOnly(context);
    return "$productType $size X $gsm";
  }

  @override
  void onCardDismissedView(BuildContext context, DismissDirection direction) {
    if (direction == DismissDirection.endToStart) {
      context.read<CartProvider>().add(context, this);
    }
  }

  @override
  String? getImageUrl(BuildContext context) {
    return products_types?.getImageUrl(context);
  }

  @override
  Product fromJsonViewAbstract(Map<String, dynamic> json) {
    return Product.fromJson(json);
  }

  @override
  String? getTableNameApi() {
    return "products";
  }

  @override
  List<String> getMainFields() {
    return [
      "customs_declarations",
      "products_types",
      "sizes",
      "gsms",
      "qualities",
      "grades",
      "countries_manufactures",
      "products_colors",
      "date",
      "comments",
      "barcode",
      "status"
    ];
  }

  @override
  List<CustomFilterableField> getCustomFilterableFields(BuildContext context) =>
      super.getCustomFilterableFields(context)
        ..addAll([
          CustomFilterableField(
              this,
              ProductStatus.NONE.getMainLabelText(context),
              Icons.date_range,
              "status",
              "status",
              ProductStatus.NONE,
              singleChoiceIfList: true),
          CustomFilterableField(
              this, "width", Icons.border_left_outlined, "width", "width", "",
              type: const TextInputType.numberWithOptions(
                  decimal: false, signed: false)),
          CustomFilterableField(
              this, "length", Icons.border_top_outlined, "length", "length", "",
              type: const TextInputType.numberWithOptions(
                  decimal: false, signed: false)),
        ]);

  @override
  IconData getMainIconData() {
    return Icons.account_balance_wallet_sharp;
  }

  @override
  Map<String, TextInputType?> getTextInputTypeMap() => {
        "id": TextInputType.number,
        "sizes": TextInputType.number,
        "date": TextInputType.datetime,
        "products_types": TextInputType.number,
        "comments": TextInputType.multiline,
        "barcode": TextInputType.text,
        "products_count": TextInputType.number,
        "pending_reservation_invoice": TextInputType.phone,
        "cut_request_quantity": TextInputType.number,
      };

  @override
  Map<String, IconData> getFieldIconDataMap() => {
        "date": Icons.date_range,
        "sheets": Icons.view_comfortable_outlined,
        "barcode": Icons.qr_code,
        "fiberLines": Icons.face,
        "comments": Icons.notes,
      };

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {
        'date': AppLocalizations.of(context)!.date,
        "barcode": AppLocalizations.of(context)!.barcode,
        "fiberLines": AppLocalizations.of(context)!.grain,
        "comments": AppLocalizations.of(context)!.comments,
      };

  @override
  Map<String, bool> getTextInputIsAutoCompleteMap() => {};

  @override
  Map<String, bool> getTextInputIsAutoCompleteViewAbstractMap() => {};

  @override
  Map<String, int> getTextInputMaxLengthMap() =>
      {'barcode': 255, 'fiberLines': 10};

  @override
  Map<String, double> getTextInputMaxValidateMap() => {};

  @override
  Map<String, double> getTextInputMinValidateMap() => {};

  @override
  Map<String, bool> isFieldCanBeNullableMap() => {
        "grades": true,
        "gsms": true,
        "products_colors": true,
        "qualities": true,
        "customs_declarations": true,
      };

  @override
  Map<String, bool> isFieldRequiredMap() => {};

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    return toJson();
  }

  double getTotalPurchasesPrice({Warehouse? warehouse}) {
    return getUnitPurchasesPrice() * getQuantity(warehouse: warehouse);
  }

  double getTotalSellPrice({Warehouse? warehouse}) {
    return getUnitSellPrice() * getQuantity(warehouse: warehouse);
  }

  double getUnitPurchasesPrice() {
    return products_types?.purchasePrice ?? 0;
  }

  double getUnitSellPrice() {
    return products_types?.sellPrice ?? 0;
  }

  double getQuantity({Warehouse? warehouse}) {
    if (inStock == null) return 0;
    if (warehouse == null) {
      return inStock!
          .fold(0, (value, element) => value + (element.quantity ?? 0));
    }
    return inStock!
        .where((element) => warehouse.iD == element.warehouse?.iD)
        .fold(0, (value, element) => value + (element.quantity ?? 0));
  }

  factory Product.fromJson(Map<String, dynamic> data) =>
      _$ProductFromJson(data);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
  @override
  String getSortByFieldName() {
    return "date";
  }

  @override
  IconData? getCardLeadingBottomIcon() {
    switch (status) {
      case ProductStatus.PENDING:
        return Icons.timer;
      case ProductStatus.WASTED:
        return Icons.delete;
      case ProductStatus.RETURNED:
        return Icons.arrow_back;
      default:
        return null;
    }
  }

  @override
  SortByType getSortByType() {
    return SortByType.DESC;
  }

  @override
  String? getMainDrawerGroupName(BuildContext context) {
    return AppLocalizations.of(context)!.product;
  }

  @override
  String getForeignKeyName() {
    return "ProductID";
  }

  @override
  PrintProduct? getPrintCommand(BuildContext context) =>
      PrintProduct(printObject: this);

  static String? intFromString(dynamic number) => number?.toString();

  String? getNameString() {
    return products_types?.name;
  }

  String? getSizeString(BuildContext context) {
    return sizes?.getMainHeaderTextOnly(context);
  }

  @override
  Widget onCartCheckout(
      BuildContext context, List<CartableProductItemInterface> items) {
    Order order = Order();
    order.orders_details = List.generate(items.length,
        (index) => OrderDetails()..setProduct(items[index] as Product));
    return BaseEditPage(parent: order);
  }

  @override
  double getCartableProductQuantity() => getQuantity();

  @override
  String getModifiableMainGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.printerSetting;

  @override
  IconData getModifibleIconData() => getMainIconData();

  @override
  getModifibleObject(BuildContext context) => PrintProduct(printObject: this);

  @override
  String getModifibleTitleName(BuildContext context) =>
      getMainHeaderLabelTextOnly(context);
}

// enum ProductStatus {
//   @JsonValue("NONE")
//   NONE,
//   @JsonValue("PENDING")
//   PENDING,
//   @JsonValue("RETURNED")
//   RETURNED,
//   @JsonValue("WASTED")
//   WASTED
// }

enum ProductStatus implements ViewAbstractEnum<ProductStatus> {
  @JsonValue("NONE")
  NONE,
  @JsonValue("PENDING")
  PENDING,
  @JsonValue("RETURNED")
  RETURNED,
  @JsonValue("WASTED")
  WASTED;

  @override
  IconData getMainIconData() => Icons.stacked_line_chart_outlined;
  @override
  String getMainLabelText(BuildContext context) =>
      AppLocalizations.of(context)!.status;

  @override
  String getFieldLabelString(BuildContext context, ProductStatus field) {
    switch (field) {
      case NONE:
        return AppLocalizations.of(context)!.none;
      case PENDING:
        return AppLocalizations.of(context)!.pending;
      case RETURNED:
        return AppLocalizations.of(context)!.returnedProduct;
      case WASTED:
        return AppLocalizations.of(context)!.wasted;
    }
  }

  @override
  List<ProductStatus> getValues() {
    return ProductStatus.values;
  }
}
// enum ProductTypePalletOrRoll implements ViewAbstractEnum<ProductTypePalletOrRoll> {

// }
