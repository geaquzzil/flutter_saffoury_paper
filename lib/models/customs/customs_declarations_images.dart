import 'package:flutter/material.dart' as material;
import 'package:flutter_saffoury_paper/models/customs/customs_declarations.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_custom_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/src/pdf/page_format.dart';
import 'package:pdf/src/widgets/document.dart';
import 'package:pdf/src/widgets/page.dart';
import 'package:pdf/src/widgets/page_theme.dart';
import 'package:pdf/src/widgets/theme.dart';
import 'package:pdf/src/widgets/widget.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
part 'customs_declarations_images.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class CustomsDeclarationImages extends ViewAbstract<CustomsDeclarationImages>
    implements PrintableCustomFromPDFInterface<PrintLocalSetting> {
  // int? CustomerDeclarationID;
  String? image;
  String? comments;

  CustomsDeclaration? customs_declarations;

  CustomsDeclarationImages() : super();

  @override
  String? getImageUrl(material.BuildContext context) {
    if (image == null) return null;
    if (image?.isEmpty ?? true) return null;
    return "https://$image";
  }

  @override
  CustomsDeclarationImages getSelfNewInstance() {
    return CustomsDeclarationImages();
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() => {
        "image": "",
        "comments": "",
        "customs_declarations": CustomsDeclaration()
      };

  @override
  List<String> getMainFields({material.BuildContext? context}) =>
      ["customs_declarations", "image", "comments"];

  @override
  Map<String, material.IconData> getFieldIconDataMap() =>
      {"image": material.Icons.image, "comments": material.Icons.notes};

  @override
  Map<String, String> getFieldLabelMap(material.BuildContext context) => {
        "image": AppLocalizations.of(context)!.adsImages,
        "comments": AppLocalizations.of(context)!.comments
      };

  @override
  String? getMainDrawerGroupName(material.BuildContext context) =>
      AppLocalizations.of(context)!.product;

  @override
  String getMainHeaderLabelTextOnly(material.BuildContext context) =>
      AppLocalizations.of(context)!.customs_clearnces;

  @override
  String getMainHeaderTextOnly(material.BuildContext context) => "$comments";

  @override
  material.IconData getMainIconData() => material.Icons.gavel_sharp;

  @override
  String? getSortByInitialFieldName() => "comments";

  @override
  SortByType getSortByInitialType() => SortByType.DESC;

  @override
  String? getTableNameApi() => "customs_declarations_images";

  @override
  Map<String, bool> getTextInputIsAutoCompleteMap() => {};

  @override
  Map<String, bool> getTextInputIsAutoCompleteViewAbstractMap() => {
        "image": true,
      };

  @override
  Map<String, int> getTextInputMaxLengthMap() => {};

  @override
  Map<String, double> getTextInputMaxValidateMap() => {};

  @override
  Map<String, double> getTextInputMinValidateMap() => {};

  @override
  Map<String, material.TextInputType?> getTextInputTypeMap() =>
      {"comments": material.TextInputType.text};

  @override
  Map<String, bool> isFieldCanBeNullableMap() => {};

  @override
  Map<String, bool> isFieldRequiredMap() => {};

  factory CustomsDeclarationImages.fromJson(Map<String, dynamic> data) =>
      _$CustomsDeclarationImagesFromJson(data);

  Map<String, dynamic> toJson() => _$CustomsDeclarationImagesToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  CustomsDeclarationImages fromJsonViewAbstract(Map<String, dynamic> json) =>
      CustomsDeclarationImages.fromJson(json);

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
  Future<List<Page>> getPrintableCustomFromPDFPageLIst(
      material.BuildContext context,
      {PdfPageFormat? format,
      PrintLocalSetting? setting,
      required PageTheme themeData}) async {
    ImageProvider w = await networkImage(getImageUrl(context)!);
    return [Page(pageTheme: themeData, build: (context) => Image(w))];
  }

  @override
  DashboardContentItem? getPrintableInvoiceTableHeaderAndContentWhenDashboard(
      material.BuildContext context, PrintLocalSetting? dashboardSetting) {
    // TODO: implement getPrintableInvoiceTableHeaderAndContentWhenDashboard
    throw UnimplementedError();
  }

  @override
  String getPrintableInvoiceTitle(
          material.BuildContext context, PrintLocalSetting? pca) =>
      getIDFormat(context);

  @override
  String getPrintableQrCode() => "";

  @override
  String getPrintableQrCodeID() {
    return "";
  }

  @override
  String getPrintablePrimaryColor(PrintLocalSetting? pca) => "";
  @override
  String getPrintableSecondaryColor(PrintLocalSetting? pca) => "";

  @override
  Widget? getPrintableWatermark() => null;
}
