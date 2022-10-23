import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_saffoury_paper/models/cities/countries_manufactures.dart';
import 'package:flutter_saffoury_paper/models/customs/customs_declarations.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/reservation_invoice.dart';
import 'package:flutter_saffoury_paper/models/invoices/refund_invoices/orders_refunds.dart';
import 'package:flutter_saffoury_paper/models/prints/print_product.dart';
import 'package:flutter_saffoury_paper/models/prints/printable_product_label_widgets.dart';
import 'package:flutter_saffoury_paper/models/products/grades.dart';
import 'package:flutter_saffoury_paper/models/products/gsms.dart';
import 'package:flutter_saffoury_paper/models/products/products_types.dart';
import 'package:flutter_saffoury_paper/models/products/products_color.dart';
import 'package:flutter_saffoury_paper/models/products/qualities.dart';
import 'package:flutter_saffoury_paper/models/products/stocks.dart';
import 'package:flutter_saffoury_paper/models/products/warehouse.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/helper_model/qr_code.dart';
import 'package:flutter_view_controller/interfaces/cartable_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_custom_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/interfaces/settings/ModifiableInterfaceAndPrintingSetting.dart';
import 'package:flutter_view_controller/models/apis/changes_records.dart';
import 'package:flutter_view_controller/models/apis/chart_records.dart';
import 'package:flutter_view_controller/models/apis/date_object.dart';
import 'package:flutter_view_controller/models/apis/unused_records.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/prints/print_commad_abstract.dart';
// import 'package:flutter_view_controller/interfaces/settings/printable_setting.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/new_screens/edit/base_edit_screen.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_auto_rest_custom_view_horizontal.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_auto_rest_horizontal.dart';
import 'package:flutter_view_controller/printing_generator/ext.dart';
import 'package:flutter_view_controller/providers/cart/cart_provider.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pdf/pdf.dart' as pdf;
import 'package:pdf/widgets.dart' as pdfWidget;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../invoices/cuts_invoices/cut_requests.dart';
import '../invoices/orders.dart';
import '../invoices/priceless_invoices/products_inputs.dart';
import '../invoices/priceless_invoices/products_outputs.dart';
import '../invoices/priceless_invoices/transfers.dart';
import '../invoices/purchases.dart';
import '../invoices/refund_invoices/purchasers_refunds.dart';
import 'sizes.dart' as sizeProduct;
part 'products.g.dart';

@JsonSerializable(
  explicitToJson: true,
)
@reflector
class Product extends ViewAbstract<Product>
    implements
        CartableProductItemInterface,
        ModifiablePrintableInterface<PrintProduct>,
        PrintableCustomInterface<PrintProduct> {
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
  double? cut_request_quantity;

  // Product parent;
  ProductType? products_types;
  CustomsDeclaration? customs_declarations;
  CountryManufacture? countries_manufactures;
  sizeProduct.Size? sizes;
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
        "sizes": sizeProduct.Size(),
        "gsms": GSM(),
        "qualities": Quality(),
        "grades": Grades(),
        "products_colors": ProductsColor(),
        "inStock": List<Stocks>.empty()
      };

  Product() : super() {
    date = "".toDateTimeNowString();
  }

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

  int getReams() {
    if (sheets.toNonNullable() == 0) return 0;
    return getQuantity().toInt();
  }

  double getSheets() {
    return getQuantity() / (getSheetWeight() / 1000);
  }

  ///get sheet weight by  grsm
  double getSheetWeight() {
    try {
      return (getWidth() * getLength() * getGSM()).toDouble() / 1000000;
    } catch (e) {
      return 0;
    }
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
    return "TODO";
  }

  bool isRollCut() {
    //todo check type of value return  is cutrequest
    return products != null;
  }

  String getCountryNameString() {
    //TODO if cutrequest return syria;
    if (isRollCut()) {
      return "Syria";
    }
    return "TODO";
  }

  String getCutRequestID() {
    return "TODO";
  }

  String getCustomerNameIfCutRequest() {
    return "TODO";
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

  Widget getWelcomHome(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.account_circle),
      title: Text("Welcom back"),
      trailing: Icon(Icons.arrow_right_outlined),
    );
  }

  @override
  List<Widget> getHorizotalList(BuildContext context) {
    return [
      getWelcomHome(context),
      Row(
        children: [
          Expanded(
            child: ListHorizontalCustomViewApiAutoRestWidget(
                titleString: "TEST1 ",
                autoRest: ChangesRecords.init(Product(), "status")),
          ),
          Expanded(
            child: ListHorizontalCustomViewApiAutoRestWidget(
                titleString: "TEST1 ",
                autoRest: ChangesRecords.init(Product(), "ProductTypeID")),
          )
        ],
      ),
      ListHorizontalCustomViewApiAutoRestWidget(
          titleString: "TEST1 ",
          autoRest: ChartRecordAnalysis.init(
              Order(), DateObject(), EnteryInteval.monthy)),

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

  @override
  PrintProduct? getPrintCommand(BuildContext context) =>
      PrintProduct(printObject: this);

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
  getModifibleSettingObject(BuildContext context) =>
      PrintProduct(printObject: this);

  @override
  String getModifibleTitleName(BuildContext context) =>
      getMainHeaderLabelTextOnly(context);

  @override
  Future<pdfWidget.Widget?>? getPrintableCustomFooter(BuildContext context,
          {pdf.PdfPageFormat? format}) =>
      null;
  // null;

  @override
  Future<pdfWidget.Widget?>? getPrintableCustomHeader(BuildContext context,
          {pdf.PdfPageFormat? format}) =>
      null;

  @override
  Future<List<pdfWidget.Widget>> getPrintableCustomPage(BuildContext context,
      {pdf.PdfPageFormat? format}) async {
    pdfWidget.Widget header = await buildHeader();

    return [
      pdfWidget.Stack(
          alignment: pdfWidget.Alignment.bottomRight,
          fit: pdfWidget.StackFit.loose,
          // alignment: ,
          children: [header, buildTitle(context, this)]),
      ProductLabelPDF(context, this).generate()
      //  Row(
      // crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.start,
      // children: [
      //   Expanded(flex: 3, child: buildTable()),
      //   Expanded(flex: 1, child: buildQrCode())
      // ])
    ];
  }

  Future<
      pdfWidget
          .Widget> buildHeader() async => pdfWidget.Image(await networkImage(
      'https://saffoury.com/SaffouryPaper2/print/headers/headerA4IMG.php?color=${getPrintablePrimaryColor()}&darkColor=${getPrintableSecondaryColor()}'));

  @override
  String getPrintableInvoiceTitle(BuildContext context, PrintProduct? pca) {
    return getMainHeaderLabelTextOnly(context);
  }

  @override
  String getPrintablePrimaryColor() => Colors.grey.toHex();

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
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

    String year = "${dateFormat.parse(date ?? "").year}";
    return "PR-$iD-$year";
  }

  @override
  String getPrintableSecondaryColor() => Colors.grey.toHex();

  @override
  PrintableMaster getModifiablePrintablePdfSetting(BuildContext context) {
    Product p = new Product();
    p.products_types = ProductType()..name = "sappi";
    p.sizes = sizeProduct.Size();
    p.sizes?.length = 1000;
    p.sizes?.width = 700;

    p.gsms = GSM()..gsm = 300;
    return p;
  }

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
