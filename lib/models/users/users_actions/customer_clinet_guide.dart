// ignore_for_file: library_prefixes

import 'package:flutter_view_controller/interfaces/printable/printable_custom_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/interfaces/settings/ModifiableInterfaceAndPrintingSetting.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/models/view_abstract_stand_alone.dart';
import 'package:flutter/material.dart' as mt;
import 'package:pdf/pdf.dart' as pdf;
import 'package:pdf/widgets.dart' as pdW;
import '../../prints/print_customer_guid.dart';
import '../customers.dart';

class CustomerClinetGuide
    extends ViewAbstractStandAloneCustomViewApi<CustomerClinetGuide>
    implements
        PrintableCustomInterface<PrintCustomerGuid>,
        ModifiablePrintableInterface<PrintCustomerGuid> {
  Customer customer;

  CustomerClinetGuide(this.customer);

  @override
  CustomerClinetGuide getSelfNewInstance() {
    //TODO
    return CustomerClinetGuide(Customer());
  }

  @override
  CustomerClinetGuide fromJsonViewAbstract(Map<String, dynamic> json) {
    // TODO: implement fromJsonViewAbstract
    throw UnimplementedError();
  }

  @override
  Map<String, mt.IconData> getFieldIconDataMap() {
    // TODO: implement getFieldIconDataMap
    throw UnimplementedError();
  }

  @override
  Map<String, String> getFieldLabelMap(mt.BuildContext context) {
    // TODO: implement getFieldLabelMap
    throw UnimplementedError();
  }

  @override
  String? getMainDrawerGroupName(mt.BuildContext context) {
    // TODO: implement getMainDrawerGroupName
    throw UnimplementedError();
  }

  @override
  bool getCustomStandAloneWidgetIsPadding() {
    return false;
  }

  @override
  List<String> getMainFields({mt.BuildContext? context}) {
    // TODO: implement getMainFields
    throw UnimplementedError();
  }

  @override
  String getMainHeaderLabelTextOnly(mt.BuildContext context) {
    // TODO: implement getMainHeaderLabelTextOnly
    throw UnimplementedError();
  }

  @override
  String getMainHeaderTextOnly(mt.BuildContext context) {
    // TODO: implement getMainHeaderTextOnly
    throw UnimplementedError();
  }

  @override
  mt.IconData getMainIconData() {
    // TODO: implement getMainIconData
    throw UnimplementedError();
  }

  @override
  String getModifiableMainGroupName(mt.BuildContext context) {
    // TODO: implement getModifiableMainGroupName
    throw UnimplementedError();
  }

  @override
  PrintableMaster getModifiablePrintablePdfSetting(mt.BuildContext context) {
    // TODO: implement getModifiablePrintablePdfSetting
    throw UnimplementedError();
  }

  @override
  mt.IconData getModifibleIconData() {
    // TODO: implement getModifibleIconData
    throw UnimplementedError();
  }

  @override
  PrintCustomerGuid getModifibleSettingObject(mt.BuildContext context) {
    // TODO: implement getModifibleSettingObject
    throw UnimplementedError();
  }

  @override
  String getModifibleTitleName(mt.BuildContext context) {
    // TODO: implement getModifibleTitleName
    throw UnimplementedError();
  }

  @override
  String getPrintableInvoiceTitle(
      mt.BuildContext context, PrintCustomerGuid? pca) {
    // TODO: implement getPrintableInvoiceTitle
    throw UnimplementedError();
  }

  @override
  String getPrintablePrimaryColor(PrintCustomerGuid? setting) {
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
    // TODO: implement getPrintableQrCodeID
    throw UnimplementedError();
  }

  @override
  String getPrintableSecondaryColor(PrintCustomerGuid? setting) {
    // TODO: implement getPrintableSecondaryColor
    throw UnimplementedError();
  }

  @override
  String? getTableNameApi() {
    // TODO: implement getTableNameApi
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    // TODO: implement toJsonViewAbstract
    throw UnimplementedError();
  }

  @override
  ResponseType getCustomStandAloneResponseType() {
    // TODO: implement getCustomStandAloneResponseType
    throw UnimplementedError();
  }

  @override
  mt.Widget getCustomStandAloneWidget(mt.BuildContext context) {
    // TODO: implement getCustomStandAloneWidget
    throw UnimplementedError();
  }

  @override
  List<mt.Widget>? getCustomeStandAloneSideWidget(mt.BuildContext context) =>
      null;

  @override
  Future<pdW.Widget?>? getPrintableCustomFooter(mt.BuildContext context,
      {pdf.PdfPageFormat? format, PrintCustomerGuid? setting}) {
    // TODO: implement getPrintableCustomFooter
    throw UnimplementedError();
  }

  @override
  Future<pdW.Widget?>? getPrintableCustomHeader(mt.BuildContext context,
      {pdf.PdfPageFormat? format, PrintCustomerGuid? setting}) {
    // TODO: implement getPrintableCustomHeader
    throw UnimplementedError();
  }

  @override
  Future<List<pdW.Widget>> getPrintableCustomPage(mt.BuildContext context,
      {pdf.PdfPageFormat? format, PrintCustomerGuid? setting}) {
    // TODO: implement getPrintableCustomPage
    throw UnimplementedError();
  }

  @override
  pdW.Widget? getPrintableWatermark() => null;

  @override
  mt.Widget? getCustomFloatingActionWidget(mt.BuildContext context) {
    return null;
  }

  @override
  DashboardContentItem? getPrintableInvoiceTableHeaderAndContentWhenDashboard(
          mt.BuildContext context, PrintLocalSetting? dashboardSetting) =>
      null;
}
