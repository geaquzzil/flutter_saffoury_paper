// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/models/servers/server_data.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/file_reader/file_rader_object_view_abstract.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/providers/filterables/fliterable_list_provider_api.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../new_components/tables_widgets/view_table_view_abstract.dart';

class FileReaderValidationWidget extends StatefulWidget {
  FileReaderObject fileReaderObject;
  bool useTableView;

  FileReaderValidationWidget(
      {super.key, required this.fileReaderObject, this.useTableView = true});

  @override
  State<FileReaderValidationWidget> createState() =>
      FileReaderValidationWidgetState();

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
      debugPrint("getDataFromExcelTable f != null f length =>${f.length} ");
      var rows = f.sublist(0 + 1, f.length);
      debugPrint("getDataFromExcelTable rows length  ${rows.length}");
      for (var element in rows) {
        int rowNumber = rows.indexOf(element) + 1;
        debugPrint("getDataFromExcelTable row int rowNumber $rowNumber ");

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
}

class FileReaderValidationWidgetState
    extends State<FileReaderValidationWidget> {
  List<ViewAbstract> _generatedViewAbstract = [];
  List<ViewAbstract> getListGeneratedList() {
    return _generatedViewAbstract;
  }

  @override
  Widget build(BuildContext context) {
    // return getWidget(context);
    debugPrint(
        "FileReaderValidationWidget fileReaderObject=> ${widget.fileReaderObject}");
    return FutureBuilder(
        future: context
            .read<FilterableListApiProvider<FilterableData>>()
            .getServerData(widget.fileReaderObject.viewAbstract),
        builder: ((s, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return getWidget(context, snapshot: snapshot);
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError || snapshot.hasData == false) {
            return EmptyWidget(
                expand: true,
                onSubtitleClicked: () {
                  setState(() {});
                },
                lottiUrl:
                    "https://assets7.lottiefiles.com/packages/lf20_0s6tfbuc.json",
                title: AppLocalizations.of(context)!.cantConnect,
                subtitle:
                    AppLocalizations.of(context)!.cantConnectConnectToRetry);
          }
          return Center(
            child: Lottie.network(
                "https://assets3.lottiefiles.com/packages/lf20_mr1olA.json"),
          );
        }));
  }

  Widget getWidget(BuildContext context, {AsyncSnapshot<Object?>? snapshot}) {
    Excel excel = widget.fileReaderObject.excel;
    var f = excel.tables[widget.fileReaderObject.selectedSheet]?.rows;
    var columns = widget.fileReaderObject.fileColumns;
    _generatedViewAbstract.clear();
    // debugPrint("getDataFromExcelTable => ros=>f $f  ");
    // debugPrint("getDataFromExcelTable=>fileColumns $columns  ");

    List<String> exceptions = [];

    if (f != null) {
      debugPrint("getDataFromExcelTable f != null f length =>${f.length} ");
      var rows = f.sublist(0 + 1, f.length);
      debugPrint("getDataFromExcelTable=>rows length ${rows.length}  ");
      for (var element in rows) {
        int rowNumber = rows.indexOf(element) + 1;
        debugPrint(
            "getDataFromExcelTable=>rowNumber ${rowNumber}   type ${element.runtimeType}");

        try {
          var obj = widget.fileReaderObject.getObjectFromRow(context, element);
          _generatedViewAbstract.add(obj);
        } catch (e) {
          debugPrint(e.toString());
          exceptions.add("in row number $rowNumber: ${e.toString()}");
        }
      }
      if (exceptions.isNotEmpty) {
        return Text(exceptions.join("\n"));
      }
      // return getExcelDataTable(columns, context, rows);
      return !widget.useTableView
          ? Column(
              children: [
                ..._generatedViewAbstract.map((toElement) {
                  return ListTile(
                    title: toElement.getMainHeaderText(context),
                    leading: toElement.getCardLeading(context),
                    subtitle: toElement.getMainSubtitleHeaderText(context),
                    // trailing: toElement.,
                  );
                })
              ],
            )
          : SizedBox(
              width: double.maxFinite,
              height: 1000,
              child: ViewableTableViewAbstractWidget(
                viewAbstract: _generatedViewAbstract,
                usePag: true,
              ));
    }

    return Text(snapshot?.data.toString() ?? "");
  }
}
