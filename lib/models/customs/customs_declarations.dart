import 'package:flutter/material.dart' as material;
import 'package:flutter_saffoury_paper/models/customs/customs_declarations_images.dart';
import 'package:flutter_saffoury_paper/models/server/server_data_api.dart';
import 'package:flutter_saffoury_paper/models/users/employees.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/interfaces/listable_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_custom_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/interfaces/sharable_interface.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/models/request_options.dart';
import 'package:flutter_view_controller/models/servers/server_data.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/models/view_abstract_inputs_validaters.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/providers/filterables/fliterable_list_provider_api.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

part 'customs_declarations.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class CustomsDeclaration extends ViewAbstract<CustomsDeclaration>
    implements
        PrintableCustomFromPDFInterface<PrintLocalSetting>,
        ListableInterface<CustomsDeclarationImages>,
        SharableInterface {
  // int? EmployeeID;

  @JsonKey(fromJson: intFromString)
  String? number; //varchar 200
  String? date;

  String? fromCountry; //59
  String? fromName; //50
    @JsonKey(fromJson: convertToString)
  String? comments;

  List<CustomsDeclarationImages>? customs_declarations_images;
  int? customs_declarations_images_count;
  Employee? employees;

  CustomsDeclaration() : super() {
    date = "".toDateTimeNowString();
  }

  @override
  void onBeforeGenerateView(material.BuildContext context,
      {ServerActions? action}) {
    super.onBeforeGenerateView(context);
    if (action == ServerActions.edit && isNew()) {
      material.debugPrint("onBeforeGenerateView");
      employees = context.read<AuthProvider<AuthUser>>().getUser as Employee?;
    }
  }

  @override
  CustomsDeclaration getSelfNewInstance() {
    return CustomsDeclaration();
  }

  @override
  bool getPrintableSupportsLabelPrinting() => false;

  @override
  String getForeignKeyName() {
    return "CustomsDeclarationID";
  }

  @override
  CustomsDeclaration? getSelfNewInstanceFileImporter(
      {required material.BuildContext context, String? field, value}) {
    FilterableDataApi? filterData = context
        .read<FilterableListApiProvider<FilterableData>>()
        .getLastFilterableData() as FilterableDataApi?;
    if (value == null) {
      return null;
    }
    if (filterData != null) {
      CustomsDeclaration? getSearchedValue = filterData.searchForValue(
        this,
        value,
        (p0) =>
            p0.number.toString() == value.toString() ||
            p0.iD.toString() == value.toString(),
      );
      if (getSearchedValue != null) {
        return getSearchedValue;
      }
    }
    return null;
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() => {
        "number": "",
        "date": "",
        "fromCountry": "",
        "fromName": "",
        "comments": "",
        "customs_declarations_images": List<CustomsDeclarationImages>.empty(),
        "customs_declarations_images_count": 0,
        "employees": Employee(),
      };

  @override
  List<String> getMainFields({material.BuildContext? context}) =>
      ["employees", "number", "date", "fromCountry", "fromName", "comments"];

  @override
  RequestOptions? getRequestOption(
      {required ServerActions action,
      RequestOptions? generatedOptionFromListCall}) {
    return RequestOptions().addSortBy("date", SortByType.DESC);
  }

  @override
  List<String>? getRequestedForginListOnCall({required ServerActions action}) {
    return ["customs_declarations_images"];
  }

  @override
  Map<String, material.IconData> getFieldIconDataMap() => {
        "number": material.Icons.onetwothree,
        "date": material.Icons.date_range,
        "fromCountry": material.Icons.domain,
        "fromName": material.Icons.account_circle,
        "comments": material.Icons.notes
      };

  @override
  material.Widget? getMainSubtitleHeaderText(material.BuildContext context,{String? searchQuery}) {
    return material.Column(
      crossAxisAlignment: material.CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.start,
      children: [
        getLabelWithTextWidget(
            AppLocalizations.of(context)!.customsNumber, number.toString(),
            context: context),
        if (comments != null)
          getLabelWithTextWidget(
              AppLocalizations.of(context)!.comments, comments.toString(),
              context: context),

        if ((customs_declarations_images_count ?? 0) > 0)
          getLabelWithTextWidget(AppLocalizations.of(context)!.itemCount,
              customs_declarations_images_count.toString(),
              context: context,
              color: material.Theme.of(context).colorScheme.tertiary),

        // Text("Total:" + extendedNetPrice.toCurrencyFormat()),
        // // Align(
        // //     alignment: AlignmentDirectional.centerEnd,
        // //     child: Text("Date: $date")),
        // Text(
        //   "items: ${getDetailListFromMasterItemsCount()}",
        //   style: Theme.of(context)
        //       .textTheme
        //       .bodySmall!
        //       .copyWith(color: Theme.of(context).colorScheme.primary),
        // )
      ],
    );
  }

  @override
  Map<String, String> getFieldLabelMap(material.BuildContext context) => {
        "number": AppLocalizations.of(context)!.customsNumber,
        "date": AppLocalizations.of(context)!.date,
        "fromCountry": AppLocalizations.of(context)!.country,
        "fromName": AppLocalizations.of(context)!.name,
        "comments": AppLocalizations.of(context)!.comments
      };

  @override
  String? getMainDrawerGroupName(material.BuildContext context) =>
      AppLocalizations.of(context)!.product;

  @override
  String getMainHeaderLabelTextOnly(material.BuildContext context) =>
      AppLocalizations.of(context)!.customs_clearnces;

  @override
  material.IconData getMainIconData() => material.Icons.document_scanner;

  @override
  String? getTableNameApi() => "customs_declarations";

  @override
  Map<String, bool> getTextInputIsAutoCompleteMap() =>
      {"fromCountry": true, "fromName": true};

  @override
  Map<String, bool> getTextInputIsAutoCompleteViewAbstractMap() => {
        "number": true,
      };

  @override
  FormFieldControllerType getInputType(String field) {
    if (field == "number") {
      return FormFieldControllerType.AUTO_COMPLETE_VIEW_ABSTRACT_RESPONSE;
    }
    if (field == "fromCountry" || field == "fromName") {
      return FormFieldControllerType.AUTO_COMPLETE;
    }
    return super.getInputType(field);
  }

  @override
  Map<String, int> getTextInputMaxLengthMap() =>
      {"number": 200, "fromCountry": 50, "fromName": 50};

  @override
  Map<String, double> getTextInputMaxValidateMap() => {};

  @override
  Map<String, double> getTextInputMinValidateMap() => {};

  @override
  Map<String, material.TextInputType?> getTextInputTypeMap() => {
        "number": material.TextInputType.number,
        "date": material.TextInputType.datetime,
        "fromCountry": material.TextInputType.text,
        "fromName": material.TextInputType.text,
        "comments": material.TextInputType.text
      };

  @override
  Map<String, bool> isFieldCanBeNullableMap() => {};

  @override
  Map<String, bool> isFieldRequiredMap() => {"number": true, "employee": true};

  factory CustomsDeclaration.fromJson(Map<String, dynamic> data) =>
      _$CustomsDeclarationFromJson(data);

  Map<String, dynamic> toJson() => _$CustomsDeclarationToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  CustomsDeclaration fromJsonViewAbstract(Map<String, dynamic> json) =>
      CustomsDeclaration.fromJson(json);

  static String? intFromString(dynamic number) => number?.toString();

  @override
  Future<Document> getPrintableCustomFromPDFPage(material.BuildContext context,
      {required PageTheme theme,
      required ThemeData themeData,
      PdfPageFormat? format,
      PrintLocalSetting? setting}) async {
    final pdf = Document(
        title: getMainHeaderTextOnly(context),
        author: AppLocalizations.of(context)!.appTitle,
        creator: AppLocalizations.of(context)!.appTitle,
        subject: getMainHeaderLabelTextOnly(context),
        pageMode: PdfPageMode.fullscreen,
        theme: themeData);

    await Future.forEach<Page>(
        await getPrintableCustomFromPDFPageLIst(context, themeData: theme),
        (element) async {
      pdf.addPage(element);
    });
    return pdf;
  }

  @override
  String getPrintableInvoiceTitle(
      material.BuildContext context, PrintLocalSetting? pca) {
    // TODO: implement getPrintableInvoiceTitle
    throw UnimplementedError();
  }

  @override
  String getPrintablePrimaryColor(PrintLocalSetting? pca) {
    // TODO: implement getPrintablePrimaryColor
    throw UnimplementedError();
  }

  @override
  String getPrintableQrCode() {
    // TODO: implement getPrintableQrCode
    throw UnimplementedError();
  }

  @override
  String getPrintableQrCodeID() {
    return "";
  }

  @override
  String getPrintableSecondaryColor(PrintLocalSetting? pca) {
    // TODO: implement getPrintableSecondaryColor
    throw UnimplementedError();
  }

  @override
  bool isSupportAddFromManual() {
    return false;
  }
  // @override
  // Future<List<Page>> getPrintableCustomFromPDFPageLIst(
  //     material.BuildContext context,
  //     {PdfPageFormat? format,
  //     PrintLocalSetting? setting,
  //     required PageTheme themeData}) {
  //   // TODO: implement getPrintableCustomFromPDFPageLIst
  //   throw UnimplementedError();
  // }

  @override
  Future<List<Page>> getPrintableCustomFromPDFPageLIst(
      material.BuildContext context,
      {PdfPageFormat? format,
      PrintLocalSetting? setting,
      required PageTheme themeData}) async {
    List<Page> pages = [];
    if (customs_declarations_images != null) {
      await Future.forEach<CustomsDeclarationImages?>(
          customs_declarations_images!, (element) async {
        material.debugPrint("getPrintableCustomFromPDFPage ");
        Widget widget = Image(await networkImage(
          'https://${element?.image}',
          cache: true,
        ));
        return pages.add(
          Page(pageTheme: themeData, build: (context) => widget),
        );
      });
    }
    return pages;
  }

  @override
  String getMainHeaderTextOnly(material.BuildContext context) =>
      "${getIDFormat(context)} ${getMainHeaderLabelTextOnly(context)}";

  @override
  Widget? getPrintableWatermark(PdfPageFormat? format) => null;

  @override
  DashboardContentItem? getPrintableInvoiceTableHeaderAndContentWhenDashboard(
          material.BuildContext context, PrintLocalSetting? pca) =>
      null;

  @override
  List<CustomsDeclarationImages>? deletedList;

  @override
  CustomsDeclarationImages getListableAddFromManual(
      material.BuildContext context) {
    return CustomsDeclarationImages();
  }

  @override
  material.Widget? getListableCustomHeader(material.BuildContext context) {
    return null;
  }

  @override
  List<ViewAbstract> getListableInitialSelectedListPassedByPickedObject(
      material.BuildContext context) {
    return customs_declarations_images ?? [];
    //  if (customs_declarations_images == null) return [];
    // return customs_declarations_images?.map((e) => e.!).toList() ?? [];
  }

  @override
  List<CustomsDeclarationImages> getListableList() {
    return customs_declarations_images ?? [];
  }

  @override
  ViewAbstract? getListablePickObject() {
    return CustomsDeclarationImages();
  }

  @override
  ViewAbstract? getListablePickObjectQrCode() => null;

  @override
  double? getListableTotalDiscount(material.BuildContext context) => null;

  @override
  double? getListableTotalPrice(material.BuildContext context) => null;

  @override
  String? getListableTotalQuantity(material.BuildContext context) => null;

  @override
  bool isListableIsImagable() => true;

  @override
  bool isListableRequired(material.BuildContext context) => true;

  @override
  void onListableAddFromManual(
      material.BuildContext context, CustomsDeclarationImages addedObject) {
    // TODO: implement onListableAddFromManual
  }

  @override
  void onListableDelete(CustomsDeclarationImages item) {
    // TODO: implement onListableDelete
  }

  @override
  void onListableListAddedByQrCode(
      material.BuildContext context, ViewAbstract? view) {
    // TODO: implement onListableListAddedByQrCode
  }

  @override
  void onListableSelectedListAdded(
      material.BuildContext context, List<ViewAbstract> list) {
    // TODO: implement onListableSelectedListAdded
  }

  @override
  void onListableUpdate(CustomsDeclarationImages item) {
    // TODO: implement onListableUpdate
  }

  @override
  String getContentSharable(material.BuildContext context,
      {ServerActions? action}) {
    return getMainHeaderLabelWithText(context);
  }
}
