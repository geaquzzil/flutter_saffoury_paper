import 'package:flutter/material.dart' as material;
import 'package:flutter_saffoury_paper/models/customs/customs_declarations_images.dart';
import 'package:flutter_saffoury_paper/models/users/employees.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_custom_interface.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:pdf/src/widgets/theme.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import 'package:pdf/src/widgets/document.dart';
import 'package:pdf/src/pdf/page_format.dart';
import 'package:printing/printing.dart';

part 'customs_declarations.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class CustomsDeclaration extends ViewAbstract<CustomsDeclaration>
    implements PrintableCustomFromPDFInterface<PrintLocalSetting> {
  // int? EmployeeID;

  @JsonKey(fromJson: intFromString)
  String? number; //varchar 200
  String? date;

  String? fromCountry; //59
  String? fromName; //50
  String? comments;

  List<CustomsDeclarationImages>? customs_declarations_images;
  int? customs_declarations_images_count;
  Employee? employees;

  CustomsDeclaration() : super() {
    date = "".toDateTimeNowString();
  }
  @override
  CustomsDeclaration getSelfNewInstance() {
    return CustomsDeclaration();
  }

  @override
  CustomsDeclaration getSelfNewInstanceFileImporter(
      {required material.BuildContext context, String? field, value}) {
    int? parsedValue = int.tryParse(value);
    if (parsedValue != null) {
      number = parsedValue.toString();
      return this;
    } else {
      throw Exception(
          "${getMainHeaderLabelTextOnly(context)} Can't convert number to value of $value");
    }
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
  Map<ServerActions, List<String>>? isRequiredObjectsList() => {
        ServerActions.list: ["customs_declarations_images"],
      };

  @override
  Map<String, material.IconData> getFieldIconDataMap() => {
        "number": material.Icons.onetwothree,
        "date": material.Icons.date_range,
        "fromCountry": material.Icons.domain,
        "fromName": material.Icons.account_circle,
        "comments": material.Icons.notes
      };

  @override
  material.Widget? getMainSubtitleHeaderText(material.BuildContext context) {
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
        //       .caption!
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

  // @override
  // String getMainHeaderTextOnly(material.BuildContext context) =>
  //     "$number : $comments";

  @override
  material.IconData getMainIconData() => material.Icons.document_scanner;

  @override
  String? getSortByFieldName() => "date";

  @override
  SortByType getSortByType() => SortByType.DESC;

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
  Map<String, bool> isFieldRequiredMap() => {"number": true};

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
      {required ThemeData theme,
      PdfPageFormat? format,
      PrintLocalSetting? setting}) async {
    final pdf =
        Document(title: "TEST", pageMode: PdfPageMode.fullscreen, theme: theme);

    await Future.forEach<Page>(await getPrintableCustomFromPDFPageLIst(context),
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
  Future<List<Page>> getPrintableCustomFromPDFPageLIst(
      material.BuildContext context,
      {PdfPageFormat? format,
      PrintLocalSetting? setting}) async {
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
          Page(
              margin: EdgeInsets.zero,
              pageFormat: format,
              build: (context) => widget),
        );
      });
    }
    return pages;
  }

  @override
  String getMainHeaderTextOnly(material.BuildContext context) =>
      "${getIDFormat(context)} ${getMainHeaderLabelTextOnly(context)}";
}
