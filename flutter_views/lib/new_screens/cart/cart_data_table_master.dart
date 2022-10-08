import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/interfaces/cartable_interface.dart';
import 'package:flutter_view_controller/new_components/scrollable_widget.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/providers/cart/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

import '../../theming/text_field_theming.dart';
import '../edit/controllers/ext.dart';

class CartDataTableMaster extends StatefulWidget {
  const CartDataTableMaster({Key? key}) : super(key: key);

  @override
  State<CartDataTableMaster> createState() => _CartDataTableState();
}

class _CartDataTableState extends State<CartDataTableMaster> {
  late List<CartableProductItemInterface> list;
  late List<CartableInvoiceDetailsInterface> list_invoice_details;
  late CartProvider cartProvider;
  int? sortColumnIndex;
  bool isAscending = false;
  int lastIndexOfSelected = -1;

  @override
  void initState() {
    super.initState();
    cartProvider = Provider.of<CartProvider>(context, listen: false);
    list = cartProvider.getList;
    list_invoice_details =
        cartProvider.getCartableInvoice.getDetailList(context);
  }

  @override
  Widget build(BuildContext context) {
    if (list_invoice_details.isEmpty) {
      return EmptyWidget(
          lottiUrl:
              "https://assets5.lottiefiles.com/packages/lf20_t9gkkhz4.json",
          title: AppLocalizations.of(context)!.noItems,
          subtitle: AppLocalizations.of(context)!.error_empty);
    }
    return ScrollableWidget(child: buildDataTableNotEmpty(context));
  }

  Widget buildDataTableNotEmpty(BuildContext context) {
    return DataTable(
      showCheckboxColumn: false,
      sortAscending: isAscending,
      sortColumnIndex: sortColumnIndex,
      columns: getColumns(context),
      rows: getRows(context),
    );
  }

  List<DataColumn> getColumns(BuildContext context) {
    return list_invoice_details[0]
        .getCartInvoiceTableHeaderAndContent(context)
        .values
        .map((e) => DataColumn(
              numeric: true,
              label: Text(e.title),
              onSort: (columnIndex, ascending) =>
                  onSort(context, columnIndex, ascending),
            ))
        .toList();
  }

  List<DataRow> getRows(BuildContext context) {
    return list_invoice_details.map((e) {
      int index = list_invoice_details.indexOf(e);
      return DataRow(
          selected: lastIndexOfSelected == index,
          onSelectChanged: (s) {
            debugPrint(
                "dataRow selectChange $s index=> ${list_invoice_details.indexOf(e)}");
            setState(() {
              lastIndexOfSelected = index;
            });
          },
          cells: e
              .getCartInvoiceTableHeaderAndContent(context)
              .entries
              .map((ee) => getDataCell(
                  context, list_invoice_details[index], index, ee.key, ee))
              //todo check type of value return string

              .toList());
    }).toList();
  }

  Widget getTextField(
          BuildContext context,
          int mainRow,
          CartableInvoiceDetailsInterface cidi,
          MapEntry<String, CartInvoiceHeader> ee) =>
      FormBuilderTextField(
        valueTransformer: (value) {
          return value?.trim();
        },
        name: "${ee.key} ${cidi.hashCode}",
        initialValue: getEditControllerText(ee.value.value),
        // maxLength: 12,
        // decoration: getDecorationTheming(context, TextFieldTheming()),
        keyboardType:
            TextInputType.numberWithOptions(decimal: true, signed: true),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: cidi.getCartableEditableValidateItemCell(context, ee.key),
        onChanged: (value) {
          cidi.getCartableEditableOnChange(context, mainRow, ee.key, value);
          setState(() {});
        },
      );
  DataCell getDataCell(
      BuildContext context,
      CartableInvoiceDetailsInterface cidi,
      int indexOfRow,
      String indexOfCell,
      MapEntry<String, CartInvoiceHeader> ee) {
    CartInvoiceHeader e = ee.value;
    bool canEdit = indexOfRow == lastIndexOfSelected && e.canEdit;
    if (canEdit) {
      return DataCell(
          SizedBox(
              width: 80, child: getTextField(context, indexOfRow, cidi, ee)),
          showEditIcon: false);
    } else {
      return DataCell(Text(e.value.toString()), showEditIcon: false);
    }
  }

  void onSort(BuildContext context, int columnIndex, bool ascending) {
    debugPrint(
        "onSort: columnIndex $columnIndex  listsize=> ${list_invoice_details.length} ");
    list_invoice_details.sort((obj1, obj2) => compareDynamic(
        ascending,
        obj1.getCartInvoiceTableHeaderAndContent(context)[columnIndex]?.value,
        obj2.getCartInvoiceTableHeaderAndContent(context)[columnIndex]?.value));

    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
  }

  int compareDynamic(bool ascending, dynamic value1, dynamic value2) {
    debugPrint(
        "compareDynamic value1 => ${value1.toString()} , value2 => $value2");
    if (value1 == null) {
      return 0;
    }
    if (value1.runtimeType == int) {
      return compareInt(ascending, value1, value2);
    } else if (value1.runtimeType == double) {
      return compareDouble(ascending, value1, value2);
    } else if (value1.runtimeType == String) {
      return compareString(ascending, value1, value2);
    } else {
      return 0;
    }
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);

  int compareInt(bool ascending, int value1, int value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);

  int compareDouble(bool ascending, double value1, double value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);
}
