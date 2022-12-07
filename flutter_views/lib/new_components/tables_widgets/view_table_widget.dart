import 'dart:math';

import 'package:data_table_2/paginated_data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/interfaces/cartable_interface.dart';
import 'package:flutter_view_controller/interfaces/listable_interface.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/new_components/cards/outline_card.dart';
import 'package:flutter_view_controller/new_components/scrollable_widget.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/providers/cart/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

import '../../models/view_abstract.dart';
import '../../models/view_abstract_enum.dart';
import '../../models/view_abstract_inputs_validaters.dart';
import '../../new_screens/edit/controllers/edit_controller_checkbox.dart';
import '../../new_screens/edit/controllers/edit_controller_dropdown.dart';
import '../../new_screens/edit/controllers/edit_controller_dropdown_api.dart';
import '../../new_screens/edit/controllers/edit_controller_file_picker.dart';
import '../../new_screens/edit/controllers/ext.dart';
import '../../new_screens/edit_new/edit_controllers_utils.dart';

@immutable
class ViewableTableWidget extends StatefulWidget {
  ListableInterface viewAbstract;

  ///if the obj is set then we get the obj data
  ///else the cartProvider data
  ViewableTableWidget({Key? key, required this.viewAbstract}) : super(key: key);

  @override
  State<ViewableTableWidget> createState() => _ViewableTableWidget();
}

@immutable
class _ViewableTableWidget extends State<ViewableTableWidget> {
  late List<ViewAbstract> list_invoice_details;
  late List<String> fields;

  Map<String, TextEditingController> controllers = {};
  int? sortColumnIndex;
  bool isAscending = false;
  late GlobalKey<FormBuilderState> _formKey;
  int lastIndexOfSelected = -1;
  @override
  void didUpdateWidget(covariant ViewableTableWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    list_invoice_details = widget.viewAbstract.getListableList();
    fields = (widget.viewAbstract as ViewAbstract).getMainFields();
  }

  @override
  void initState() {
    super.initState();
    list_invoice_details = widget.viewAbstract.getListableList();
    fields = (widget.viewAbstract as ViewAbstract).getMainFields();
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
    return SizedBox(
        width: double.infinity, child: ScrollableWidget(child: buildForm()));
  }

  Widget buildForm() {
    return FormBuilder(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey,
        child: Column(
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
        ));
  }

  List<DataColumn> getColumns(BuildContext context) {
    ViewAbstract first = list_invoice_details[0];
    return first
        .getMainFields()
        .map((e) => DataColumn(
              numeric: true,
              label: Text(first.getFieldLabel(context, e)),
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
              .getMainFields()
              .map((ee) => DataCell(
                  Text(
                    e.getFieldValueCheckType(context, ee),
                    overflow: TextOverflow.visible,
                    softWrap: true,
                  ),
                  showEditIcon: false))
              .toList());
    }).toList();
  }

  void onSort(BuildContext context, int columnIndex, bool ascending) {
    debugPrint(
        "onSort: columnIndex $columnIndex  listsize=> ${list_invoice_details.length} ");
    list_invoice_details.sort((obj1, obj2) => compareDynamic(
        ascending,
        obj1.getFieldValueCheckType(context, obj1.getMainFields()[columnIndex]),
        obj2.getFieldValueCheckType(
            context, obj2.getMainFields()[columnIndex])));

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
  // Generate some made-up data
  final List<Map<String, dynamic>> _data = List.generate(
      200,
      (index) => {
            "id": index,
            "title": "Item $index",
            "price": Random().nextInt(10000)
          });

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => _data.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(_data[index]['id'].toString())),
      DataCell(Text(_data[index]["title"])),
      DataCell(Text(_data[index]["price"].toString())),
    ]);
  }
}
