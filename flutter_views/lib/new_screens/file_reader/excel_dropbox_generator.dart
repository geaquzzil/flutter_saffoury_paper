import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/new_screens/controllers/controller_dropbox_list.dart';

class ExcelDropboxGenerator extends StatefulWidget {
  String filePath;

  ExcelDropboxGenerator({super.key, required this.filePath});

  @override
  State<ExcelDropboxGenerator> createState() => _ExcelDropboxGeneratorState();
}

class _ExcelDropboxGeneratorState extends State<ExcelDropboxGenerator> {
  late List<Data> columns;

  late List<List<Data?>> rows;

  List<DataRow> getRows(BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    var bytes = File(widget.filePath).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);
    debugPrint(" ExcelDropboxGenerator ${excel.tables.keys} ");
    return DropdownStringListControllerListener(
      tag: "",
      hint: AppLocalizations.of(context)!
          .selectFormat(AppLocalizations.of(context)!.worksheet),
      list: excel.tables.keys
          .map((e) =>
              DropdownStringListItem(icon: null, label: e.toString(), value: e))
          .toList(),
      onValueSelectedFunction: (object) {},
    );

    // for (var table in excel.tables.keys) {
    //   rows = excel.tables[table]!.rows;
    //   if (rows.isEmpty) continue;
    //   columns = rows[0].cast();
    //   return ScrollableWidget(
    //     child: DataTable(
    //       // header: Text("Dada"),
    //       // source: _data,
    //       columnSpacing: 100,
    //       horizontalMargin: 10,
    //       // rowsPerPage: 8,
    //       showCheckboxColumn: false,
    //       // sortAscending: isAscending,
    //       // sortColumnIndex: sortColumnIndex,
    //       columns:
    //           columns.map((e) => DataColumn(label: Text(e.value))).toList(),
    //       rows: getRows(context),
    //     ),
    //   );

    //   // {
    //   //   // debugPrint("ExcelDropboxGenerator $table"); //sheet Name
    //   //   // debugPrint("ExcelDropboxGenerator ${excel.tables[table]!.maxCols}");
    //   //   // debugPrint("ExcelDropboxGenerator ${excel.tables[table]!.maxRows}");
    //   //   for (var row in rows) {
    //   //     debugPrint("ExcelDropboxGenerator row: $row");
    //   //     for (var sel in row) {
    //   //       debugPrint("ExcelDropboxGenerator value: ${sel?.value}");
    //   //       // debugPrint("ExcelDropboxGenerator value: ${sel?.value}");
    //   //     }
    //   //   }
    //   // }
    // }
    // return Text("EMT");
  }
}
