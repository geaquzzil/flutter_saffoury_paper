// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:pdf/widgets.dart' as pdf;

abstract class PrintableMaster<T extends PrintLocalSetting>
    extends PrintableMasterEmpty<T> {
  ///QR CODE CONTENT
  String getPrintableQrCode();

  ///CONTAINS QR CODE TITLE
  String getPrintableQrCodeID();

  ///HexColor
  String getPrintablePrimaryColor(T? pca);

  ///HexColor
  String getPrintableSecondaryColor(T? pca);

  String getPrintableInvoiceTitle(BuildContext context, T? pca);

  pdf.Widget? getPrintableWatermark();

  DashboardContentItem? getPrintableInvoiceTableHeaderAndContentWhenDashboard(
      BuildContext context, PrintLocalSetting? dashboardSetting);
}

class PrintableMasterEmpty<T extends PrintLocalSetting> {}

class DashboardContentItem {
  int? iD;
  String? date;
  String? description;
  String? currency;
  int? currencyId;
  double? credit;
  double? debit;
  DashboardContentItem({
    this.iD,
    this.date,
    this.description,
    this.currency,
    this.currencyId,
    this.credit,
    this.debit,
  });
}

class CurrencyBalanceItem {}
