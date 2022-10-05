import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/prints/print_commad_abstract.dart';

import '../printing_generator/pdf_invoice_api.dart';

abstract class PrintableInterfaceDetails {
  Map<String,String> getInvoiceTableHeaderAndContent(
      BuildContext context, PrintCommandAbstract? pca);
}

abstract class PrintableInterface {
  String getInvoiceTitle(BuildContext context, PrintCommandAbstract? pca);

  List<List<TitleAndDescriptionInfoWithIcon>> getInvoiceInfo(
      BuildContext context, PrintCommandAbstract? pca);

  List<TitleAndDescriptionInfo> getInvoiceTotal(
      BuildContext context, PrintCommandAbstract? pca);

  List<PrintableInterfaceDetails> getInvoiceDetailsList();
}

class TitleAndDescriptionInfo {
  String title;
  String description;
  TitleAndDescriptionInfo(this.title, this.description);
}

class TitleAndDescriptionInfoWithIcon extends TitleAndDescriptionInfo {
  IconData icon;
  TitleAndDescriptionInfoWithIcon(String title, String description, this.icon)
      : super(title, description);
}
