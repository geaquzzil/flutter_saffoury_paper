import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/invoices/cuts_invoices/cut_request_results.dart';
import 'package:flutter_saffoury_paper/models/invoices/cuts_invoices/sizes_cut_requests.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/products_inputs.dart';
import 'package:flutter_saffoury_paper/models/prints/cut_requests/printable_cut_request_recipt.dart';
import 'package:flutter_saffoury_paper/models/prints/print_cut_request.dart';
import 'package:flutter_saffoury_paper/models/prints/cut_requests/printable_cut_request_product_label_pdf.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_saffoury_paper/models/products/sizes.dart';
import 'package:flutter_saffoury_paper/models/users/customers.dart';
import 'package:flutter_saffoury_paper/models/users/employees.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/helper_model/qr_code.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_custom_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_invoice_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/interfaces/settings/ModifiableInterfaceAndPrintingSetting.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/models/view_abstract_inputs_validaters.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_auto_rest.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_auto_rest_horizontal.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:pdf/src/widgets/document.dart';
import 'package:pdf/src/pdf/page_format.dart';
import 'package:pdf/src/widgets/theme.dart';
part 'cut_requests.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class CutRequest extends ViewAbstract<CutRequest>
    implements
        PrintableCustomFromPDFInterface<PrintCutRequest>,
        ModifiablePrintableInterface<PrintCutRequest> {
  // int? ProductID;
  // int? CustomerID;
  // int? EmployeeID;

  String? date;
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
  }

  @override
  CutRequest getSelfNewInstance() {
    return CutRequest();
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() => {
        "date": "",
        "comments": "",
        "quantity": "",
        "cut_status": CutStatus.PENDING,
        "products": Product(),
        "customers": Customer(),
        "employees": Employee(),
        "cut_request_results": List<CutRequestResult>.empty(),
        "cut_request_results_count": 0,
        "sizes_cut_requests": List<SizesCutRequest>.empty(),
        "sizes_cut_requests_count": 0
      };
  @override
  Map<ServerActions, List<String>>? isRequiredObjectsList() => {
        ServerActions.edit: ["cut_request_results", "sizes_cut_requests"],
        ServerActions.view: ["cut_request_results", "sizes_cut_requests"],
      };

  @override
  Text? getMainSubtitleHeaderText(BuildContext context) {
    return Text(
      customers?.name ?? "",
    );
  }

  @override
  bool isRequiredObjectsListChecker() {
    return cut_request_results?.length == cut_request_results_count;
  }

  @override
  Future<bool> hasPermissionDelete(BuildContext context,
      {ViewAbstract? viewAbstract}) async {
    if (cut_request_results_count.toNonNullable() > 0) return false;
    return super.hasPermissionDelete(context);
  }

  @override
  List<String> getMainFields() => [
        "products",
        "customers",
        "employee",
        "date",
        "quantity",
        "cut_status",
        "comments"
      ];

  @override
  Map<String, IconData> getFieldIconDataMap() => {
        "date": Icons.date_range,
        "quantity": Icons.scale,
        "cut_status": Icons.reorder,
        "comments": Icons.comment
      };

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {
        "date": AppLocalizations.of(context)!.date,
        "quantity": AppLocalizations.of(context)!.quantity,
        "cut_status": AppLocalizations.of(context)!.status,
        "comments": AppLocalizations.of(context)!.comments,
      };

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
  String? getSortByFieldName() => "date";

  @override
  SortByType getSortByType() => SortByType.DESC;

  @override
  String? getTableNameApi() => "cut_requests";

  @override
  ViewAbstractControllerInputType getInputType(String field) {
    return field == "products"
        ? ViewAbstractControllerInputType.DROP_DOWN_TEXT_SEARCH_API
        : ViewAbstractControllerInputType.EDIT_TEXT;
  }

  @override
  Map<String, bool> getTextInputIsAutoCompleteMap() => {};

  @override
  Map<String, bool> getTextInputIsAutoCompleteViewAbstractMap() => {};

  @override
  Map<String, int> getTextInputMaxLengthMap() => {"quantity": 10};

  @override
  Map<String, double> getTextInputMaxValidateMap() =>
      {"quantity": products?.getQuantity() ?? 1};

  @override
  Map<String, double> getTextInputMinValidateMap() => {"quantity": 1};
  @override
  Widget? getCustomTopWidget(BuildContext context, ServerActions action) {
    if (action == ServerActions.view) {
      return ListHorizontalApiAutoRestWidget(
        customHeight: 800,
        title: getMainHeaderText(context),
        autoRest: AutoRest<CutRequest>(
            obj: CutRequest()
              ..setCustomMap({"<CustomerID>": "${customers?.iD}"}),
            key: "CustomerByCutRequest$iD"),
      );
    }
  }

  @override
  Map<String, TextInputType?> getTextInputTypeMap() => {
        "date": TextInputType.datetime,
        "quantity": TextInputType.number,
        "comments": TextInputType.text
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

  @override
  PrintableMaster<PrintLocalSetting> getModifiablePrintablePdfSetting(
      BuildContext context) {
    CutRequest o = CutRequest();
    o.cut_status = CutStatus.COMPLETED;
    ProductSize size = ProductSize();
    size.width = 700;
    size.length = 1000;
    o.sizes_cut_requests = [];
    o.sizes_cut_requests =
        List.generate(5, (index) => SizesCutRequest()..sizes = size);
    o.products = Product().getModifiablePrintablePdfSetting(context) as Product;
    o.quantity = 231;

    debugPrint("getModifiablePrintablePdfSetting ${o.runtimeType}");
    (o).customers = Customer()..name = "Customer name";
    o.customers?.address = "Damascus - Syria";
    o.customers?.phone = "099999999";
    o.employees = Employee()..name = "Employee name";
    o.cut_request_results ??= [];
    o.cut_request_results!.add(CutRequestResult());
    o.cut_request_results![0].products_inputs = ProductInput();
    o.cut_request_results![0].products_inputs!.products_inputs_details =
        List.generate(
            2,
            (index) => ProductInputDetails()
              ..setProduct(Product().getModifiablePrintablePdfSetting(context)
                  as Product));

    return o;
  }

  String getRequestSizes(BuildContext context) {
    List<String>? requestSizes = sizes_cut_requests?.map((element) {
      return "- ${element.getMainHeaderTextOnly(context)}";
    }).toList();
    return requestSizes?.join("\n") ?? "-";
  }

  double? getTotalWaste() {
    double? total;
    cut_request_results?.forEach((element) {
      try {
        var d = element.products_inputs?.products_inputs_details
            ?.where(
                (element) => element.products?.status == ProductStatus.WASTED)
            .map((e) => e.quantity)
            .reduce((value, element) =>
                value.toNonNullable() + element.toNonNullable());
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
  Future<Document> getPrintableCustomFromPDFPage(BuildContext context,
      {required pdf.ThemeData theme,
      PdfPageFormat? format,
      PrintCutRequest? setting}) async {
    CutRequestRecieptPDF productsLabel = CutRequestRecieptPDF(context,
        cutRequest: this, setting: setting, format: format, themeData: theme);

    return await productsLabel.generate();
  }
}

// enum CutStatus {
//   @JsonValue("PENDING")
//   PENDING,
//   @JsonValue("PROCESSING")
//   PROCESSING,
//   @JsonValue("COMPLETED")
//   COMPLETED
// }

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
