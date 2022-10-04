import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/prints/print_commad_abstract.dart';

import '../printing_generator/pdf_invoice_api.dart';

abstract class PrintableInterface {
  String getInvoiceTitle(
      BuildContext context, PrintCommandAbstract? pca);

  ///invoice number ...etc
  ///'Invoice Number:',
  /// 'Invoice Date:',
  /// 'Payment Terms:',
  ///'Due Date:'
  List<TitleAndDescriptionInfo> getInvoiceInfo(
      BuildContext context, PrintCommandAbstract? pca);
  List<TitleAndDescriptionInfo> getInvoiceTotal(
      BuildContext context, PrintCommandAbstract? pca);
}