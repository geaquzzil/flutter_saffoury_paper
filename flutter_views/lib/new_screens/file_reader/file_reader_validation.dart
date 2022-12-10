import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_view_controller/models/servers/server_data.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/scrollable_widget.dart';
import 'package:flutter_view_controller/new_screens/file_reader/file_rader_object_view_abstract.dart';
import 'package:flutter_view_controller/providers/filterables/fliterable_list_provider_api.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

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
        builder: ((context, snapshot) {
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

  Widget getWidget(BuildContext context, AsyncSnapshot<Object?> snapshot) {
    Excel excel = fileReaderObject.excel;
    var f = excel.tables[fileReaderObject.selectedSheet]?.rows;
    var columns = fileReaderObject.fileColumns;
    List<String> exceptions = [];
    if (f != null) {
      var rows = f.sublist(0 + 1, f.length - 1);
      rows.forEach((element) {
        int rowNumber = rows.indexOf(element) + 1;

        try {
          var obj = fileReaderObject.getObjectFromRow(context, element);
        } catch (e) {
          debugPrint(e.toString());
          exceptions.add("in row number $rowNumber: ${e.toString()}");
        }

        // debugPrint("FileReaderValidationWidget=> getObjectFromRow=> $obj");
      });
      if (exceptions.isNotEmpty) {
        return Text(exceptions.join("\n"));
      }
      // List<ViewAbstract> generatedObjects=List.generate(rows.length,fileReaderObject.viewAbstract.getSelfNewInstance())
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

    return Text(snapshot.data.toString());
  }
}
