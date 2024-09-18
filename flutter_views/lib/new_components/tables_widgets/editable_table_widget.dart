// ignore_for_file: non_constant_identifier_names

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/interfaces/listable_interface.dart';
import 'package:flutter_view_controller/new_components/scrollable_widget.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

import '../../models/view_abstract.dart';
import '../../models/view_abstract_enum.dart';
import '../../models/view_abstract_inputs_validaters.dart';
import '../../new_screens/controllers/edit_controller_checkbox.dart';
import '../../new_screens/controllers/edit_controller_dropdown.dart';
import '../../new_screens/controllers/edit_controller_file_picker.dart';
import '../../new_screens/controllers/ext.dart';
import '../../new_screens/actions/edit_new/edit_controllers_utils.dart';

@immutable
class EditableTableWidget extends StatefulWidget {
  ListableInterface viewAbstract;

  ///if the obj is set then we get the obj data
  ///else the cartProvider data
  EditableTableWidget({super.key, required this.viewAbstract});

  @override
  State<EditableTableWidget> createState() => _EditableTableWidget();
}

@immutable
class _EditableTableWidget extends State<EditableTableWidget> {
  late List<ViewAbstract> list_invoice_details;
  late List<String> fields;

  Map<String, TextEditingController> controllers = {};
  int? sortColumnIndex;
  bool isAscending = false;
  late GlobalKey<FormBuilderState> _formKey;
  int lastIndexOfSelected = -1;
  @override
  void didUpdateWidget(covariant EditableTableWidget oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    list_invoice_details = widget.viewAbstract.getListableList();
    fields =
        (widget.viewAbstract as ViewAbstract).getMainFields(context: context);
  }

  @override
  void initState() {
    super.initState();
    list_invoice_details = widget.viewAbstract.getListableList();
    fields =
        (widget.viewAbstract as ViewAbstract).getMainFields(context: context);
    _formKey = GlobalKey<FormBuilderState>();
  }

  @override
  void dispose() {
    // for (var element in controllers.values) {
    //   element.dispose();
    // }
    // controllers.clear();
    super.dispose();
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
    return ScrollableWidget(child: buildForm());
  }

  final DataTableSource _data = MyData();
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
        .getMainFields(context: context)
        .map((e) => DataColumn(
              numeric: true,
              label: Text(first.getFieldLabel(context, e)),
              // onSort: (columnIndex, ascending) =>
              // onSort(context, columnIndex, ascending),
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
              .getMainFields(context: context)
              .map((ee) => DataCell(
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: getControllerWidget(context, e, ee, index),
                  ),
                  showEditIcon: false))
              .toList());
    }).toList();
  }

  TextEditingController getController(BuildContext context,
      {required String field,
      required String controllerKey,
      required dynamic value,
      bool isAutoCompleteVA = false}) {
    if (controllers.containsKey(field)) {
      return controllers[controllerKey]!;
    }
    value = getEditControllerText(value);
    controllers[controllerKey] = TextEditingController();
    controllers[controllerKey]!.text = value;
    controllers[controllerKey]!.addListener(() {
      (widget.viewAbstract as ViewAbstract).onTextChangeListener(
          context, field, controllers[controllerKey]!.text,
          formKey: _formKey);
      bool? validate = _formKey.currentState!
          .fields[(widget.viewAbstract as ViewAbstract).getTag(field)]
          ?.validate(focusOnInvalid: false);
      if (validate ?? false) {
        _formKey.currentState!
            .fields[(widget.viewAbstract as ViewAbstract).getTag(field)]
            ?.save();
      }
      debugPrint("onTextChangeListener field=> $field validate=$validate");
      if (isAutoCompleteVA) {
        if (controllers[controllerKey]!.text ==
            getEditControllerText((widget.viewAbstract as ViewAbstract)
                .getFieldValue(field, context: context))) {
          return;
        }
        //TODO viewAbstract =
        //TODO     viewAbstract.copyWithSetNew(field, controllers[field]!.text);
        //TODO viewAbstract.parent?.setFieldValue(field, viewAbstract);
        //  refreshControllers(context);
        //TODO viewAbstractChangeProvider.change(viewAbstract);
      }

      // }
      // modifieController(field);
    });
    (widget.viewAbstract as ViewAbstract)
        .addTextFieldController(field, controllers[controllerKey]!);
    return controllers[controllerKey]!;
  }

  bool isFieldEnabled(String field) {
    return true;
    // if (!viewAbstract.hasParent()) return viewAbstract.isFieldEnabled(field);
    // return viewAbstract.isNew() && viewAbstract.isFieldEnabled(field);
  }

  Widget getControllerWidget(
      BuildContext context, ViewAbstract parent, String field, int idx) {
    dynamic fieldValue = parent.getFieldValue(field, context: context);
    fieldValue ??= parent.getMirrorNewInstance(field);
    TextInputType? textInputType = parent.getTextInputType(field);
    ViewAbstractControllerInputType textFieldTypeVA =
        parent.getInputType(field);

    // bool isAutoComplete = parent.getTextInputTypeIsAutoComplete(field);
    // bool isAutoCompleteViewAbstract =
    //     parent.getTextInputTypeIsAutoCompleteViewAbstract(field);
    // if (isAutoComplete) {
    //   return getControllerEditTextAutoComplete(context,
    //       viewAbstract: parent,
    //       field: field,
    //       controller: getController(context, field: field, value: fieldValue));
    // }
    // if (isAutoCompleteViewAbstract) {}
    if (fieldValue is ViewAbstract) {
      fieldValue.setFieldNameFromParent(field);
      fieldValue.setParent(parent);
      return getControllerEditTextViewAbstractAutoComplete(
        autoCompleteBySearchQuery: true,
        context,
        viewAbstract: fieldValue,
        field: field,
        controller: getController(context,
            field: field,
            controllerKey: "${field}_$idx",
            value: fieldValue.getMainHeaderTextOnly(context),
            isAutoCompleteVA: true),
        onSelected: (selectedViewAbstract) {
          // viewAbstract = selectedViewAbstract;
          fieldValue.parent?.setFieldValue(field, selectedViewAbstract);
          // refreshControllers(context, field);
          // //TODO viewAbstractChangeProvider.change(viewAbstract);
          // // context.read<ViewAbstractChangeProvider>().change(viewAbstract);
        },
      );
    } else if (fieldValue is ViewAbstractEnum) {
      return EditControllerDropdown(
          parent: parent, enumViewAbstract: fieldValue, field: field);
    } else {
      if (textFieldTypeVA == ViewAbstractControllerInputType.CHECKBOX) {
        return EditControllerCheckBox(viewAbstract: parent, field: field);
      } else if (textFieldTypeVA ==
          ViewAbstractControllerInputType.COLOR_PICKER) {
      } else if (textFieldTypeVA == ViewAbstractControllerInputType.IMAGE) {
        return EditControllerFilePicker(
          viewAbstract: parent,
          field: field,
        );
      } else {
        if (textInputType == TextInputType.datetime) {
          return getControllerDateTime(context,
              viewAbstract: parent,
              field: field,
              value: fieldValue,
              enabled: isFieldEnabled(field));
        } else {
          return getControllerEditText(context,
              viewAbstract: parent,
              field: field,
              withDecoration: false,
              controller: getController(context,
                  field: field,
                  controllerKey: "${field}_$idx",
                  value: fieldValue),
              enabled: isFieldEnabled(field));
        }
      }
      return ListTile(
        title: Text(field),
        subtitle: Text(fieldValue.toString()),
      );
    }
  }

  void refreshControllers(BuildContext context, String currentField) {
    controllers.forEach((key, value) {
      if (key != currentField) {
        (widget.viewAbstract as ViewAbstract)
            .toJsonViewAbstract()
            .forEach((field, value) {
          if (key == field) {
            controllers[key]!.text = getEditControllerText(
                (widget.viewAbstract as ViewAbstract)
                    .getFieldValue(field, context: context));
          }
        });
      }
    });
  }

  // void onSort(BuildContext context, int columnIndex, bool ascending) {
  //   debugPrint(
  //       "onSort: columnIndex $columnIndex  listsize=> ${list_invoice_details.length} ");
  //   list_invoice_details.sort((obj1, obj2) => compareDynamic(
  //       ascending,
  //       obj1
  //           .getCartInvoiceTableHeaderAndContent(context)
  //           .values
  //           .elementAt(columnIndex)
  //           .value,
  //       obj2
  //           .getCartInvoiceTableHeaderAndContent(context)
  //           .values
  //           .elementAt(columnIndex)
  //           .value));

  //   setState(() {
  //     sortColumnIndex = columnIndex;
  //     isAscending = ascending;
  //   });
  // }

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
