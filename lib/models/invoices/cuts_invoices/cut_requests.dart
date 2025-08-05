// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_saffoury_paper/models/funds/currency/currency.dart';
import 'package:flutter_saffoury_paper/models/invoices/cuts_invoices/cut_request_results.dart';
import 'package:flutter_saffoury_paper/models/invoices/cuts_invoices/sizes_cut_requests.dart';
import 'package:flutter_saffoury_paper/models/prints/cut_requests/printable_cut_request_recipt.dart';
import 'package:flutter_saffoury_paper/models/prints/print_cut_request.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_saffoury_paper/models/products/sizes.dart';
import 'package:flutter_saffoury_paper/models/users/customers.dart';
import 'package:flutter_saffoury_paper/models/users/employees.dart';
import 'package:flutter_saffoury_paper/widgets/cut_request_custom_listable_header.dart';
import 'package:flutter_saffoury_paper/widgets/cut_request_top_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/helper_model/qr_code.dart';
import 'package:flutter_view_controller/interfaces/listable_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_custom_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/interfaces/settings/ModifiableInterfaceAndPrintingSetting.dart';
import 'package:flutter_view_controller/interfaces/sharable_interface.dart';
import 'package:flutter_view_controller/interfaces/web/category_gridable_interface.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/apis/changes_records.dart';
import 'package:flutter_view_controller/models/apis/chart_records.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/models/request_options.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/models/view_abstract_inputs_validaters.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:flutter_view_controller/new_components/header_description.dart';
import 'package:flutter_view_controller/new_screens/controllers/ext.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_view_abstract_new.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pdf/pdf.dart' as pdf2;
import 'package:pdf/widgets.dart' as pdf;

part 'cut_requests.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class CutRequest extends ViewAbstract<CutRequest>
    with ModifiableInterface<PrintCutRequest>
    implements
        ListableInterface<SizesCutRequest>,
        WebCategoryGridableInterface<CutRequest>,
        PrintableCustomFromPDFInterface<PrintCutRequest>,
        // PrintableCustomFromPDFInterface<PrintCutRequest>,
        SharableInterface {
  // int? ProductID;
  // int? CustomerID;
  // int? EmployeeID;

  String? date;
  @JsonKey(fromJson: convertToStringFromString)
  String? comments;
  double? quantity;
  CutStatus? cut_status;

  Product? products;
  Customer? customers;
  Employee? employees;

  List<CutRequestResult>? cut_request_results;
  int? cut_request_results_count;

  List<SizesCutRequest>? sizes_cut_requests;
  int? sizes_cut_requests_count;

  CutRequest() : super() {
    date = "".toDateTimeNowString();
    sizes_cut_requests = <SizesCutRequest>[];
    cut_status = CutStatus.PENDING;
  }

  Widget getPendingCutRequestWidget() {
    return SliverApiMixinViewAbstractWidget(
      isSliver: true,
      //todo translate
      header: HeaderDescription(title: "Pending", isSliver: true),
      // listItembuilder: (v) =>
      //     ListItemProductTypeCategory(productType: v as ProductType),
      toListObject: CutRequest().setRequestOption(
        option: RequestOptions().addSearchByField("cut_status", "PENDING"),
      ),
    );
  }

  @override
  List<Widget>? getHomeListHeaderWidgetList(BuildContext context) {
    return null;
    return [getPendingCutRequestWidget()];
  }

  @override
  List<StaggeredGridTile> getHomeHorizotalList(BuildContext context) {
    num mainAxisCellCount = SizeConfig.getMainAxisCellCount(context);
    num mainAxisCellCountList = SizeConfig.getMainAxisCellCount(
      context,
      mainAxisType: MainAxisType.ListHorizontal,
    );
    return [
      StaggeredGridTile.count(
        crossAxisCellCount: 2,
        mainAxisCellCount: mainAxisCellCountList,
        child: getPendingCutRequestWidget(),
      ),
      StaggeredGridTile.count(
        crossAxisCellCount: 2,
        mainAxisCellCount: mainAxisCellCount,
        child: SliverApiMixinViewAbstractWidget(
          isSliver: false,
          toListObject: ChangesRecords.init(getSelfNewInstance(), "cut_status"),
        ),
      ),
      StaggeredGridTile.count(
        crossAxisCellCount: 2,
        mainAxisCellCount: mainAxisCellCount,
        child: SliverApiMixinViewAbstractWidget(
          isSliver: false,
          toListObject: ChartRecordAnalysis.init(CutRequest()),
        ),
      ),
    ];
  }

  @override
  void onBeforeGenerateView(BuildContext context, {ServerActions? action}) {
    super.onBeforeGenerateView(context);
    if (action == ServerActions.edit && isNew()) {
      employees = Employee().getSavedUser(context);
    }
  }

  @override
  bool hasPermissionEdit(BuildContext context, {ViewAbstract? viewAbstract}) {
    if (cut_request_results_count.toNonNullable() > 0) return false;
    return super.hasPermissionEdit(context, viewAbstract: viewAbstract);
  }

  @override
  CutRequest getSelfNewInstance() {
    return CutRequest();
  }

  @override
  String? getTextInputValidatorOnAutocompleteSelected(
    BuildContext context,
    String field,
    ViewAbstract value,
  ) {
    if (field == "products") {
      if (!(value as Product).isRoll()) {
        return AppLocalizations.of(
          context,
        )!.errFieldNotSelected(Product().getMainHeaderLabelTextOnly(context));
      }
    } else {
      return null;
    }
    return null;
  }

  @override
  void onTextChangeListener(
    BuildContext context,
    String field,
    String? value, {
    GlobalKey<FormBuilderState>? formKey,
  }) {
    super.onTextChangeListener(context, field, value);
    if (field == "quantity") {
      setFieldValue(field, double.tryParse(value ?? "0") ?? 0);
    }
  }

  @override
  CutRequest? onAfterValidate(BuildContext context) {
    debugPrint("onAfterValidate for $runtimeType");
    if (products == null) return null;
    if (getTotalRequestSizesWidth() != products!.getWidth()) return null;
    if (getTotalRemainingQuantity() != quantity) return null;
    return super.onAfterValidate(context);
  }

  int findMaxWidth() {
    return products?.getWidth() ?? 0;
  }

  int findMinWidth() {
    return 1;
  }

  @override
  RequestOptions? getRequestOption({
    required ServerActions action,
    RequestOptions? generatedOptionFromListCall,
  }) {
    return RequestOptions()
        .addSortBy("date", SortByType.DESC)
        .addRequestObjcets(true);
  }

  @override
  List<String>? getRequestedForginListOnCall({required ServerActions action}) {
    if (action == ServerActions.list) {
      return null;
    }
    return ["cut_request_results", "sizes_cut_requests"];
  }

  @override
  Widget? getMainSubtitleHeaderText(
    BuildContext context, {
    String? searchQuery,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      // mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (customers != null)
          customers!.getMainHeaderLabelWithTextWidgt(context: context),
        getSpace(height: 4),
        getLabelWithTextWidget(
          AppLocalizations.of(context)!.quantity,
          quantity.toCurrencyFormat(symbol: AppLocalizations.of(context)!.kg),
          context: context,
        ),
        getSpace(height: 4),
        if (cut_status != null)
          getLabelWithTextWidget(
            cut_status!.getMainLabelText(context),
            cut_status!.getFieldLabelString(context, cut_status!),
            color: getCutStatusColor(),
            context: context,
          ),
      ],
    );
  }

  @override
  bool hasPermissionDelete(BuildContext context, {ViewAbstract? viewAbstract}) {
    if (cut_request_results_count.toNonNullable() > 0) return false;
    return super.hasPermissionDelete(context);
  }

  @override
  void onAutoComplete(
    BuildContext context,
    String field,
    value, {
    GlobalKey<FormBuilderState>? formKey,
  }) {
    super.onAutoComplete(context, field, value);
    if (field == "products") {
      if (value != null) {
        quantity = (value as Product).getQuantity();
      }
    }
  }

  @override
  List<String> getMainFields({BuildContext? context}) => [
    "products",
    "date",
    "quantity",
    "cut_status",
    "comments",
    "customers",
    "employees",
  ];

  @override
  Map<String, IconData> getFieldIconDataMap() => {
    "date": Icons.date_range,
    "quantity": Icons.scale,
    "cut_status": Icons.reorder,
    "comments": Icons.comment,
  };

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {
    "date": AppLocalizations.of(context)!.date,
    "quantity": AppLocalizations.of(context)!.quantity,
    "cut_status": AppLocalizations.of(context)!.status,
    "comments": AppLocalizations.of(context)!.comments,
  };
  @override
  String? getImageUrl(BuildContext context) {
    return products?.getImageUrl(context);
  }

  @override
  List<Widget>? getCustomTopWidget(
    BuildContext context, {
    ServerActions? action,
    SecoundPaneHelperWithParentValueNotifier? basePage,
    ValueNotifier<ViewAbstract?>? onHorizontalListItemClicked,
    ValueNotifier<SecondPaneHelper?>? onClick,
    bool? isFromFirstAndSecPane,
    dynamic extras,
  }) {
    if ((action == ServerActions.view || action == ServerActions.edit) &&
        products != null &&
        cut_status == CutStatus.COMPLETED) {
      return [CutRequestTopWidget(object: this)];
    }
    return null;
  }

  double getSheetWeight(SizesCutRequest size) {
    return products?.getSheetWeight(customSize: size.sizes) ?? 0;
  }

  String getSheetWeightStirngFormat({
    required BuildContext context,
    required SizesCutRequest size,
  }) {
    return products?.getSheetWeightStringFormat(
          context: context,
          customSize: size.sizes,
        ) ??
        "-";
  }

  double getOnSheetPrice(SizesCutRequest size) {
    return products?.getOneSheetPrice(customSize: size.sizes) ?? 0;
  }

  String getOnSheetPriceSringFormat({
    required BuildContext context,
    required SizesCutRequest size,
  }) {
    return products?.getOneSheetPriceStringFormat(
          context: context,
          customSize: size.sizes,
        ) ??
        "-";
  }

  double getSheetsNumber(SizesCutRequest size) {
    return products?.getSheets(
          customSize: size.sizes,
          customQuantity: size.quantity,
        ) ??
        0;
  }

  @override
  String? getMainDrawerGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.invoice;

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.cutRequest;

  @override
  String getMainHeaderTextOnly(BuildContext context) =>
      "${getIDFormat(context)} : ${products?.getMainHeaderTextOnly(context)} ";

  @override
  IconData getMainIconData() => Icons.content_cut;

  @override
  String? getTableNameApi() => "cut_requests";

  @override
  FormFieldControllerType getInputType(String field) {
    return field == "products"
        ? FormFieldControllerType.DROP_DOWN_TEXT_SEARCH_API
        : FormFieldControllerType.EDIT_TEXT;
  }

  @override
  Map<String, bool> getTextInputIsAutoCompleteMap() => {};

  @override
  Map<String, bool> getTextInputIsAutoCompleteViewAbstractMap() => {};

  @override
  Map<String, int> getTextInputMaxLengthMap() => {"quantity": 10};

  @override
  Map<String, double> getTextInputMaxValidateMap() => {
    "quantity": products?.getQuantity() ?? 1,
  };

  @override
  Map<String, double> getTextInputMinValidateMap() => {"quantity": 1};

  @override
  List<Widget>? getCustomBottomWidget(
    BuildContext context, {
    ServerActions? action,
    ValueNotifier<ViewAbstract?>? onHorizontalListItemClicked,
  }) {
    if (action == ServerActions.view) {
      return [
        SliverApiMixinViewAbstractWidget(
          // customHeight: 250,
          header: HeaderDescription(
            isSliver: true,
            title: AppLocalizations.of(
              context,
            )!.moreFromFormat(customers?.name ?? ""),
          ),
          toListObject: CutRequest().setRequestOption(
            option: RequestOptions().addSearchByField(
              "CustomerID",
              customers?.iD,
            ),
          ),
        ),
      ];
    }
    return null;
  }

  @override
  bool isListableIsImagable() {
    return false;
  }

  @override
  Map<String, TextInputType?> getTextInputTypeMap() => {
    "date": TextInputType.datetime,
    "quantity": TextInputType.number,
    "comments": TextInputType.multiline,
  };

  @override
  Map<String, bool> isFieldCanBeNullableMap() => {"customers": true};

  @override
  Map<String, bool> isFieldRequiredMap() => {"quantity": true};

  factory CutRequest.fromJson(Map<String, dynamic> data) =>
      _$CutRequestFromJson(data);

  Map<String, dynamic> toJson() => _$CutRequestToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  CutRequest fromJsonViewAbstract(Map<String, dynamic> json) =>
      CutRequest.fromJson(json);

  @override
  String getModifiableMainGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.printerSetting;

  // @override
  // PrintableMaster<PrintLocalSetting> getModifiablePrintablePdfSetting(
  //     BuildContext context) {
  //   CutRequest o = CutRequest();
  //   o.cut_status = CutStatus.COMPLETED;
  //   ProductSize size = ProductSize();
  //   size.width = 700;
  //   size.length = 1000;
  //   o.sizes_cut_requests = [];
  //   o.sizes_cut_requests =
  //       List.generate(5, (index) => SizesCutRequest()..sizes = size);
  //   o.products = Product().getModifiablePrintablePdfSetting(context) as Product;
  //   o.quantity = 231;

  //   debugPrint("getModifiablePrintablePdfSetting ${o.runtimeType}");
  //   (o).customers = Customer()..name = "Customer name";
  //   o.customers?.address = "Damascus - Syria";
  //   o.customers?.phone = "099999999";
  //   o.employees = Employee()..name = "Employee name";
  //   o.cut_request_results ??= [];
  //   o.cut_request_results!.add(CutRequestResult());
  //   o.cut_request_results![0].products_inputs = ProductInput();
  //   o.cut_request_results![0].products_inputs!.products_inputs_details =
  //       List.generate(
  //           2,
  //           (index) => ProductInputDetails()
  //             ..setProduct(
  //                 context,
  //                 Product().getModifiablePrintablePdfSetting(context)
  //                     as Product));

  //   return o;
  // }

  String getRequestSizes(BuildContext context) {
    List<String>? requestSizes = sizes_cut_requests?.map((element) {
      return "- ${element.getMainHeaderTextOnly(context)}";
    }).toList();
    return requestSizes?.join("\n") ?? "-";
  }

  int getTotalRequestSizesWidth() {
    if (getListableList().isEmpty) return 0;

    int valu = getListableList()
        .toSet()
        .map((e) => e.sizes!.width)
        .reduce(
          (value, element) => value.toNonNullable() + element.toNonNullable(),
        )
        .toNonNullable();
    return valu <= 0 ? 0 : valu;
  }

  double? getTotalRemainingQuantity() {
    if (products == null) return null;
    if (getListableList().isEmpty) return null;
    double valu =
        getListableList()
            .map((e) => e.quantity)
            .reduce(
              (value, element) =>
                  value.toNonNullable() + element.toNonNullable(),
            )
            .toNonNullable() -
        (products?.getQuantity().toNonNullable() ?? 0);
    return valu <= 0 ? 0 : valu;
  }

  int getTotalRemainingRequestSizesWidth() {
    return (products?.getWidth().toNonNullable() ?? 0) -
        getTotalRequestSizesWidth();
  }

  double? getTotalWaste() {
    double? total;
    cut_request_results?.forEach((element) {
      try {
        var d = element.products_inputs?.products_inputs_details
            ?.where(
              (element) => element.products?.status == ProductStatus.WASTED,
            )
            .map((e) => e.quantity)
            .reduce(
              (value, element) =>
                  value.toNonNullable() + element.toNonNullable(),
            );
        total = total.toNonNullable() + d.toNonNullable();
      } catch (e) {}
    });
    return total;
  }

  @override
  IconData getModifibleIconData() => Icons.print;

  @override
  PrintCutRequest getModifibleSettingObject(BuildContext context) {
    return PrintCutRequest();
  }

  @override
  String getModifibleTitleName(BuildContext context) =>
      getMainHeaderLabelTextOnly(context);

  @override
  String getPrintableInvoiceTitle(BuildContext context, PrintCutRequest? pca) {
    return getMainHeaderLabelTextOnly(context);
  }

  @override
  Color? getMainColor() {
    return Colors.orange;
  }

  @override
  String getPrintablePrimaryColor(PrintCutRequest? setting) {
    return setting?.primaryColor ??
        getMainColor()!.value.toRadixString(16).substring(2, 8);
  }

  @override
  String getPrintableQrCode() {
    var q = QRCodeID(iD: iD, action: getTableNameApi() ?? "");
    return q.getQrCode();
  }

  @override
  String getPrintableQrCodeID() {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss", "en");

    String year = "${dateFormat.parse(date ?? "").year}";
    String invCode = "";
    invCode = "CUT-R";
    return "$invCode-$iD-$year";
  }

  Color getCutStatusColor() {
    switch (cut_status) {
      case CutStatus.COMPLETED:
        return Colors.green;
      case CutStatus.PENDING:
        return Colors.orange;
      case CutStatus.PROCESSING:
        return Colors.greenAccent;
      default:
        Colors.orange;
    }
    return Colors.orange;
  }

  @override
  String getPrintableSecondaryColor(PrintCutRequest? setting) {
    return setting?.secondaryColor ??
        getMainColor()!.darken(.1).value.toRadixString(16).substring(2, 8);
  }

  @override
  Future<pdf.Document> getPrintableCustomFromPDFPage(
    BuildContext context, {
    required pdf.PageTheme theme,
    required pdf.ThemeData themeData,
    pdf2.PdfPageFormat? format,
    PrintCutRequest? setting,
  }) async {
    CutRequestRecieptPDF productsLabel = CutRequestRecieptPDF(
      context,
      cutRequest: this,
      setting: setting,
      format: format,
      themeData: themeData,
      pageTheme: theme,
    );

    return await productsLabel.generate();
  }

  @override
  Future<List<pdf.Page>> getPrintableCustomFromPDFPageLIst(
    BuildContext context, {
    pdf2.PdfPageFormat? format,
    PrintCutRequest? setting,
    required pdf.PageTheme themeData,
  }) {
    // TODO: implement getPrintableCustomFromPDFPageLIst
    throw UnimplementedError();
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  List<SizesCutRequest>? deletedList;

  @override
  SizesCutRequest getListableAddFromManual(BuildContext context) {
    return SizesCutRequest()
      ..sizes = (ProductSize()..width = getTotalRemainingRequestSizesWidth())
      ..quantity = getTotalRemainingQuantity();
  }

  @override
  Widget? getListableCustomHeader(BuildContext context) {
    if (products == null) {
      return const Center(child: Text("Select product to show contents"));
    }
    return CutRequestCustomListableHeader(cutRequest: this);
  }

  @override
  List<ViewAbstract> getListableInitialSelectedListPassedByPickedObject(
    BuildContext context,
  ) {
    if (sizes_cut_requests == null) return [];
    return sizes_cut_requests?.map((e) => e.sizes!).toList() ?? [];
  }

  @override
  List<SizesCutRequest> getListableList() {
    sizes_cut_requests ??= [];
    return sizes_cut_requests!;
  }

  @override
  ViewAbstract? getListablePickObject() {
    return null;
  }

  @override
  double? getListableTotalDiscount(BuildContext context) {
    return null;
  }

  @override
  bool isSupportAddFromManual() {
    return true;
  }

  @override
  double? getListableTotalPrice(BuildContext context) {
    return null;
  }

  @override
  String? getListableTotalQuantity(BuildContext context) {
    return null;
  }

  @override
  bool isListableRequired(BuildContext context) {
    return true;
  }

  @override
  void onListableAddFromManual(
    BuildContext context,
    SizesCutRequest addedObject,
  ) {
    getListableList().add(addedObject);
  }

  @override
  void onListableDelete(SizesCutRequest item) {
    if (item.isEditing()) {
      deletedList ??= [];
      item.delete = true;
      deletedList?.add(item);
    }
    getListableList().remove(item);
  }

  @override
  void onListableListAddedByQrCode(BuildContext context, ViewAbstract? view) {
    // TODO: implement onListableListAddedByQrCode
  }

  @override
  void onListableSelectedListAdded(
    BuildContext context,
    List<ViewAbstract> list,
  ) {
    // TODO: implement onListableSelectedListAdded
  }

  @override
  void onListableUpdate(SizesCutRequest item) {
    // TODO: implement onListableUpdate
  }

  @override
  ViewAbstract? getListablePickObjectQrCode() {
    return null;
  }

  @override
  pdf.Widget? getPrintableWatermark(pdf2.PdfPageFormat? format) {
    return pdf.FullPage(
      ignoreMargins: true,
      child: pdf.Watermark.text(
        'SAFFOURY\n',
        fit: pdf.BoxFit.scaleDown,
        // angle: 0,
        style: pdf.TextStyle.defaultStyle().copyWith(
          fontSize: 80,
          color: pdf2.PdfColors.grey400,
          fontWeight: pdf.FontWeight.bold,
        ),
      ),
    );
  }

  @override
  String? getWebCategoryGridableDescription(BuildContext context) {
    if (cut_status == null) return null;
    return cut_status!.getFieldLabelString(context, cut_status!);
    // return getCutStatusColor()
  }

  @override
  CutRequest getWebCategoryGridableInterface(BuildContext context) {
    return CutRequest();
  }

  @override
  ViewAbstract? getWebCategoryGridableIsMasterToList(BuildContext context) {
    return null;
  }

  @override
  String getWebCategoryGridableTitle(BuildContext context) {
    return getMainHeaderTextOnly(context);
  }

  @override
  DashboardContentItem? getPrintableInvoiceTableHeaderAndContentWhenDashboard(
    BuildContext context,
    PrintLocalSetting? dashboardSetting,
  ) {
    Currency c = Currency.init(context);
    return DashboardContentItem(
      shouldAddToBalance: false,
      showDebitAndCredit: false,
      currency: c.name,
      currencyId: c.iD,
      quantity: quantity.toCurrencyFormat(),
      credit: 0,
      debit: 0,
      date: date,
      description: getMainHeaderTextOnly(context),
    );
  }

  @override
  String getContentSharable(BuildContext context, {ServerActions? action}) {
    String content = getPrintableInvoiceTitle(context, null);
    content = "$content\n\n";
    PrintCutRequest setting = PrintCutRequest().copyWithEnableAll();
    setting.productNameOption = ProductNameOption.ALL;
    setting.printCutRequestType = PrintCutRequestType.ALL;

    CutRequestRecipt crr = CutRequestRecipt(cutRequest: this, setting: setting);
    content =
        "$content ${crr.getPrintableRecieptHeaderTitleAndDescription(context, setting).getString()}";
    return content;
  }

  @override
  bool getPrintableSupportsLabelPrinting() => true;

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() => {
    "customers": Customer(),
    "date": "",
    "comments": "",
    "quantity": 0.toDouble(),
    "cut_status": CutStatus.PENDING,
    "products": Product.initOnlyReelsCustomParams(),
    "employees": Employee(),
    "cut_request_results": List<CutRequestResult>.empty(),
    "cut_request_results_count": 0,
    "sizes_cut_requests": List<SizesCutRequest>.empty(),
    "sizes_cut_requests_count": 0,
  };
}

// enum CutStatus {
//   @JsonValue("PENDING")
//   PENDING,
//   @JsonValue("PROCESSING")
//   PROCESSING,
//   @JsonValue("COMPLETED")
//   COMPLETED
// }
@JsonSerializable(explicitToJson: true)
class ProfitByCutRequest {
  @JsonKey(fromJson: convertToDouble)
  double? cutRequestQuantity;
  @JsonKey(fromJson: convertToDouble)
  double? inputQuantity;

  @JsonKey(fromJson: convertToDouble)
  double? resultQuantity;
  @JsonKey(fromJson: convertToDouble)
  double? totalPrice;
  int? CutRequestID;
  String? date;

  ProfitByCutRequest();

  factory ProfitByCutRequest.fromJson(Map<String, dynamic> data) =>
      _$ProfitByCutRequestFromJson(data);

  Map<String, dynamic> toJson() => _$ProfitByCutRequestToJson(this);
}

enum CutStatus implements ViewAbstractEnum<CutStatus> {
  PENDING,
  PROCESSING,
  COMPLETED;

  @override
  IconData getMainIconData() => Icons.stacked_line_chart_outlined;
  @override
  String getMainLabelText(BuildContext context) =>
      AppLocalizations.of(context)!.status;

  @override
  String getFieldLabelString(BuildContext context, CutStatus field) {
    switch (field) {
      case PENDING:
        return AppLocalizations.of(context)!.pending;
      case PROCESSING:
        return AppLocalizations.of(context)!.processing;
      case COMPLETED:
        return AppLocalizations.of(context)!.completed;
    }
  }

  @override
  IconData getFieldLabelIconData(BuildContext context, CutStatus field) {
    switch (field) {
      case PENDING:
        return Icons.pending;
      case PROCESSING:
        return Icons.settings;
      case COMPLETED:
        return Icons.done;
    }
  }

  @override
  List<CutStatus> getValues() {
    return CutStatus.values;
  }
}
