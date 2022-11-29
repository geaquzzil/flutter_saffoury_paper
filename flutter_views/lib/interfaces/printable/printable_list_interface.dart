import 'package:flutter/cupertino.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_invoice_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';

abstract class PrintableSelfListInterface<E, T extends PrintLocalSetting>
    extends PrintableMaster<T> {
  List<List<InvoiceHeaderTitleAndDescriptionInfo>>? getPrintableSelfListHeaderInfo(
      BuildContext context, List<E> list, T? pca);

  List<InvoiceTotalTitleAndDescriptionInfo>? getPrintableSelfListTotal(
      BuildContext context, List<E> list, T? pca);

  List<InvoiceTotalTitleAndDescriptionInfo>? getPrintableSelfListTotalDescripton(
      BuildContext context, List<E> list, T? pca);

  List<InvoiceHeaderTitleAndDescriptionInfo>?
      getPrintableSelfListAccountInfoInBottom(
          BuildContext context, List<E> list, T? pca);

  Map<String, String> getPrintableSelfListTableHeaderAndContent(
      BuildContext context, E item, T? pca);


}
