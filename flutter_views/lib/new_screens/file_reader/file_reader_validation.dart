import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/servers/server_data.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/scrollable_widget.dart';
import 'package:flutter_view_controller/new_screens/file_reader/file_rader_object_view_abstract.dart';
import 'package:flutter_view_controller/providers/filterables/fliterable_list_provider_api.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../new_components/tables_widgets/view_table_view_abstract.dart';

class FileReaderValidationWidget extends StatelessWidget {
  FileReaderObject fileReaderObject;
  FileReaderValidationWidget({super.key, required this.fileReaderObject});

  @override
  Widget build(BuildContext context) {
    debugPrint(
        "FileReaderValidationWidget fileReaderObject=> $fileReaderObject");
    return FutureBuilder(
        future: context
            .read<FilterableListApiProvider<FilterableData>>()
            .getServerData(fileReaderObject.viewAbstract),
        builder: ((s, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return getWidget(context, snapshot);
          }
          return Center(
            child: Lottie.network(
                "https://assets3.lottiefiles.com/packages/lf20_mr1olA.json"),
          );
        }));
  }

  List<DataRow> getRows(BuildContext context, List<List<Data?>> rows) {
    return rows.map((e) {
      int index = rows.indexOf(e);
      return DataRow(
          // selected: lastIndexOfSelected == index,
          // onSelectChanged: (s) {
          //   debugPrint(
          //       "dataRow selectChange $s index=> ${list_invoice_details.indexOf(e)}");
          //   setState(() {
          //     lastIndexOfSelected = index;
          //   });
          // },
          cells: e
              .map((ee) => DataCell(
                  Text(
                    "${ee?.value}",
                    overflow: TextOverflow.visible,
                    softWrap: true,
                  ),
                  showEditIcon: false))
              .toList());
    }).toList();
  }

  static List<ViewAbstract> getDataFromExcelTable(
      BuildContext context, FileReaderObject fileReader) {
    Excel excel = fileReader.excel;
    var f = excel.tables[fileReader.selectedSheet]?.rows;
    var columns = fileReader.fileColumns;
    // debugPrint("getDataFromExcelTable $f  ");
    // debugPrint("getDataFromExcelTable $columns  ");
    List<ViewAbstract> generatedViewAbstract = [];
    List<String> exceptions = [];
    if (f != null) {
      var rows = f.sublist(0 + 1, f.length - 1);
      for (var element in rows) {
        int rowNumber = rows.indexOf(element) + 1;

        try {
          //  debugPrint("getDataFromExcelTable exception: " + e.toString());
          var obj = fileReader.getObjectFromRow(context, element);
          debugPrint("getDataFromExcelTable  getObjectFromRow $obj");
          generatedViewAbstract.add(obj);
        } catch (e) {
          debugPrint("getDataFromExcelTable exception: $e");
          debugPrint(e.toString());
          exceptions.add("in row number $rowNumber: ${e.toString()}");
        }
      }
    }
    return generatedViewAbstract;
  }

  Widget getWidget(BuildContext context, AsyncSnapshot<Object?> snapshot) {
    Excel excel = fileReaderObject.excel;
    var f = excel.tables[fileReaderObject.selectedSheet]?.rows;
    var columns = fileReaderObject.fileColumns;
    List<ViewAbstract> generatedViewAbstract = [];
    List<String> exceptions = [];
    if (f != null) {
      var rows = f.sublist(0 + 1, f.length - 1);
      for (var element in rows) {
        int rowNumber = rows.indexOf(element) + 1;

        try {
          var obj = fileReaderObject.getObjectFromRow(context, element);
          generatedViewAbstract.add(obj);
        } catch (e) {
          debugPrint(e.toString());
          exceptions.add("in row number $rowNumber: ${e.toString()}");
        }
      }
      if (exceptions.isNotEmpty) {
        return Text(exceptions.join("\n"));
      }
      // return getExcelDataTable(columns, context, rows);
      return ViewableTableViewAbstractWidget(
        viewAbstract: generatedViewAbstract,
        usePag: true,
      );
      return getViewAbstractDataTable(context, generatedViewAbstract);
    }

    return Text(snapshot.data.toString());
  }

  List<DataRow> getRowsViewAbstract(
      BuildContext context, List<ViewAbstract> data) {
    {
      return data.map((e) {
        int index = data.indexOf(e);
        return DataRow(
            // selected: lastIndexOfSelected == index,
            // onSelectChanged: (s) {
            //   debugPrint(
            //       "dataRow selectChange $s index=> ${list_invoice_details.indexOf(e)}");
            //   setState(() {
            //     lastIndexOfSelected = index;
            //   });
            // },
            cells: e
                .getMainFields(context: context)
                .map((ee) => DataCell(
                    Text(
                      e.getFieldValueCheckType(context, ee),
                      overflow: TextOverflow.fade,
                      // softWrap: true,
                    ),
                    showEditIcon: false))
                .toList());
      }).toList();
    }
  }

  Widget getViewAbstractDataTable(
      BuildContext context, List<ViewAbstract> data) {
    ViewAbstract first = data[0];
    List<DataColumn> columns = first
        .getMainFields()
        .map((e) => DataColumn(label: Text(first.getFieldLabel(context, e))))
        .toList();
    return ScrollableWidget(
      child: DataTable(
        // header: Text("Dada"),
        // source: _data,
        // columnSpacing: 20,
        // horizontalMargin: 10,
        // rowsPerPage: 8,
        showCheckboxColumn: true,
        // sortAscending: isAscending,
        // sortColumnIndex: sortColumnIndex,
        columns: columns,
        rows: getRowsViewAbstract(context, data),
      ),
    );
  }

  ScrollableWidget getExcelDataTable(
      List<String> columns, BuildContext context, List<List<Data?>> rows) {
    return ScrollableWidget(
      child: DataTable(
        // header: Text("Dada"),
        // source: _data,
        columnSpacing: 100,
        horizontalMargin: 10,
        // rowsPerPage: 8,
        showCheckboxColumn: false,
        // sortAscending: isAscending,
        // sortColumnIndex: sortColumnIndex,
        columns: columns.map((e) => DataColumn(label: Text(e))).toList(),
        rows: getRows(context, rows),
      ),
    );
  }
}
