import 'package:data_table_2/data_table_2.dart';
import 'package:dynamic_table/dynamic_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/new_components/scrollable_widget.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';

import '../../models/view_abstract.dart';

@immutable
class ViewableTableViewAbstractWidget extends StatefulWidget {
  List<ViewAbstract> viewAbstract;
  bool usePag;
  bool buildActions;

  ///if the obj is set then we get the obj data
  ///else the cartProvider data
  ViewableTableViewAbstractWidget(
      {super.key,
      required this.viewAbstract,
      this.buildActions = false,
      this.usePag = false});

  @override
  State<ViewableTableViewAbstractWidget> createState() =>
      _ViewableTableViewAbstractWidget();
}

@immutable
class _ViewableTableViewAbstractWidget
    extends State<ViewableTableViewAbstractWidget> {
  late List<ViewAbstract> list_invoice_details;
  late List<String> fields;
  PaginatorController? _controller;
  int? sortColumnIndex;
  bool isAscending = false;
  late GlobalKey<FormBuilderState> _formKey;
  final tableKey = GlobalKey<DynamicTableState>();

  int lastIndexOfSelected = -1;

  @override
  void didUpdateWidget(covariant ViewableTableViewAbstractWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    list_invoice_details = widget.viewAbstract;
    fields = (widget.viewAbstract[0]).getMainFieldsForTable(context: context);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _controller = PaginatorController();
  }

  @override
  void initState() {
    super.initState();
    list_invoice_details = widget.viewAbstract;
    fields = (widget.viewAbstract[0]).getMainFieldsForTable(context: context);
    _formKey = GlobalKey<FormBuilderState>();
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
    if (widget.buildActions && !widget.usePag) {
      return DynamicTable(
          key: tableKey,
          header: const Text("Person Table"),
          showCheckboxColumn: false,
          showFirstLastButtons: true,
          rowsPerPage: 4,

          // rowsPerPage: 5,
          // onSelectAll: myData.selectAll,

          // actions: [
          //   // if (myData.selectedRowCount > 0)
          //   IconButton(
          //       onPressed: () {
          //         if (myData.selectedRowCount > 0) {
          //           debugPrint("remove selected row");
          //           setState(() {
          //             list_invoice_details.removeWhere(
          //                 (element) => element.selected ?? false);
          //           });
          //         }
          //       },
          //       icon: Icon(Icons.delete))
          // ],
          // autoRowsToHeight: true,
          // header: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Text(list_invoice_details[0]
          //           .getMainHeaderLabelTextOnly(context)),
          //       Row(children: [
          //         OutlinedButton(
          //             onPressed: () => _controller!.goToPageWithRow(25),
          //             child: const Text('Go to row 25')),
          //         OutlinedButton(
          //             onPressed: () => _controller!.goToRow(5),
          //             child: const Text('Go to row 5'))
          //       ]),
          //     ]),
          // columnSpacing: 200,
          onRowEdit: (index, List<dynamic> onRowEdit) {
            //permisision for edit

            return true;
          },
          onRowDelete: (index, List<dynamic> onRowEdit) {
            //permisision for delete

            return true;
          },
          onRowSave:
              (int index, List<dynamic> oldValue, List<dynamic> newValue) {
            return newValue;
          },
          sortColumnIndex: sortColumnIndex,
          sortAscending: isAscending,
          columnSpacing: 2,
          // onSelectAll: _dessertsDataSource.selectAll,
          horizontalMargin: 20,

          // wrapInCard: true,
          // minWidth: 800,
          // controller: _controller,
          showActions: true,
          actions: const [],
          showAddRowButton: true,
          showDeleteAction: true,

          // fit: FlexFit.tight,
          columns: getColumnsDynamicTableDataColumn(context),
          rows: getRowsDynamicTableDataRow(context));
    }
    if (widget.usePag) {
      var myData = MyData(context, list_invoice_details,
          buildActions: widget.buildActions);
      return PaginatedDataTable2(
          // wrapInCard: ,
          header: const Text("Person Table"),
          showCheckboxColumn: false,
          autoRowsToHeight: true,
          fit: FlexFit.tight,
          columnSpacing: 0,
          showFirstLastButtons: true,
          rowsPerPage: 4,

          // onSelectAll: myData.selectAll,

          // actions: [
          //   // if (myData.selectedRowCount > 0)
          //   IconButton(
          //       onPressed: () {
          //         if (myData.selectedRowCount > 0) {
          //           debugPrint("remove selected row");
          //           setState(() {
          //             list_invoice_details.removeWhere(
          //                 (element) => element.selected ?? false);
          //           });
          //         }
          //       },
          //       icon: Icon(Icons.delete))
          // ],
          // autoRowsToHeight: true,
          // header: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Text(list_invoice_details[0]
          //           .getMainHeaderLabelTextOnly(context)),
          //       Row(children: [
          //         OutlinedButton(
          //             onPressed: () => _controller!.goToPageWithRow(25),
          //             child: const Text('Go to row 25')),
          //         OutlinedButton(
          //             onPressed: () => _controller!.goToRow(5),
          //             child: const Text('Go to row 5'))
          //       ]),
          //     ]),
          // columnSpacing: 200,

          sortColumnIndex: sortColumnIndex,
          sortAscending: isAscending,
          // onSelectAll: _dessertsDataSource.selectAll,
          horizontalMargin: 20,
          actions: const [Icon(Icons.print)],
          // wrapInCard: true,
          // minWidth: 800,
          controller: _controller,

          // fit: FlexFit.tight,
          columns: getColumns(context),
          source: myData);
    }

    return ScrollableWidget(child: buildForm());
  }

  Widget buildForm() {
    return Column(
      children: [
        DataTable(
          // header: Text("Dada"),
          // source: _data,
          columnSpacing: 100,
          horizontalMargin: 10,
          // rowsPerPage: 8,
          showCheckboxColumn: false,
          sortAscending: isAscending,
          sortColumnIndex: sortColumnIndex,
          columns: getColumns(context),
          rows: getRows(context),
        ),
      ],
    );
  }

  List<DynamicTableDataColumn> getColumnsDynamicTableDataColumn(
      BuildContext context) {
    ViewAbstract first = list_invoice_details[0];
    var list = first
        .getMainFieldsForTable(context: context)
        .map((e) => DynamicTableDataColumn(
              isEditable: true,
              dynamicTableInputType: DynamicTableInputType.text(
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(20),
                      border: OutlineInputBorder())),

              // numeric: true,
              label: Text(first.getFieldLabel(context, e)),
              onSort: (columnIndex, ascending) =>
                  onSort(context, columnIndex, ascending),
            ))
        .toList();
    // if (widget.buildActions) {
    //   list.add(DynamicTableDataColumn(label: SizedBox()));
    // }
    return list;
  }

  List<DataColumn> getColumns(BuildContext context) {
    ViewAbstract first = list_invoice_details[0];
    var list = first
        .getMainFieldsForTable(context: context)
        .map((e) => DataColumn(
              // numeric: true,
              label: Text(first.getFieldLabel(context, e)),
              onSort: (columnIndex, ascending) =>
                  onSort(context, columnIndex, ascending),
            ))
        .toList();
    if (widget.buildActions) {
      list.add(const DataColumn(
          label: SizedBox(
        width: 100,
      )));
    }
    return list;
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
              .getMainFieldsForTable(context: context)
              .map((ee) => DataCell(
                  Text(
                    e.getFieldValueCheckTypeChangeToCurrencyFormat(context, ee),
                    overflow: TextOverflow.visible,
                    softWrap: true,
                  ),
                  showEditIcon: false))
              .toList());
    }).toList();
  }

  List<DynamicTableDataRow> getRowsDynamicTableDataRow(BuildContext context) {
    return list_invoice_details.map((e) {
      int index = list_invoice_details.indexOf(e);
      return DynamicTableDataRow(
          selected: false,
          index: index,
          // selected: lastIndexOfSelected == index,
          isEditing: false,
          // onSelectChanged: (s) {
          //   debugPrint(
          //       "dataRow selectChange $s index=> ${list_invoice_details.indexOf(e)}");
          //   setState(() {
          //     lastIndexOfSelected = index;
          //   });
          // },
          cells: e
              .getMainFieldsForTable(context: context)
              .map((ee) => DynamicTableDataCell(
                  // showEditIcon: true,
                  value: e.getFieldValueCheckTypeChangeToCurrencyFormat(
                      context, ee)))
              .toList());
    }).toList();
  }

  void onSort(BuildContext context, int columnIndex, bool ascending) {
    debugPrint(
        "onSort: columnIndex $columnIndex  listsize=> ${list_invoice_details.length} ");
    list_invoice_details.sort((obj1, obj2) => compareDynamic(
        ascending,
        obj1.getFieldValueCheckTypeChangeToCurrencyFormat(
            context, obj1.getMainFieldsForTable(context: context)[columnIndex]),
        obj2.getFieldValueCheckTypeChangeToCurrencyFormat(context,
            obj2.getMainFieldsForTable(context: context)[columnIndex])));

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

class MyData extends DataTableSource {
  List<ViewAbstract> data;
  int _selectedCount = 0;
  BuildContext context;
  bool buildActions;

  MyData(this.context, this.data, {required this.buildActions});

  // Generate some made-up data

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => _selectedCount;

  void selectAll(bool? checked) {
    for (final dessert in data) {
      dessert.selected = checked ?? false;
    }
    _selectedCount = (checked ?? false) ? data.length : 0;
    notifyListeners();
  }

  @override
  DataRow getRow(int index) {
    ViewAbstract e = data[index];
    var list = (e).getPopupMenuActionsList(context);
    var cells = e
        .getMainFieldsForTable(context: context)
        .map((ee) => DataCell(
            onTap: () => {
                  e.onCardLongClicked(
                    context,
                  )
                },
            Text(
              e.getFieldValueCheckTypeChangeToCurrencyFormat(context, ee),
              // overflow: TextOverflow.visible,
              // softWrap: true,
            ),
            showEditIcon: false))
        .toList();
    if (buildActions) {
      cells.add(DataCell(
        SizedBox(
            height: 100,
            width: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: list
                  .map((i) => Expanded(child: e.buildMenuItem(context, i)))
                  .toList(),
            )),
      ));
    }

    // debugPrint("getRow => $e");
    return DataRow2.byIndex(
        specificRowHeight: (e.selected ?? false) ? 100 : null,
        selected: e.selected ?? false,
        onTap: () {
          debugPrint("dataRow onTap");
          e.onCardLongClicked(context);
        },
        // onSelectChanged: (value) {
        //   if (e.selected != value) {
        //     _selectedCount += value! ? 1 : -1;
        //     assert(_selectedCount >= 0);
        //     e.selected = value;
        //     notifyListeners();
        //   }
        // },

        index: index,
        color: e.selected == true
            ? WidgetStateProperty.all(Theme.of(context).highlightColor)
            : null,
        // selected: e.selected,
        cells: cells);
  }
}
