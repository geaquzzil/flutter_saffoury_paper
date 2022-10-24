import 'package:flutter_view_controller/interfaces/printable/printable_custom_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/interfaces/settings/ModifiableInterfaceAndPrintingSetting.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/prints/print_commad_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_non_list.dart';
import 'package:pdf/src/widgets/widget.dart';
import 'package:pdf/src/pdf/page_format.dart';
import 'package:flutter/material.dart' as mt;
import '../../prints/print_customer_guid.dart';
import '../customers.dart';

class CustomerClinetGuide
    extends ViewAbstractStandAloneCustomView<CustomerClinetGuide>
    implements
        PrintableCustomInterface<PrintCustomerGuid>,
        ModifiablePrintableInterface<PrintCustomerGuid> {
  Customer customer;

  CustomerClinetGuide(this.customer);
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
  List<String> getMainFields() {
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
  Future<Widget?>? getPrintableCustomFooter(mt.BuildContext context,
      {PdfPageFormat? format}) {
    // TODO: implement getPrintableCustomFooter
    throw UnimplementedError();
  }

  @override
  Future<Widget?>? getPrintableCustomHeader(mt.BuildContext context,
      {PdfPageFormat? format}) {
    // TODO: implement getPrintableCustomHeader
    throw UnimplementedError();
  }

  @override
  Future<List<Widget>> getPrintableCustomPage(mt.BuildContext context,
      {PdfPageFormat? format}) {
    // TODO: implement getPrintableCustomPage
    throw UnimplementedError();
  }

  @override
  String getPrintableInvoiceTitle(
      mt.BuildContext context, PrintCustomerGuid? pca) {
    // TODO: implement getPrintableInvoiceTitle
    throw UnimplementedError();
  }

  @override
  String getPrintablePrimaryColor() {
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
  String getPrintableSecondaryColor() {
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
}
