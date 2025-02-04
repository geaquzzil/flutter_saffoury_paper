// import 'package:bitmap/bitmap.dart';
// ignore_for_file: non_constant_identifier_names, constant_identifier_names, use_build_context_synchronously, library_prefixes

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_saffoury_paper/models/cities/countries_manufactures.dart';
import 'package:flutter_saffoury_paper/models/customs/customs_declarations.dart';
import 'package:flutter_saffoury_paper/models/dashboards/utils.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/reservation_invoice.dart';
import 'package:flutter_saffoury_paper/models/invoices/refund_invoices/orders_refunds.dart';
import 'package:flutter_saffoury_paper/models/prints/print_product.dart';
import 'package:flutter_saffoury_paper/models/prints/printable_product_label_widgets.dart';
import 'package:flutter_saffoury_paper/models/products/analysis/products_movments.dart';
import 'package:flutter_saffoury_paper/models/products/grades.dart';
import 'package:flutter_saffoury_paper/models/products/gsms.dart';
import 'package:flutter_saffoury_paper/models/products/products_color.dart';
import 'package:flutter_saffoury_paper/models/products/products_types.dart';
import 'package:flutter_saffoury_paper/models/products/qualities.dart';
import 'package:flutter_saffoury_paper/models/products/sizes.dart';
import 'package:flutter_saffoury_paper/models/products/stocks.dart';
import 'package:flutter_saffoury_paper/models/products/warehouse.dart';
import 'package:flutter_saffoury_paper/models/products/widgets/pos/pos_header.dart';
import 'package:flutter_saffoury_paper/widgets/product_top_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/helper_model/qr_code.dart';
import 'package:flutter_view_controller/interfaces/cartable_interface.dart';
import 'package:flutter_view_controller/interfaces/excelable_reader_interface.dart';
import 'package:flutter_view_controller/interfaces/posable_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_custom_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_invoice_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_list_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/interfaces/settings/ModifiableInterfaceAndPrintingSetting.dart';
import 'package:flutter_view_controller/interfaces/sharable_interface.dart';
import 'package:flutter_view_controller/interfaces/web/category_gridable_interface.dart';
import 'package:flutter_view_controller/models/apis/changes_records.dart';
import 'package:flutter_view_controller/models/apis/chart_records.dart';
import 'package:flutter_view_controller/models/apis/date_object.dart';
import 'package:flutter_view_controller/models/apis/unused_records.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/menu_item.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
// import 'package:flutter_view_controller/interfaces/settings/printable_setting.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/models/view_abstract_inputs_validaters.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:flutter_view_controller/new_components/tab_bar/tab_bar_by_list.dart';
import 'package:flutter_view_controller/new_screens/actions/view/view_view_abstract.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/components/chart_card_item_custom.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/my_files.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/new_screens/home/components/ext_provider.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_auto_rest_custom_view_horizontal.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_auto_rest_horizontal.dart';
import 'package:flutter_view_controller/new_screens/lists/pos_list.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_auto_rest_new.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_static_list_new.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_view_abstract_new.dart';
import 'package:flutter_view_controller/new_screens/pos/pos_card_item_square.dart';
import 'package:flutter_view_controller/new_screens/theme.dart';
import 'package:flutter_view_controller/printing_generator/ext.dart';
import 'package:flutter_view_controller/providers/cart/cart_provider.dart';
import 'package:flutter_view_controller/providers/filterables/filterable_provider.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:flutter_view_controller/test_var.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pdf/pdf.dart' as d;
import 'package:pdf/pdf.dart' as pdf;
import 'package:pdf/widgets.dart' as pdfWidget;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:supercharged/supercharged.dart';

import '../invoices/cuts_invoices/cut_requests.dart';
import '../invoices/orders.dart';
import '../invoices/priceless_invoices/products_inputs.dart';
import '../invoices/priceless_invoices/products_outputs.dart';
import '../invoices/priceless_invoices/transfers.dart';
import '../invoices/purchases.dart';
import '../invoices/refund_invoices/purchasers_refunds.dart';
import '../prints/print_product_list.dart';

part 'products.g.dart';

@JsonSerializable(
  explicitToJson: true,
)
@reflector
class Product extends ViewAbstract<Product>
    with ModifiableInterface<PrintProduct>
    implements
        CartableProductItemInterface,
        PrintableCustomInterface<PrintProduct>,
        PrintableSelfListInterface<PrintProductList>,
        PosableInterface,
        WebCategoryGridableInterface<Product>,
        PrintableComparableListInterface<PrintProductList>,
        SharableInterface,
        ExcelableReaderInterace {
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
  @JsonKey(includeIfNull: false, includeToJson: false)
  int? ParentID;
  @JsonKey(fromJson: intFromString)
  String? barcode;
  String? fiberLines;
  String? comments;

  List<Product>? parents;

  double? pending_reservation_invoice;
  double? pending_cut_requests;
  double? cut_request_quantity;

  // Product parent;
  ProductType? products_types;
  CustomsDeclaration? customs_declarations;
  CountryManufacture? countries_manufactures;
  ProductSize? sizes;
  GSM? gsms;
  Quality? qualities;
  Grades? grades;
  ProductsColor? products_colors;
  List<Stocks>? inStock;

  Product? products;

  List<CutRequest>? cut_requests;
  int? cut_requests_count;

  List<OrderRefundDetails>? order_refunds_order_details;
  int? order_refunds_order_details_count;

  List<OrderDetails>? orders_details;
  int? orders_details_count;

  List<ProductInputDetails>? products_inputs_details;
  int? products_inputs_details_count;

  List<ProductOutputDetails>? products_outputs_details;
  int? products_outputs_details_count;

  List<PurchasesDetails>? purchases_details;
  int? purchases_details_count;

  List<PurchasesRefundDetails>? purchases_refunds_purchases_details;
  int? purchases_refunds_purchases_details_count;

  List<ReservationInvoiceDetails>? reservation_invoice_details;
  int? reservation_invoice_details_count;

  List<TransfersDetails>? transfers_details;
  int? transfers_details_count;

  @JsonKey(includeFromJson: true, includeToJson: false)
  double? qrQuantity;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool requireObjcetsResquest = true;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool disbleStatusAndSizeOnFilter = false;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool isInventoryWorker = false;

  @JsonKey(includeFromJson: false, includeToJson: false)
  double? totalInventoryQuantity;

  @JsonKey(includeFromJson: false, includeToJson: false)
  int? totalInventoryItmes;

  @JsonKey(includeFromJson: false, includeToJson: false)
  double? totalQrQuantity;

  @JsonKey(includeFromJson: false, includeToJson: false)
  int? totalQrItems;
  @JsonKey(includeFromJson: false, includeToJson: false)
  double? totalRemaining;

  void setTotalsFromPrintable(List<Product> list) {
    totalQrQuantity ??= list.sumCustom<Product>(
      (t) => t.qrQuantity.toNonNullable(),
    );
    totalInventoryQuantity ??= list.sumCustom<Product>(
      (t) => t.getQuantity().toNonNullable(),
    );
    totalInventoryItmes ??= list.length;
    totalQrItems ??= list
        .where(
          (t) => t.qrQuantity != null,
        )
        .length;
    totalRemaining ??=
        list.sumCustom<Product>((o) => o.getQuantityFromTow(o, o));
  }

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
        "sizes": ProductSize(),
        "gsms": GSM(),
        "qualities": Quality(),
        "grades": Grades(),
        "products_colors": ProductsColor(),
        "inStock": List<Stocks>.empty(),
        "qrQuantity": 0.0,
      };

  Product() : super() {
    date = "".toDateTimeNowString();
    status = ProductStatus.NONE;
  }

  Product.disableCustomFilterable({this.disbleStatusAndSizeOnFilter = true});

  Product.requiresInventory() {
    setCustomMap({"requireInventory": "true"});
    date = "".toDateTimeNowString();
    status = ProductStatus.NONE;
  }

  Product.inventoryWorker() {
    setCustomMap({"requireInventory": "true"});
    disbleStatusAndSizeOnFilter = true;
    isInventoryWorker = true;
    date = "".toDateTimeNowString();
    status = ProductStatus.NONE;
  }
  @override
  Product copyWithSetNewFileReader() {
    date = "".toDateTimeNowString();
    status = ProductStatus.NONE;
    return this;
  }

  @override
  Product getSelfNewInstance() {
    return Product();
  }

  ProductSizeType getSizeType() {
    if (isRoll()) {
      return ProductSizeType.REEL;
    }
    return ProductSizeType.PALLET;
  }

  Product.initOnlyReelsCustomParams() {
    setCustomMap(getOnlyReelsCustomParams());
  }
  @override
  String getMainHeaderLabelTextOnly(BuildContext context) {
    return AppLocalizations.of(context)!.product;
  }

  String getQuantityStringAndLabel(BuildContext context) {
    double quantity = qrQuantity ?? getQuantity();
    if (quantity > 0) {
      return "${AppLocalizations.of(context)!.instock}: ${getQuantityStringFormat(context: context)}";
    }
    return AppLocalizations.of(context)!.outOfStock;
  }

  @override
  bool isRequiredObjects() {
    return requireObjcetsResquest;
  }

  @override
  Widget? getMainSubtitleHeaderText(BuildContext context) {
    double quantity = qrQuantity ?? getQuantity();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(products_types?.getLabelWithTextFromField(context, 'sellPrice') ??
            ""),
        Text(
          getQuantityStringAndLabel(context),
          style: TextStyle(
              color: quantity > 0
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.error),
        ),
      ],
    );
  }

  Widget getTitleTextHtml(BuildContext context) {
    String? productType = products_types?.getMainHeaderTextOnly(context);
    String? size =
        sizes?.getSizeHtmlFormatString(context, fiberLines: fiberLines);
    String? gsm = gsms?.getMainHeaderTextOnly(context);
    return Html(
      data: "$productType $size X $gsm",

      // style:{

      //   "body":Theme.of(context).textTheme.bodySmall
      // }
    );
  }

  @override
  Widget getMainHeaderText(BuildContext context) {
    return getTitleTextHtml(context);
  }

  @override
  IconData? getMainDrawerGroupIconData() => Icons.waterfall_chart_outlined;
  @override
  Widget getHorizontalCardMainHeader(BuildContext context) {
    String? productType = products_types?.getMainHeaderTextOnly(context);
    String? size = sizes?.getMainHeaderTextOnly(context);
    String? gsm = gsms?.getMainHeaderTextOnly(context);
    String res = "$productType\n$size X $gsm";
    return Text(
      res,
      textAlign: TextAlign.start,
    );
  }

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
      context
          .read<CartProvider>()
          .onCartItemAdded(context, -1, this, getQuantity());
      return;
    }
    super.onCardDismissedView(context, direction);
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

  bool hasPermissionQuantity(BuildContext context) {
    return hasPermission(context, "text_products_quantity", ServerActions.view);
  }

  bool hasPermissionQuantityOrPrice(BuildContext context) {
    return hasPermissionQuantity(context) || hasPermissionPrice(context);
  }

  bool hasPermissionPrice(BuildContext context) {
    return hasPermission(
        context, "text_prices_for_customer", ServerActions.view);
  }

  @override
  Map<String, String> getPermissionFieldsMap(BuildContext context) {
    return {
      "inStock": "text_products_quantity",
      "comments": "text_products_notes"
    };
  }

  @override
  List<String> getExcelableFields(BuildContext context) {
    return [
      "customs_declarations",
      "products_types",
      "sizes",
      "gsms",
      "qualities",
      "grades",
      "countries_manufactures",
      "products_colors",
      "comments",
      "barcode",
      "qrQuantity"
    ];
  }

  @override
  List<String> getMainFields({BuildContext? context}) {
    return [
      "customs_declarations",
      "products_types",
      "sizes",
      "gsms",
      "qualities",
      "grades",
      "countries_manufactures",
      // "products_colors",
      "date",
      "comments",
      "barcode",
      "status"
    ];
  }

  @override
  Map<ServerActions, List<String>>? canGetObjectWithoutApiCheckerList() {
    // TODO: implement canGetObjectWithoutApiCheckerList
    return {ServerActions.list: []};
  }

  @override
  bool canGetObjectWithoutApiChecker(ServerActions action) {
    debugPrint("Product canGetObjectWithoutApiChecker action => $action");
    return products_types != null;
  }

  @override
  List<CustomFilterableField> getCustomFilterableFields(BuildContext context) {
    return super.getCustomFilterableFields(context)
      ..addAll(!disbleStatusAndSizeOnFilter
          ? [
              CustomFilterableField(
                  this,
                  ProductStatus.NONE.getMainLabelText(context),
                  Icons.date_range,
                  "status",
                  "status",
                  ProductStatus.NONE,
                  singleChoiceIfList: true),
              CustomFilterableField(this, "width", Icons.border_left_outlined,
                  "width", "width", "",
                  type: const TextInputType.numberWithOptions(
                      decimal: false, signed: false)),
              CustomFilterableField(this, "length", Icons.border_top_outlined,
                  "length", "length", "",
                  type: const TextInputType.numberWithOptions(
                      decimal: false, signed: false)),
            ]
          : []);
  }

  @override
  IconData getMainIconData() {
    return Icons.account_balance_wallet_sharp;
  }

  @override
  Map<String, TextInputType?> getTextInputTypeMap() => {
        "id": TextInputType.number,
        "date": TextInputType.datetime,
        "comments": TextInputType.multiline,
        "barcode": TextInputType.text,
        "products_count": TextInputType.number,
        "pending_reservation_invoice": TextInputType.phone,
        "cut_request_quantity": TextInputType.number,
        "qrQuantity": TextInputType.number,
      };

  @override
  Map<String, IconData> getFieldIconDataMap() => {
        "date": Icons.date_range,
        "sheets": Icons.view_comfortable_outlined,
        "barcode": Icons.qr_code,
        "fiberLines": Icons.face,
        "comments": Icons.notes,
        "qrQuantity": Icons.line_weight
      };

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {
        'date': AppLocalizations.of(context)!.date,
        "barcode": AppLocalizations.of(context)!.barcode,
        "fiberLines": AppLocalizations.of(context)!.grain,
        "comments": AppLocalizations.of(context)!.comments,
        "qrQuantity": AppLocalizations.of(context)!.quantity,
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
  bool isFieldEnabled(String field) {
    return "status" != field;
  }

  @override
  Map<String, bool> isFieldCanBeNullableMap() => {
        "grades": true,
        "gsms": true,
        "countries_manufactures": true,
        "products_colors": true,
        "qualities": true,
        "customs_declarations": true,
      };

  @override
  Map<String, bool> isFieldRequiredMap() => {"qrQuantity": true};

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    return toJson();
  }

  String getProductTypeUnit(BuildContext context) {
    return products_types?.getUnit(context) ?? "-";
  }

  double getTotalPurchasesPrice({Warehouse? warehouse}) {
    return getUnitPurchasesPrice() * getQuantity(warehouse: warehouse);
  }

  double getTotalSellPrice({Warehouse? warehouse}) {
    return (getUnitSellPrice() * getQuantity(warehouse: warehouse))
        .roundDouble();
  }

  String getTotalSellPriceStringFormat(
      {required BuildContext context, Warehouse? warehouse}) {
    return getTotalSellPrice(warehouse: warehouse)
        .toCurrencyFormatFromSetting(context);
  }

  double getUnitPurchasesPrice() {
    return products_types?.purchasePrice ?? 0;
  }

  String getUnitPurchasesPriceStringFormat({required BuildContext context}) {
    return getUnitPurchasesPrice().toCurrencyFormatFromSetting(context);
  }

  double getUnitSellPrice() {
    return products_types?.sellPrice ?? 0;
  }

  String getUnitSellPriceStringFormat({required BuildContext context}) {
    return getUnitSellPrice().toCurrencyFormatFromSetting(context);
  }

  int getReams() {
    if (sheets.toNonNullable() == 0) return 0;
    return getQuantity().toInt();
  }

  bool isReams() {
    return products_types?.unit == ProductTypeUnit.Ream;
  }

  bool isRoll() {
    return sizes?.isRoll() ?? true;
  }

  bool hasGSM() {
    return gsms != null;
  }

  Widget getFullDescription() {
    return MasterView(
      viewAbstract: this,
      isSliver: false,
      overrideTrailingToNull: true,
    );
  }

  double getSheets({ProductSize? customSize, double? customQuantity}) {
    if (customSize != null) {
      if (customSize.isRoll()) return 0;
      if (customSize.width == 0) return 0;
      if (!hasGSM()) return 0;
      if ((gsms?.gsm ?? 0) == 0) return 0;
      return ((customQuantity ?? getQuantity()) /
              (getSheetWeight(customSize: customSize) / 1000))
          .toInt()
          .toDouble();
    }
    if (isRoll()) return 0;
    if (sizes?.width == null || sizes?.length == null) return 0;
    if (sizes?.width == 0 || sizes?.length == 0) return 0;
    if (!hasGSM()) return 0;
    if ((gsms?.gsm ?? 0) == 0) return 0;
    return ((customQuantity ?? getQuantity()) / (getSheetWeight() / 1000))
        .toInt()
        .toDouble();
  }

  ///get sheet weight by  grsm
  double getSheetWeight({ProductSize? customSize}) {
    if (customSize != null) {
      if (customSize.isRoll()) return 0;
      try {
        return (customSize.width! * customSize.length! * getGSM()).toDouble() /
            1000000;
      } catch (e) {
        return 0;
      }
    }
    if (isRoll()) return 0;
    try {
      return (getWidth() * getLength() * getGSM()).toDouble() / 1000000;
    } catch (e) {
      return 0;
    }
  }

  String getSheetWeightStringFormat(
      {required BuildContext context, ProductSize? customSize}) {
    return getSheetWeight(customSize: customSize)
        .toCurrencyFormat(symbol: AppLocalizations.of(context)!.gramSymbol);
  }

  double getOneSheetPrice({ProductSize? customSize}) {
    return (getSheetWeight(customSize: customSize) / 1000) * getUnitSellPrice();
  }

  String getOneSheetPriceStringFormat(
      {required BuildContext context, ProductSize? customSize}) {
    return getOneSheetPrice(customSize: customSize)
        .toCurrencyFormatFromSetting(context);
  }

  int getWidth() {
    return sizes?.width ?? 0;
  }

  int getLength() {
    return sizes?.length ?? 0;
  }

  int getGSM() {
    return gsms?.gsm ?? 0;
  }

  String getManufactureNameString() {
    if (isRollCut()) {
      return "Saffoury Paper";
    }
    return countries_manufactures?.manufactures?.name ?? "";
  }

  bool isRollCut() {
    //todo check type of value return  is cutrequest

    return parents != null && (parents?.isNotEmpty ?? false);
  }

  String getCountryNameString() {
    if (isRollCut()) {
      return "Syria".toUpperCase();
    }
    return countries_manufactures?.countries?.name ?? "";
  }

  @override
  FormFieldControllerType getInputType(String field) {
    if (field == "grades") {
      return FormFieldControllerType.VIEW_ABSTRACT_AS_ONE_FIELD;
    }
    if (field == "barcode") {
      return FormFieldControllerType.AUTO_COMPLETE;
    }
    return super.getInputType(field);
  }

  String getCutRequestID() {
    return "";
  }

  String getCustomerNameIfCutRequest() {
    return "";
  }

  String getQuantityStringFormat(
      {required BuildContext context, Warehouse? warehouse}) {
    return (qrQuantity ?? getQuantity(warehouse: warehouse))
        .toCurrencyFormat(symbol: getProductTypeUnit(context));
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
  SortFieldValue? getSortByInitialType() =>
      SortFieldValue(field: "date", type: SortByType.DESC);
  @override
  getCardLeadingBottomIcon(BuildContext context) {
    switch (status) {
      case ProductStatus.PENDING:
        return Icons.timer;
      case ProductStatus.WASTED:
        return Text(
          status!.getFieldLabelString(context, status!).toUpperCase(),
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Theme.of(context).colorScheme.error),
        );
      case ProductStatus.RETURNED:
        return Icons.arrow_back;
      default:
        if (isRollCut()) {
          return Icon(
            Icons.cut_sharp,
            color: Theme.of(context).colorScheme.tertiary,
            size: getIconSize(context) * .7,
          );
        }
        return null;
    }
  }

  @override
  Widget? getHomeHeaderWidget(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.account_circle,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text("Welcom back",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              )),
      trailing: Icon(
        Icons.arrow_right_outlined,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  @override
  List<Widget>? getHomeListHeaderWidgetList(BuildContext context) {
    // TODO: implement getHomeListHeaderWidgetList
    return [
      SliverApiMixinAutoRestWidget(
          autoRest: AutoRest<ProductType>(
              obj: ProductType.init(true), key: "ProductType<Category>")),
    ];
  }

  @override
  List<StaggeredGridTile>? getHomeListHeaderWidget(BuildContext context) {
    num mainAxisCellCount = SizeConfig.getMainAxisCellCount(context);
    num mainAxisCellCountList = SizeConfig.getMainAxisCellCount(context,
        mainAxisType: MainAxisType.ListHorizontal);
    return [
      StaggeredGridTile.count(
        crossAxisCellCount: 2,
        mainAxisCellCount: 1,
        child: ListHorizontalApiAutoRestWidget(
          isSliver: true,
          titleString: "Category",

          // listItembuilder: (v) =>
          //     ListItemProductTypeCategory(productType: v as ProductType),
          autoRest: AutoRest<ProductType>(
              obj: ProductType.init(true), key: "ProductType<Category>"),
        ),
      ),
    ];
  }

  @override
  List<StaggeredGridTile> getHomeHorizotalList(BuildContext context) {
    num mainAxisCellCount = SizeConfig.getMainAxisCellCount(context);
    num mainAxisCellCountList = SizeConfig.getMainAxisCellCount(context,
        mainAxisType: MainAxisType.ListHorizontal);
    return [
      StaggeredGridTile.count(
        crossAxisCellCount: 2,
        mainAxisCellCount: mainAxisCellCountList,
        child: ListHorizontalApiAutoRestWidget(
          isSliver: true,
          titleString: "Category",

          // listItembuilder: (v) =>
          //     ListItemProductTypeCategory(productType: v as ProductType),
          autoRest: AutoRest<ProductType>(
              obj: ProductType.init(true), key: "ProductType<Category>"),
        ),
      ),
      StaggeredGridTile.count(
        crossAxisCellCount: 2,
        mainAxisCellCount: mainAxisCellCount / 2,
        child: ListHorizontalCustomViewApiAutoRestWidget(
            autoRest: UnusedRecords.init(Product())),
      ),
      StaggeredGridTile.count(
        crossAxisCellCount: 2,
        mainAxisCellCount: mainAxisCellCount,
        child: ListHorizontalCustomViewApiAutoRestWidget(
            autoRest: ChangesRecords.init(Product(), "status")),
      ),
      StaggeredGridTile.count(
        crossAxisCellCount: 2,
        mainAxisCellCount: mainAxisCellCount,
        child: ListHorizontalCustomViewApiAutoRestWidget(
            autoRest: ChartRecordAnalysis.init(
                Order(), DateObject(), EnteryInteval.monthy)),
      ),

      StaggeredGridTile.count(
        crossAxisCellCount: 2,
        mainAxisCellCount: mainAxisCellCountList,
        child: ListHorizontalApiAutoRestWidget(
          isSliver: true,

          titleString: "Today",
          // listItembuilder: (v) => SizedBox(
          //     width: 100, height: 100, child: POSListCardItem(object: v)),
          autoRest: AutoRest<Product>(
              obj: Product()
                ..setCustomMap(
                    {"<dateEnum>": "[\"Today\"]", "requireInventory": "true"}),
              key: "productsByType<dateEnum>thisDay"),
        ),
      ),
      StaggeredGridTile.count(
        crossAxisCellCount: 2,
        mainAxisCellCount: mainAxisCellCountList,
        child: ListHorizontalApiAutoRestWidget(
          isSliver: true,
          titleString: "This week",
          autoRest: AutoRest<Product>(
              obj: Product()
                ..setCustomMap({
                  "<dateEnum>": "[\"This week\"]",
                  "requireInventory": "true"
                }),
              key: "productsByType<dateEnum>thisWeek"),
        ),
      ),

      // ListHorizontalCustomViewApiAutoRestWidget(
      //     titleString: "TEST1 ", autoRest: UnusedRecords.init(Product())),
      // ListHorizontalApiAutoRestWidget(
      //     titleString: "TEST1 ",
      //     autoRest:
      //         AutoRest<Product>(obj: Product(), key: "HCustomerByOrder$iD")),
      // ListHorizontalApiAutoRestWidget(
      //   titleString: "TEST2",
      //   autoRest: AutoRest<Product>(obj: Product(), key: "HCustomerByOrder$iD"),
      // ),
      // ListHorizontalApiAutoRestWidget(
      //   titleString: "TEST2",
      //   autoRest: AutoRest<Product>(obj: Product(), key: "HCustomerByOrder$iD"),
      // ),
    ];
  }

  @override
  String? getMainDrawerGroupName(BuildContext context) {
    return AppLocalizations.of(context)!.product;
  }

  @override
  String getForeignKeyName() {
    return "ProductID";
  }

  Map<String, String> getOnlyReelsCustomParams() {
    Map<String, String> hashMap = getCustomMap;
    // hashMap["<maxWaste>"] = ("[\"100\"]");
    hashMap["<unit>"] = ("[\"Roll\"]");
    hashMap["requireInventory"] = "yes";
    return hashMap;
  }

  @override
  String getCardItemDropdownSubtitle(BuildContext context) {
    return "${getIDFormat(context)} /${getQuantityStringFormat(context: context)}";
  }

  Map<String, String> getSimilarWithSameSizeCustomParams(BuildContext context) {
    Map<String, String> hashMap = getCustomMap;
    hashMap["<maxWaste>"] = ("[\"100\"]");
    hashMap["<width>"] = ("[\"${getWidth()}\"]");
    hashMap["<length>"] = ("[\"${getLength()}\"]");
    hashMap["requireInventory"] = "yes";
    if (!isGeneralEmployee(context)) {
      hashMap["<status>"] = "[\"NONE\"]";
    }
    return hashMap;
  }

  bool hasSheetWeight() {
    return gsms != null;
  }

  void setProductsByCategoryCustomParams(
      BuildContext context, ProductType category) {
    Map<String, String> hashMap = getCustomMap;

    if (!isGeneralEmployee(context)) {
      hashMap["<status>"] = "[\"NONE\"]";
    }
    hashMap["<ProductTypeID>"] = "[\"${category.iD}\"]";
    hashMap["requireInventory"] = "yes";

    setCustomMap(hashMap);
  }

  Map<String, String> getSimilarCustomParams(BuildContext context) {
    Map<String, String> hashMap = getCustomMap;
    hashMap["<maxWaste>"] = ("[\"100\"]");
    if (hasSheetWeight()) {
      hashMap["<GSMID>"] = "[\"${gsms?.iD}\"]";
    }
    if (!isGeneralEmployee(context)) {
      hashMap["<status>"] = "[\"NONE\"]";
    }
    hashMap["<width>"] = ("[\"${getWidth()}\"]");
    hashMap["<length>"] = ("[\"${getLength()}\"]");
    hashMap["<ProductTypeID>"] = "[\"${products_types?.iD}\"]";
    hashMap["requireInventory"] = "yes";
    return hashMap;
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
          toListObject: Product()
            ..setCustomMap(getSimilarCustomParams(context))),
      SliverApiMixinAutoRestWidget(
          autoRest: AutoRest<Product>(
              range: 5,
              obj: Product()
                ..setCustomMap(getSimilarWithSameSizeCustomParams(context)),
              key:
                  "productsWithSimilarSize${getSimilarWithSameSizeCustomParams(context)}")),
    ];
    return [
      ListHorizontalApiAutoRestWidget(
        isSliver: true,
        // valueNotifier: onHorizontalListItemClicked,
        titleString: AppLocalizations.of(context)!.simialrProducts,
        autoRest: AutoRest<Product>(
            range: 5,
            obj: Product()..setCustomMap(getSimilarCustomParams(context)),
            key: "similarProducts${getSimilarCustomParams(context)}"),
      ),
      ListHorizontalApiAutoRestWidget(
        isSliver: true,
        // valueNotifier: onHorizontalListItemClicked,
        titleString: AppLocalizations.of(context)!.productsWithSimilarSize,
        autoRest: AutoRest<Product>(
            range: 5,
            obj: Product()
              ..setCustomMap(getSimilarWithSameSizeCustomParams(context)),
            key:
                "productsWithSimilarSize${getSimilarWithSameSizeCustomParams(context)}"),
      )
    ];
  }

  @override
  Widget? getTabControllerFirstHeaderWidget(BuildContext context) {
    if (isNew()) return null;
    return ProductHeaderToggle(
      product: this,
    );
  }

  @override
  List<Widget>? getCustomTopWidget(BuildContext context,
      {ServerActions? action,
      ValueNotifier<ViewAbstract?>? onHorizontalListItemClicked,
      ValueNotifier<SecondPaneHelper?>? onClick}) {
    Color primary = Theme.of(context).colorScheme.primary;
    return [
      if (action != ServerActions.edit)
        ProductTopWidget(product: this, valueNotifier: onClick),
      // if (isRollCut())
      //   FixedTimeline.tileBuilder(
      //     theme: TimelineTheme.of(context).copyWith(
      //       connectorTheme: ConnectorThemeData(color: primary),
      //       color: primary,
      //     ),
      //     builder: TimelineTileBuilder.connectedFromStyle(
      //       contentsAlign: ContentsAlign.alternating,
      //       oppositeContentsBuilder: (context, index) => Padding(
      //         padding: const EdgeInsets.all(20),
      //         child: Text(parents![index].date!),
      //       ),
      //       contentsBuilder: (context, index) => Card(
      //         child: Padding(
      //           padding: const EdgeInsets.all(20),
      //           child: Text(parents![index].getMainHeaderTextOnly(context)),
      //         ),
      //       ),
      //       connectorStyleBuilder: (context, index) => ConnectorStyle.solidLine,
      //       indicatorStyleBuilder: (context, index) => IndicatorStyle.dot,
      //       itemCount: parents!.length,
      //     ),
      //   ),
    ];
    return super.getCustomTopWidget(context, action: action);
  }

  @override
  List<TabControllerHelper> getCustomTabList(BuildContext context,
      {ServerActions? action}) {
    if (action == ServerActions.list) return [];
    return [
      if (isEditing())
        TabControllerHelper(AppLocalizations.of(context)!.movments,
            draggableHeaderWidget: Text(
              AppLocalizations.of(context)!.movments,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            isResponsiveIsSliver: true,
            // extras: ,
            widget: ListHorizontalCustomViewApiAutoRestWidget(
                autoRest: ProductMovments.init(iD))),
      // TabControllerHelper(
      //   AppLocalizations.of(context)!.movments,
      //   widget: ListHorizontalCustomViewApiAutoRestWidget(
      //     titleString: "TEST1 ",
      //     autoRest: ProductMovments.init(iD),
      //   ),
      // ),
    ];
  }
  // @override
  // List<TabControllerHelper> getCustomTabList(BuildContext context) {
  //   return [
  //     TabControllerHelper(
  //       AppLocalizations.of(context)!.movments,
  //       null,
  //       widget: StarageDetailsCustom(
  //           chart: ListHorizontalCustomViewApiAutoRestWidget(
  //               onResponseAddWidget: ((response) {
  //                 ChartRecordAnalysis i = response as ChartRecordAnalysis;
  //                 double total = i.getTotalListAnalysis();
  //                 return Column(
  //                   children: [
  //                     // ListHorizontalCustomViewApiAutoRestWidget<CustomerTerms>(
  //                     //     titleString: "TEST1 ",
  //                     //     autoRest: CustomerTerms.init(customers?.iD ?? 1)),
  //                     StorageInfoCardCustom(
  //                         title: AppLocalizations.of(context)!.total,
  //                         description: total.toCurrencyFormat(),
  //                         trailing: "kg",
  //                         svgSrc: Icons.monitor_weight),
  //                     StorageInfoCardCustom(
  //                         title: AppLocalizations.of(context)!.balance,
  //                         description:
  //                             customers?.balance?.toCurrencyFormat() ?? "0",
  //                         trailing: "trailing",
  //                         svgSrc: Icons.balance),
  //                   ],
  //                 );
  //               }),
  //               titleString: "TEST1 ",
  //               autoRest: ChartRecordAnalysis.init(
  //                   Order(), DateObject(), EnteryInteval.monthy,
  //                   customAction: {"CustomerID": customers?.iD})),
  //        ),
  //     ),

  //     //  ChartItem(
  //     //   autoRest: AutoRest<Order>(
  //     //     obj: Order()..setCustomMap({"<CustomerID>": "${customers?.iD}"}),
  //     //     key: "CustomerByOrder$iD"),
  //     // ),
  //   ];
  // }
//  @override
//   Widget? getCustomTopWidget(BuildContext context, ServerActions action) {
//     if (action == ServerActions.view) {
//       return ListHorizontalApiAutoRestWidget(
//         customHeight: 300,
//         title: getMainHeaderText(context),
//         autoRest: AutoRest<Product>(
//             obj: Product()
//               ..setCustomMap({"<CustomerID>": "${customers?.iD}"}),
//             key: "similarProducts$iD"),
//       );
//     }
//     return null;
//   }

  static String? intFromString(dynamic number) => number?.toString();

  String getProductTypeNameString() {
    return products_types?.name ?? "-";
  }

  String getGradeString() {
    return grades?.name ?? "-";
  }

  String getQualityString() {
    return qualities?.name ?? "-";
  }

  String getSizeString(BuildContext context) {
    return sizes?.getMainHeaderTextOnly(context) ?? "-";
  }

  String getGSMString(BuildContext context) {
    return gsms?.gsm.toString() ?? "";
  }

  String getGrainOn() {
    if (fiberLines == null) return "-";
    if (isRoll()) return "-";
    if (fiberLines == "Width") return getWidth().toString();
    if (fiberLines == "Length") return getLength().toString();
    return "-";
  }

  @override
  double getCartableProductQuantity() => getQuantity();

  @override
  String getModifiableMainGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.printerSetting;

  @override
  IconData getModifibleIconData() => getMainIconData();

  @override
  getModifibleSettingObject(BuildContext context) => PrintProduct();

  @override
  String getModifibleTitleName(BuildContext context) =>
      getMainHeaderLabelTextOnly(context);

  @override
  Future<pdfWidget.Widget?>? getPrintableCustomFooter(BuildContext context,
          {pdf.PdfPageFormat? format, PrintProduct? setting}) =>
      null;
  // null;

  @override
  pdfWidget.Widget? getPrintableWatermark(d.PdfPageFormat? format) {
    if (format == roll80) {
      return null;
    }
    return pdfWidget.FullPage(
        ignoreMargins: true,
        child: pdfWidget.Watermark.text('SAFFOURY\n',
            fit: pdfWidget.BoxFit.scaleDown,
            // angle: 0,
            style: pdfWidget.TextStyle.defaultStyle().copyWith(
              fontSize: 80,
              color: pdf.PdfColors.grey400,
              fontWeight: pdfWidget.FontWeight.bold,
            )));
  }

  @override
  Future<pdfWidget.Widget?>? getPrintableCustomHeader(BuildContext context,
          {pdf.PdfPageFormat? format, PrintProduct? setting}) =>
      null;

  @override
  Future<List<pdfWidget.Widget>> getPrintableCustomPage(BuildContext context,
      {pdf.PdfPageFormat? format, PrintProduct? setting}) async {
    pdfWidget.Widget? header;
    if (format != roll80) {
      header = await buildHeader(setting: setting);
    }
    debugPrint("getPrintableCustomPage generating");
    return [
      if (format != roll80)
        pdfWidget.Stack(
          alignment: pdfWidget.Alignment.bottomRight,
          fit: pdfWidget.StackFit.loose,
          // alignment: ,
          children: [
            header!,
            // pdfWidget.Watermark.text("tessssssssssssssssssssssssst",
            //     fit: pdfWidget.BoxFit.fill),
            printableGetMainTitle(context, this, format: format),
          ],
        ),

      if (!printableIsLabel(format: format))
        ProductLabelPDF(context, this, setting: setting, format: format)
            .generate()
      else
        ProductLabelIfLabelRoll80(
                context: context,
                product: this,
                format: format,
                setting: setting)
            .generate(qrObject: this)

      //  Row(
      // crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.start,
      // children: [
      //   Expanded(flex: 3, child: buildTable()),
      //   Expanded(flex: 1, child: buildQrCode())
      // ])
    ];
  }

  Future<pdfWidget.Widget> buildHeader({PrintProduct? setting}) async {
    // String svg =
    //     await rootBundle.loadString("assets/images/vector/a5Header.svg");
    // debugPrint(
    //     "buildHeader #${getPrintablePrimaryColor(null)}  #${getPrintableSecondaryColor(null)}");
    // // debugPrint("buildHeaderbefore $svg");
    // svg = svg.replaceAll("{fill:#6ABD45;}", "{fill:#FF0000;}");
    // svg = svg.replaceAll("{fill:#010101;}", "{fill:#FF0000;}");
    // svg = svg.replaceAll("{fill:#696A6A;}", "{fill:#FF0000;}");
    // svg = svg.replaceAll(
    //     "{fill:#93C83E;}", "{fill:#${getPrintableSecondaryColor(null)};}");
    // svg = svg.replaceAll(
    //     "{fill:#7EB642;}", "{fill:#${getPrintablePrimaryColor(null)};}");
    // debugPrint("buildHeader $svg");

    // DrawableRoot svgDrawableRoot = await svg.fromSvgString(svgString, null);

    // // to have a nice rendering it is important to have the exact original height and width,
    // // the easier way to retrieve it is directly from the svg string
    // // but be careful, this is an ugly fix for a flutter_svg problem that works
    // // with my images
    // String temp = svgString.substring(svgString.indexOf('height="') + 8);
    // int originalHeight = int.parse(temp.substring(0, temp.indexOf('p')));
    // temp = svgString.substring(svgString.indexOf('width="') + 7);
    // int originalWidth = int.parse(temp.substring(0, temp.indexOf('p')));

    // // toPicture() and toImage() don't seem to be pixel ratio aware, so we calculate the actual sizes here
    // double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

    // double width = originalHeight *
    //     devicePixelRatio; // where 32 is your SVG's original width
    // double height = originalWidth * devicePixelRatio; // same thing

    // // Convert to ui.Picture
    // ui.Picture picture = svgDrawableRoot.toPicture(size: Size(width, height));

    // // Convert to ui.Image. toImage() takes width and height as parameters
    // // you need to find the best size to suit your needs and take into account the screen DPI
    // ui.Image image = await picture.toImage(width.toInt(), height.toInt());
    // ByteData bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    // // finally to Bitmap
    // Bitmap bitmap = await Bitmap.fromHeadless(
    //     width.toInt(), height.toInt(), bytes.buffer.asUint8List());

    // // if you need to save it:
    // File file = File('temporary_file_path/unique_name.bmp');
    // file.writeAsBytesSync(bitmap.content);

    // var d = await Globals.svgStringToPngBytes(svg, 200, 200);
    // return pdfWidget.Image(pdfWidget.MemoryImage(d));
    String url =
        'https://saffoury.com/SaffouryPaper2/print/headers/headerA4IMG.php?color=${getPrintablePrimaryColor(null)}&darkColor=${getPrintableSecondaryColor(null)}';
    debugPrint("buildHeader $url");
    return pdfWidget.Image(await networkImage(url));
  }

  @override
  String getPrintableInvoiceTitle(BuildContext context, PrintProduct? pca) {
    return getMainHeaderLabelTextOnly(context);
  }

  @override
  String getPrintableSecondaryColor(PrintProduct? setting) {
    return setting?.secondaryColor ?? Colors.grey[700]!.toHex();
  }

  @override
  String getPrintablePrimaryColor(PrintProduct? setting) {
    return setting?.primaryColor ?? Colors.grey[700]!.toHex();
  }

  @override
  String getPrintableQrCode() {
    var q = QRCodeID(
      iD: iD,
      action: getTableNameApi() ?? "",
    );
    return q.getQrCode();
  }

  @override
  String getPrintableQrCodeID() {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss", "en");

    String year = "${dateFormat.parse(date ?? "").year}";
    return "PR-$iD-$year";
  }

  // @override
  // PrintableMaster getModifiablePrintablePdfSetting(BuildContext context) {
  //   Product p = Product();
  //   p.products_types = ProductType()..name = "sappi";
  //   p.sizes = ProductSize();
  //   p.sizes?.length = 1000;
  //   p.sizes?.width = 700;

  //   p.gsms = GSM()..gsm = 300;
  //   return p;
  // }

  double findRemainingWeightCut(Warehouse warehouse) {
    return getQuantity(warehouse: warehouse) -
        cut_request_quantity.toNonNullable();
  }

  double findRemainingWeightCutReservation(Warehouse warehouse) {
    return getQuantity(warehouse: warehouse) -
        cut_request_quantity.toNonNullable() -
        pending_reservation_invoice.toNonNullable();
  }

  bool hasMovement() {
    return order_refunds_order_details_count.toNonNullable() +
            orders_details_count.toNonNullable() +
            purchases_details_count.toNonNullable() +
            purchases_refunds_purchases_details_count.toNonNullable() +
            products_inputs_details_count.toNonNullable() +
            products_outputs_details_count.toNonNullable() +
            transfers_details_count.toNonNullable() +
            cut_requests_count.toNonNullable() !=
        0;
  }

  @override
  List<MenuItemBuildGenirc> getPopupMenuActionsThreeDot(
      BuildContext c, ServerActions? action) {
    return [
      if (hasPermissionAdd(c, viewAbstract: CutRequest()))
        MenuItemBuildGenirc<CutRequest>(
            title: CutRequest().getAddToFormat(c),
            icon: Icons.add,
            route: "/edit",
            value: CutRequest()..products = this)
    ];
  }

  @override
  Future<List<Product>?> listCall(
      {int? count,
      int? page,
      OnResponseCallback? onResponse,
      Map<String, FilterableProviderHelper>? filter,
      required BuildContext context}) async {
    try {
      Iterable l = jsonDecode(jsonEncode(productsJson));
      return List<Product>.from(l.map((model) => fromJsonViewAbstract(model)));
    } catch (e) {
      debugPrint("listCallFake ${e.toString()}");
    }
    return null;
  }

  @override
  Future getPosableInitObj(BuildContext context) {
    return ProductType.init(true).listCall(context: context);
  }

  @override
  Widget getPosableOnAddWidget(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      scrollable: true,
      title: getMainHeaderText(context),
      content: Builder(builder: (context) {
        // Get available height and width of the build area of this widget. Make a choice depending on the size.
        var height = MediaQuery.of(context).size.height;
        var width = MediaQuery.of(context).size.width;

        return SizedBox(
          height: height - 400,
          width: width - 400,
        );
      }),
      actions: <Widget>[
        ElevatedButton(
          child: const Text('CANCEL'),
          onPressed: () {
            // setState(() {
            //   Navigator.pop(context);
            // });
          },
        ),
        ElevatedButton(
          child: const Text('OK'),
          onPressed: () {
            // if (validated == null) return;
            // // debugPrint("textEdit ${_textFieldController.text}");
            // // context.read<CartProvider>().onCartItemAdded(
            // //     context,
            // //     -1,
            // //     widget.object as CartableProductItemInterface,
            // //     double.tryParse(_textFieldController.text ?? "0"));
            // setState(() {
            //   // codeDialog = valueText;
            //   Navigator.pop(context);
            // });
          },
        ),
      ],
    );
  }

  TabControllerHelper getPosableFirstWidget(BuildContext context) {
    return TabControllerHelper(
      "All",
      widget: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 250,
              child: ListHorizontalApiAutoRestWidget(
                titleString: "This week",
                listItembuilder: (v) => PosCardSquareItem(object: v),
                autoRest: AutoRest<Product>(
                    obj: Product()
                      ..setCustomMap({
                        "<dateEnum>": "[\"This week\"]",
                        "requireInventory": "true"
                      }),
                    key: "productsByType<dateEnum>thisWeek"),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 250,
              child: ListHorizontalApiAutoRestWidget(
                titleString: "Today",
                // listItembuilder: (v) => SizedBox(
                //     width: 100, height: 100, child: POSListCardItem(object: v)),
                autoRest: AutoRest<Product>(
                    obj: Product()
                      ..setCustomMap({
                        "<dateEnum>": "[\"Today\"]",
                        "requireInventory": "true"
                      }),
                    key: "productsByType<dateEnum>thisDay"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getSummaryTotal(
      {required BuildContext context, required List<Product> productList}) {
    if (productList.isEmpty) {
      return Card(
        child: ListTile(
          //todo translate
          title: const Text("Select filter data to view list"),
          subtitle: const Text(
              "Start filtering by presssing the filter data to view summary"),
          trailing: ElevatedButton.icon(
            icon: const Icon(Icons.filter_alt_rounded),
            label: const Text("Filter"),
            onPressed: () {},
          ),
        ),
      );
    }
    double getTotalImportQuanity = productList.isEmpty
        ? 0
        : productList
            .map((e) => e.getQuantity())
            .reduce((value, element) => (value) + (element));

    int totalImportedLength = productList.length;

    return ChartCardItemCustom(
      color: Colors.blue,
      icon: Icons.list,
      title: "TOTAL ITEMS IMPORTED",
      description: getTotalImportQuanity.toCurrencyFormat(
          symbol: AppLocalizations.of(context)!.kg),
      footer: totalImportedLength.toCurrencyFormat(),

      // footer: incomes?.length.toString(),
      // footerRightWidget: incomesAnalysis.getGrowthRateText(context),
    );
  }

  Widget getSummary(
      {required BuildContext context,
      required List<Product> productList,
      String customKey = ""}) {
    if (productList.isEmpty) {
      return EmptyWidget.emptyList(context);
    }
    double getTotalImportQuanity = productList.isEmpty
        ? 0
        : productList
            .map((e) => e.getQuantity())
            .reduce((value, element) => (value) + (element));

    int totalImportedLength = productList.length;

    return FileInfoStaggerdGridView(
      childAspectRatio: 16 / 9,
      builder: (crossAxisCount, crossCountFundCalc, crossAxisCountMod, h) {
        return [
          StaggeredGridTile.count(
              crossAxisCellCount: crossCountFundCalc,
              mainAxisCellCount: h,
              child: ChartCardItemCustom(
                color: Colors.blue,
                icon: Icons.list,
                title: "TOTAL ITEMS IMPORTED",
                description: getTotalImportQuanity.toCurrencyFormat(
                    symbol: AppLocalizations.of(context)!.kg),
                footer: totalImportedLength.toCurrencyFormat(),

                // footer: incomes?.length.toString(),
                // footerRightWidget: incomesAnalysis.getGrowthRateText(context),
              )),
          StaggeredGridTile.count(
              crossAxisCellCount: 2,
              mainAxisCellCount: 1,
              child: ChartCardItemCustom(
                color: Colors.blue,
                icon: Icons.list,
                title: "TOTAL ITEMS IMPORTED",
                description: getTotalImportQuanity.toCurrencyFormat(
                    symbol: AppLocalizations.of(context)!.kg),
                footer: totalImportedLength.toCurrencyFormat(),

                // footer: incomes?.length.toString(),
                // footerRightWidget: incomesAnalysis.getGrowthRateText(context),
              )),
          StaggeredGridTile.count(
              crossAxisCellCount: 4,
              mainAxisCellCount: 4,
              child: Card(
                child: SliverApiMixinStaticList(
                  isSliver: false,
                  listKey: "products_goods_working$customKey",
                  list: productList,
                ),
              )),

          // StaggeredGridTile.count(
          //     crossAxisCellCount: 2,
          //     mainAxisCellCount: 1,
          //     child: ChartCardItemCustom(
          //       color: const Color.fromARGB(255, 243, 82, 33),
          //       icon: Icons.barcode_reader,
          //       title: "TOTAL ITEMS SCANED",
          //       description: getTotalImportedFromBarcode.toCurrencyFormat(
          //           symbol: AppLocalizations.of(context)!.kg),
          //       footer: totalImportedBarcodeLength.toCurrencyFormat(),
          //       // footerRightWidget: incomesAnalysis.getGrowthRateText(context),
          //     )),
          // StaggeredGridTile.count(
          //     crossAxisCellCount: crossAxisCount + crossAxisCountMod,
          //     mainAxisCellCount: 1,
          //     child: ChartCardItemCustom(
          //       color: Colors.blue,
          //       // icon: Icons.today,
          //       title: "TOTAL REMAINING",
          //       description: getTotalRemainingImported.toCurrencyFormat(
          //           symbol: AppLocalizations.of(context)!.kg),
          //       footer: totalRemainingLength.toCurrencyFormat(),
          //       // footer: incomes?.length.toString(),
          //       // footerRightWidget: incomesAnalysis.getGrowthRateText(context),
          //     )),
        ];
      },
      wrapWithCard: false,
      // crossAxisCount: getCrossAxisCount(getWidth),

      // width < 1400 ? 1.1 : 1.4,
    );
  }

  @override
  Map<String, String> get getCustomMapOnSearch => {
        "requireInventory": "true",
        if (parent is CutRequest) ...getOnlyReelsCustomParams()
      };
  @override
  Widget getPosableMainWidget(
      BuildContext context, AsyncSnapshot snapshotResponse) {
    var data = snapshotResponse.data as List<ProductType>;
    data.insert(0, ProductType()..availability = 2);
    return Column(
      children: [
        const PosHeader(),
        Expanded(
          child: Container(
              // color: Theme.of(context).colorScheme.background,
              child: TabBarByListWidget(
                  tabs: data
                      .where(
            (element) => element.availability.toNonNullable() > 0,
          )
                      .map((e) {
            if (data.indexOf(e) == 0) {
              return getPosableFirstWidget(context);
            }

            return TabControllerHelper(
              e.name ?? "dsa",
              icon:
                  e.getCardLeadingCircleAvatar(context, height: 20, width: 20),
              widget: POSListWidget(
                autoRest: AutoRest<Product>(
                    obj: Product()
                      ..setCustomMap({
                        "<ProductTypeID>": "${e.iD}",
                        "requireInventory": "true"
                      }),
                    key: "productsByType${e.iD}"),
              ),
            );
          }).toList())),
        ),
      ],
    );
  }

  @override
  Future<List<InvoiceHeaderTitleAndDescriptionInfo>>?
      getPrintableSelfListAccountInfoInBottom(
          BuildContext context, List list, PrintProductList? pca) {
    return null;
  }

  @override
  Future<List<List<InvoiceHeaderTitleAndDescriptionInfo>>>?
      getPrintableSelfListHeaderInfo(
          BuildContext context, List list, PrintProductList? pca) async {
    setTotalsFromPrintable(list.cast());
    return [
      getInvoicDesFirstRow(context, list.cast(), pca),
      getInvoiceDesSecRow(context, list.cast(), pca),
      getInvoiceDesTherdRow(context, list.cast(), pca)
    ];
  }

  List<InvoiceHeaderTitleAndDescriptionInfo> getInvoiceDesSecRow(
      BuildContext context, List<Product> list, PrintProductList? pca) {
    return [
      // InvoiceHeaderTitleAndDescriptionInfo(
      //   title: AppLocalizations.of(context)!.iD,
      //   description: getPrintableQrCodeID(),
      //   // icon: Icons.numbers
      // ),
      if ((pca?.hideDate == false))
        InvoiceHeaderTitleAndDescriptionInfo(
          title: AppLocalizations.of(context)!.date,
          description: "".toDateTimeOnlyDateString().toString(),
          // icon: Icons.date_range
        ),
    ];
  }

  List<InvoiceHeaderTitleAndDescriptionInfo> getInvoiceDesTherdRow(
      BuildContext context, List<Product> list, PrintProductList? pca) {
    double? total;
    if (((pca?.hideQuantity == false))) {
      pca?.currentGroupList?.forEach((element) {
        total = (total ?? 0) + (double.tryParse(element[3]) ?? 0);
      });
    }

    return isComparablePrint()
        ? getInvoiceDesWhenComparable(pca, context, list)
        : getInvoiceDesWhenNotComparable(pca, context, total);
  }

  List<InvoiceHeaderTitleAndDescriptionInfo> getInvoiceDesWhenComparable(
      PrintProductList? pca, BuildContext context, List<Product> list) {
    return [
      InvoiceHeaderTitleAndDescriptionInfo(
          //todo translate
          title: "C.I.Q: Current invdntory quantity",
          description: "$totalQrQuantity items: $totalQrItems",
          hexColor: getPrintablePrimaryColor(
              PrintProduct()..primaryColor = pca?.primaryColor)
          // icon: Icons.tag
          ),
      InvoiceHeaderTitleAndDescriptionInfo(
          //todo translate
          title: "TOTAL ",
          description: "$totalInventoryQuantity items: $totalInventoryItmes",
          hexColor: getPrintablePrimaryColor(
              PrintProduct()..primaryColor = pca?.primaryColor)
          // icon: Icons.tag
          ),
      InvoiceHeaderTitleAndDescriptionInfo(
          //todo translate
          title: "Remainig ",
          description: totalRemaining.toCurrencyFormat(),
          hexColor: getPrintablePrimaryColor(
              PrintProduct()..primaryColor = pca?.primaryColor)
          // icon: Icons.tag
          ),
    ];
  }

  List<InvoiceHeaderTitleAndDescriptionInfo> getInvoiceDesWhenNotComparable(
      PrintProductList? pca, BuildContext context, double? total) {
    return [
      if (pca?.currentGroupNameFromList != null)
        InvoiceHeaderTitleAndDescriptionInfo(
            title: pca?.groupedByField ?? "-",
            description: pca?.currentGroupNameFromList ?? "sad",
            hexColor: getPrintablePrimaryColor(
                PrintProduct()..primaryColor = pca?.primaryColor)
            // icon: Icons.tag
            ),
      if ((pca?.hideQuantity == false))
        InvoiceHeaderTitleAndDescriptionInfo(
            title: AppLocalizations.of(context)!.total,
            description: total.toCurrencyFormat(),
            hexColor: getPrintablePrimaryColor(
                PrintProduct()..primaryColor = pca?.primaryColor)
            // icon: Icons.tag
            ),

      // if (!isPricelessInvoice())
      //   if ((pca?.hideCustomerBalance == false))
      //     InvoiceHeaderTitleAndDescriptionInfo(
      //         title: AppLocalizations.of(context)!.balance,
      //         description: customers?.balance?.toCurrencyFormat() ?? "",
      //         hexColor: getPrintablePrimaryColor(pca)
      //         // icon: Icons.balance
      //         ),
      // if (!isPricelessInvoice())
      //   if ((pca?.hideInvoicePaymentMethod == false))
      //     InvoiceHeaderTitleAndDescriptionInfo(
      //         title: AppLocalizations.of(context)!.paymentMethod,
      //         description: "payment on advanced",
      //         hexColor: getPrintablePrimaryColor(pca)
      //         // icon: Icons.credit_card
      //         ),
    ];
  }

  bool isComparablePrint() {
    return getComparableList() != null && getComparableList()!.isNotEmpty;
  }

  List<InvoiceHeaderTitleAndDescriptionInfo> getInvoicDesFirstRow(
      BuildContext context, List<Product> list, PrintProductList? pca) {
    // if (customers == null) return [];

    List<FilterableProviderHelper> finalList =
        getAllSelectedFiltersRead(context, map: getLastFilterableMap);

    var t = finalList.groupBy((item) => item.mainFieldName,
        valueTransform: (v) => v.mainValuesName[0]);
    List<String> results = [];
    t.forEach((key, value) {
      results.add("- $key:\n  ${value.join(",")}\n");
    });

    return [
      if (getLastFilterableMap?.isNotEmpty == true)
        InvoiceHeaderTitleAndDescriptionInfo(
          title: AppLocalizations.of(context)!.filter,
          description: results.join("\n"),
          // icon: Icons.account_circle_rounded
        ),
      if (pca?.groupedByField != null)
        InvoiceHeaderTitleAndDescriptionInfo(
          title: AppLocalizations.of(context)!.grainOn,
          description: pca?.groupedByField ?? "",
          // icon: Icons.account_circle_rounded
        ),
      // if ((pca?.hideCustomerAddressInfo == false))
      //   if (customers?.address != null)
      //     InvoiceHeaderTitleAndDescriptionInfo(
      //       title: AppLocalizations.of(context)!.addressInfo,
      //       description: customers?.name ?? "",
      //       // icon: Icons.map
      //     ),
      // if ((pca?.hideCustomerPhone == false))
      //   if (customers?.phone != null)
      //     InvoiceHeaderTitleAndDescriptionInfo(
      //       title: AppLocalizations.of(context)!.phone_number,
      //       description: customers?.phone ?? "",
      //       // icon: Icons.phone
      //     ),
    ];
  }

  @override
  String getPrintableSelfListInvoiceTitle(
      BuildContext context, PrintProductList? pca) {
    return isInventoryWorker
        ? AppLocalizations.of(context)!.inventoryprocess
        : getMainHeaderLabelTextOnly(context);
  }

  @override
  String getPrintableSelfListPrimaryColor(PrintProductList? pca) {
    return getPrintablePrimaryColor(
        PrintProduct()..primaryColor = pca?.primaryColor);
  }

  @override
  String getPrintableSelfListQrCode() {
    return "TODO";
  }

  @override
  String getPrintableSelfListQrCodeID() {
    return "TODO";
  }

  @override
  String getPrintableSelfListSecondaryColor(PrintProductList? pca) {
    return getPrintableSecondaryColor(
        PrintProduct()..secondaryColor = pca?.secondaryColor);
  }

  @override
  Map<String, String> getPrintableSelfListTableHeaderAndContent(
      BuildContext context, dynamic item, PrintProductList? pca) {
    item = item as Product;
    return {
      AppLocalizations.of(context)!.iD: item.getIDFormat(context),
      AppLocalizations.of(context)!.description:
          "${item.getProductTypeNameString()}\n${item.getSizeString(context)}",
      AppLocalizations.of(context)!.gsm: item.gsms?.gsm.toString() ?? "0",
      if (((pca?.hideQuantity == false)))
        AppLocalizations.of(context)!.quantity:
            item.getQuantity().toCurrencyFormat(),
      if (((pca?.hideWarehouse == false)))
        AppLocalizations.of(context)!.availableIn:
            item.getWareHouseAvailableIn(context),
      if (((pca?.hideUnitPriceAndTotalPrice == false)))
        AppLocalizations.of(context)!.unit_price:
            item.getUnitSellPrice().toCurrencyFormatFromSetting(context),
    };
  }

  @override
  Product onResponse200K(Product oldValue) {
    qrQuantity = oldValue.qrQuantity;
    return this;
  }

  @override
  Future<List<InvoiceTotalTitleAndDescriptionInfo>>? getPrintableSelfListTotal(
      BuildContext context, List list, PrintProductList? pca) async {
    // return null;
    List<Product> items = list.cast<Product>();
    double total = items.map((e) => (e).getQuantity()).reduce(
        (value, element) => value.toNonNullable() + element.toNonNullable());
    // double total = 231231;
    return [
      InvoiceTotalTitleAndDescriptionInfo(
          title: AppLocalizations.of(context)!.subTotal.toUpperCase(),
          description: total.toCurrencyFormat()),
      InvoiceTotalTitleAndDescriptionInfo(
          title: AppLocalizations.of(context)!.no_summary.toUpperCase(),
          description:
              items.getTotalQuantityGroupedSizeTypeFormattedText(context)),
      InvoiceTotalTitleAndDescriptionInfo(
          title: AppLocalizations.of(context)!.total.toUpperCase(),
          description: items.getTotalQuantityGroupedFormattedText(context)),
      // InvoiceTotalTitleAndDescriptionInfo(
      //     title: AppLocalizations.of(context)!.grandTotal.toUpperCase(),
      //     description: total.toCurrencyFormat(),
      //     hexColor: getPrintableSelfListPrimaryColor(pca)),
    ];
  }

  @override
  Future<List<InvoiceTotalTitleAndDescriptionInfo>>?
      getPrintableSelfListTotalDescripton(
          BuildContext context, List list, PrintProductList? pca) {
    return null;
  }

  @override
  PrintProductList getModifiablePrintableSelfPdfSetting(BuildContext context) {
    return PrintProductList()..product = this;
  }

  @override
  String getCartableQuantityUnit(BuildContext context) {
    return getProductTypeUnit(context);
  }

  @override
  ViewAbstract? getWebCategoryGridableIsMasterToList(BuildContext context) {
    return null;
  }

  @override
  String? getWebCategoryGridableDescription(BuildContext context) {
    return getMainHeaderTextOnly(context);
  }

  @override
  Product getWebCategoryGridableInterface(BuildContext context) {
    return Product();
  }

  @override
  String getWebCategoryGridableTitle(BuildContext context) {
    return getMainHeaderTextOnly(context);
  }

  void addInStock(int quantity, {Warehouse? warehouse}) {
    inStock ??= [
      ...inStock ?? [],
      Stocks()
        ..quantity = quantity.toDouble()
        ..warehouse = warehouse
    ];
  }

  @override
  DashboardContentItem? getPrintableInvoiceTableHeaderAndContentWhenDashboard(
      BuildContext context, PrintLocalSetting? dashboardSetting) {
    return null;
  }

  String getWareHouseAvailableIn(BuildContext context,
      {String joinString = "\n"}) {
    return inStock
            ?.map((o) => o.warehouse?.name ?? "")
            .toList()
            .join(joinString) ??
        "-";
  }

  @override
  String getContentSharable(BuildContext context, {ServerActions? action}) {
    PrintProductList settings =
        getModifiablePrintableSelfPdfSetting(context).copyWithEnableAll();
    return getPrintableSelfListTableHeaderAndContent(context, this, settings)
        .getString(newLineOnSubDetials: true);
  }

  @override
  bool compare(item, comparedItem) {
    if (item == null || comparedItem == null) {
      return false;
    }
    return item?.iD == comparedItem?.iD;
  }

  double getQuantityFromTow(dynamic current, dynamic comparable) {
    Product? p = current as Product?;
    Product? comp = comparable as Product?;
    return (p?.getQuantity().toNonNullable() ?? 0) -
        (p?.qrQuantity.toNonNullable() ?? 0);
  }

  @override
  Map<String, String> getPrintableComparableTableHeaderAndContent(
      BuildContext context, item, comparedItem, PrintProductList? pca) {
    debugPrint(
        "getPrintableComparableTableHeaderAndContent  item=> ${item.runtimeType} compared=>${comparedItem.runtimeType}");
    return {
      //todo translate
      //Current Inventory Quantity
      "C.I.Q":
          item == null ? "0" : (item as Product).qrQuantity.toCurrencyFormat(),
      AppLocalizations.of(context)!.remaning:
          getQuantityFromTow(item, comparedItem).toString()
    };
  }

  List? _comparedList;

  set setComparedList(List? l) {
    _comparedList = l;
  }

  @override
  List? getComparableList() {
    return _comparedList;
  }

  @override
  bool getPrintableSupportsLabelPrinting() => true;

  // @override
  // String getUri(BuildContext context) {
  //   return "https://saffoury.com/view/products/$iD";
  // }
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
  IconData getFieldLabelIconData(BuildContext context, ProductStatus field) {
    switch (field) {
      case NONE:
        return Icons.disabled_by_default;
      case PENDING:
        return Icons.pending;
      case RETURNED:
        return Icons.arrow_back;
      case WASTED:
        return Icons.delete;
    }
  }

  @override
  List<ProductStatus> getValues() {
    return ProductStatus.values;
  }
}
// enum ProductTypePalletOrRoll implements ViewAbstractEnum<ProductTypePalletOrRoll> {

// }
