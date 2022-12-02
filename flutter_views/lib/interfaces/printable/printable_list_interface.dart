import 'package:flutter/cupertino.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_invoice_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';

import '../../models/view_abstract.dart';

abstract class PrintableSelfListInterface<T extends PrintLocalSetting> {
  Future<List<List<InvoiceHeaderTitleAndDescriptionInfo>>>?
      getPrintableSelfListHeaderInfo(BuildContext context, List list, T? pca);

  Future<List<InvoiceTotalTitleAndDescriptionInfo>>? getPrintableSelfListTotal(
      BuildContext context, List list, T? pca);

  Future<List<InvoiceTotalTitleAndDescriptionInfo>>?
      getPrintableSelfListTotalDescripton(
          BuildContext context, List list, T? pca);

  Future<List<InvoiceHeaderTitleAndDescriptionInfo>>?
      getPrintableSelfListAccountInfoInBottom(
          BuildContext context, List list, T? pca);

  Map<String, String> getPrintableSelfListTableHeaderAndContent(
      BuildContext context, dynamic item, T? pca);

  ///QR CODE CONTENT
  String getPrintableSelfListQrCode();

  ///CONTAINS QR CODE TITLE
  String getPrintableSelfListQrCodeID();

  ///HexColor
  String getPrintableSelfListPrimaryColor(T? pca);

  ///HexColor
  String getPrintableSelfListSecondaryColor(T? pca);

  String getPrintableSelfListInvoiceTitle(BuildContext context, T? pca);

  T getModifiablePrintableSelfPdfSetting(BuildContext context);
}
