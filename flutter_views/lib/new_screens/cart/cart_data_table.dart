import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/scrollable_widget.dart';
import 'package:flutter_view_controller/providers/cart/cart_provider.dart';
import 'package:provider/provider.dart';

class CartDataTable extends StatefulWidget {
  const CartDataTable({Key? key}) : super(key: key);

  @override
  State<CartDataTable> createState() => _CartDataTableState();
}

class _CartDataTableState extends State<CartDataTable> {
  final columns = ['Item', 'Size', 'Quantity', 'Price'];
  late List<ViewAbstract> list;
  int? sortColumnIndex;
  bool isAscending = false;

  @override
  void initState() {
    super.initState();
    CartProvider cartProvider =
        Provider.of<CartProvider>(context, listen: false);
    list = cartProvider.getList;
  }

  @override
  Widget build(BuildContext context) {
    return ScrollableWidget(child: buildDataTable(context));
  }

  Widget buildDataTable(BuildContext context) {
    final columns = ['Item', 'Quantity', 'Price'];

    return DataTable(
      sortAscending: isAscending,
      sortColumnIndex: sortColumnIndex,
      columns: getColumns(context, columns),
      rows: getRows(list),
    );
  }

  List<DataColumn> getColumns(BuildContext context, List<String> columns) =>
      columns
          .map((String column) => DataColumn(
                label: Text(column),
                onSort: (int columnIndex, bool ascending) {
                  onSort(context, columnIndex, ascending);
                },
              ))
          .toList();
  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(Text('$data'))).toList();
  List<DataRow> getRows(List<ViewAbstract> users) =>
      users.map((ViewAbstract object) {
        final cells = [
          object.getCartItemText(context),
          object.getCartItemQuantity(),
          object.getCartItemPrice()
        ];
        return DataRow(cells: getCells(cells));
      }).toList();

  void onSort(BuildContext context, int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      list.sort((obj1, obj2) => compareString(ascending,
          obj1.getCartItemText(context), obj2.getCartItemText(context)));
    } else if (columnIndex == 1) {
      list.sort((obj1, obj2) => compareDouble(
          ascending, obj1.getCartItemQuantity(), obj2.getCartItemQuantity()));
    } else if (columnIndex == 2) {
      list.sort((obj1, obj2) => compareDouble(
          ascending, obj1.getCartItemPrice(), obj2.getCartItemPrice()));
    }

    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);

  int compareInt(bool ascending, int value1, int value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);

  int compareDouble(bool ascending, double value1, double value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);
}
