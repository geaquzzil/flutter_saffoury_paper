import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/scrollable_widget.dart';

@immutable
class DataTableBuilder extends StatelessWidget {
  ViewAbstract viewAbstract;
  DataTableBuilder({Key? key, required this.viewAbstract}) : super(key: key);

  List<ViewAbstract> list = [];
  int? sortColumnIndex;
  bool isAscending = false;

  @override
  Widget build(BuildContext context) {
    final fieldListName = viewAbstract.getListableFieldName();
    if (fieldListName != null) {
      list = viewAbstract.getFieldValue(fieldListName);
    }
    return ScrollableWidget(child: buildDataTable(context));
  }

  Widget buildDataTable(BuildContext context) {
    ViewAbstract detailListItem = list[0];
    List<ListableDataRow> dataRows =
        detailListItem.getListableDetailsColumns(context);
    return DataTable(
      sortAscending: isAscending,
      sortColumnIndex: sortColumnIndex,
      columns: getColumns(context, dataRows.map((e) => e.labelTitle).toList()),
      rows: getRows(dataRows),
    );
  }

  List<DataColumn> getColumns(BuildContext context, List<String> columns) =>
      columns
          .map((String column) => DataColumn(
                label: Text(column),
                // onSort: (int columnIndex, bool ascending) {
                //   onSort(context, columnIndex, ascending);
                // },
              ))
          .toList();

  List<DataRow> getRows(List<ListableDataRow> dataRows) {
    return list.map((ViewAbstract object) {
      List<DataCell> cells = dataRows
          .map((e) => object.getListableDetailsRowDataCell(e.fieldName))
          .toList();
      return DataRow(cells: cells);
    }).toList();
  }
  // @override
  // State<DataTableBuilder> createState() => _DataTableBuilderState();
}

// class _DataTableBuilderState extends State<DataTableBuilder> {
//   List<ViewAbstract> list = [];
//   late ViewAbstract parent;
//   int? sortColumnIndex;
//   bool isAscending = false;

//   @override
//   void initState() {
//     super.initState();
//     parent = widget.viewAbstract;
//     final fieldListName = parent.getListableFieldName();
//     if (fieldListName != null) {
//       list = parent.getFieldValue(fieldListName);

//     }
//   }


//   @override
//   Widget build(BuildContext context) {
//     return ScrollableWidget(child: buildDataTable(context));
//   }

//   Widget buildDataTable(BuildContext context) {
//     ViewAbstract detailListItem = list[0];
//     List<ListableDataRow> dataRows = detailListItem.getListableDetailsColumns(context);
//     return DataTable(
//       sortAscending: isAscending,
//       sortColumnIndex: sortColumnIndex,
//       columns: getColumns(context, dataRows.map((e) => e.labelTitle).toList()),
//       rows: getRows(dataRows),
//     );
//   }

//   List<DataColumn> getColumns(BuildContext context, List<String> columns) =>
//       columns
//           .map((String column) => DataColumn(
//                 label: Text(column),
//                 // onSort: (int columnIndex, bool ascending) {
//                 //   onSort(context, columnIndex, ascending);
//                 // },
//               ))
//           .toList();

//   List<DataRow> getRows(List<ListableDataRow> dataRows) {
//     return list.map((ViewAbstract object) {
//       List<DataCell> cells = dataRows
//           .map((e) => object.getListableDetailsRowDataCell(e.fieldName))
//           .toList();
//       return DataRow(cells: cells);
//     }).toList();
//   }

//   void onSort(BuildContext context, int columnIndex, bool ascending) {
//     if (columnIndex == 0) {
//       list.sort((obj1, obj2) => compareString(
//           ascending,
//           obj1.getCartItemListText(context),
//           obj2.getCartItemListText(context)));
//     } else if (columnIndex == 1) {
//       list.sort((obj1, obj2) => compareDouble(
//           ascending, obj1.getCartItemQuantity(), obj2.getCartItemQuantity()));
//     } else if (columnIndex == 2) {
//       list.sort((obj1, obj2) => compareDouble(
//           ascending, obj1.getCartItemPrice(), obj2.getCartItemPrice()));
//     }

//     setState(() {
//       sortColumnIndex = columnIndex;
//       isAscending = ascending;
//     });
//   }

//   int compareString(bool ascending, String value1, String value2) =>
//       ascending ? value1.compareTo(value2) : value2.compareTo(value1);

//   int compareInt(bool ascending, int value1, int value2) =>
//       ascending ? value1.compareTo(value2) : value2.compareTo(value1);

//   int compareDouble(bool ascending, double value1, double value2) =>
//       ascending ? value1.compareTo(value2) : value2.compareTo(value1);
// }
