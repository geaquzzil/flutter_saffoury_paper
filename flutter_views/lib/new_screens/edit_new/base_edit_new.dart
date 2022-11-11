import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/new_components/cards/filled_card.dart';
import 'package:flutter_view_controller/new_components/cards/outline_card.dart';
import 'package:flutter_view_controller/new_components/tab_bar/tab_bar_by_list.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../interfaces/cartable_interface.dart';
import '../../models/view_abstract.dart';
import '../../models/view_abstract_inputs_validaters.dart';
import '../../new_components/tables_widgets/cart_data_table_master.dart';
import '../../providers/actions/edits/edit_error_list_provider.dart';
import '../../providers/actions/edits/sub_edit_viewabstract_provider.dart';
import '../../screens/base_shared_actions_header.dart';
import '../edit/controllers/edit_controller_checkbox.dart';
import '../edit/controllers/edit_controller_dropdown.dart';
import '../edit/controllers/edit_controller_dropdown_api.dart';
import '../edit/controllers/edit_controller_edit_text.dart';
import '../edit/controllers/edit_controller_file_picker.dart';
import '../edit/controllers/ext.dart';
import 'edit_controllers_utils.dart';

@immutable
class BaseEditPageNew extends StatelessWidget {
  ViewAbstract viewAbstract;
  bool isTheFirst;
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  late List<String> fields;
  Map<String, TextEditingController> controllers = {};
  void Function(ViewAbstract? viewAbstract)? onValidate;
  late EditSubsViewAbstractControllerProvider prov;
  BaseEditPageNew(
      {Key? key,
      required this.viewAbstract,
      required this.isTheFirst,
      this.onValidate})
      : super(key: key);
  void init(BuildContext context) {
    prov = Provider.of<EditSubsViewAbstractControllerProvider>(context,
        listen: false);

    // _formKey = Provider.of<ErrorFieldsProvider>(context, listen: false)
    //     .getFormBuilderState;

    fields = viewAbstract.getMainFields();
  }

  bool isFieldEnabled(String field) {
    if (!viewAbstract.hasParent()) return viewAbstract.isFieldEnabled(field);
    return viewAbstract.isNew() && viewAbstract.isFieldEnabled(field);
  }

  TextEditingController getController(BuildContext context,
      {required String field, required dynamic value}) {
    if (controllers.containsKey(field)) {
      return controllers[field]!;
    }
    value = getEditControllerText(value);
    controllers[field] = TextEditingController();
    controllers[field]!.text = value;
    controllers[field]!.addListener(() {
      viewAbstract.onTextChangeListener(
          context, field, controllers[field]!.text);
      bool? validate =
          _formKey.currentState!.fields[viewAbstract.getTag(field)]?.validate();
      if (validate ?? false) {
        _formKey.currentState!.fields[viewAbstract.getTag(field)]?.save();
      }
      debugPrint("onTextChangeListener field=> $field validate=$validate");
      // modifieController(field);
    });
    viewAbstract.addTextFieldController(field, controllers[field]!);
    return controllers[field]!;
  }

  @override
  Widget build(BuildContext context) {
    init(context);
    // if (isTheFirst) {
    //   return Column(
    //     children: [
    //       BaseSharedHeaderViewDetailsActions(
    //         viewAbstract: viewAbstract,
    //       ),
    //       Row(
    //         children: [
    //           Expanded(
    //             child: Column(children: [
    //               SizedBox(
    //                 width: double.infinity,
    //                 height: MediaQuery.of(context).size.height,
    //                 child: SingleChildScrollView(
    //                     controller: ScrollController(),
    //                     physics: const AlwaysScrollableScrollPhysics(),
    //                     padding: const EdgeInsets.symmetric(
    //                         horizontal: kDefaultPadding),
    //                     child: Column(
    //                       children: [
    //                         buildForm(context),
    //                       ],
    //                     )),
    //               ),
    //             ]),
    //           ),
    //           Expanded(
    //             child: Expanded(child: Text("das")),
    //           )
    //         ],
    //       )
    //     ],
    //   );
    // }
    // if (!isTheFirst) {
    //   return OutlinedCard(child: Text(viewAbstract.toString()));
    // }
    Widget? table;
    if (viewAbstract is CartableInvoiceMasterObjectInterface) {
      table = CartDataTableMaster(
          action: ServerActions.edit,
          obj: viewAbstract as CartableInvoiceMasterObjectInterface);
    }
    Widget form = SingleChildScrollView(
        controller: ScrollController(),
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: Column(
          children: [
            if (isTheFirst)
              BaseSharedHeaderViewDetailsActions(
                viewAbstract: viewAbstract,
              ),
            buildForm(context),
            if (table != null) table
          ],
        ));
    return isTheFirst
        ? form
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: OutlinedCard(
              // fillColor: false,
              child: ExpansionTile(
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: viewAbstract.getCardLeadingCircleAvatar(context),
                  ),
                  trailing: IconButton(
                      icon: Icon(Icons.image_sharp), onPressed: () {}),
                  title: viewAbstract.getMainHeaderText(context),
                  children: [form]),
            ),
          );
  }

  FormBuilder buildForm(BuildContext context) {
    debugPrint("_BaseEdit buildForm ${viewAbstract.runtimeType}");
    return FormBuilder(
        autovalidateMode: AutovalidateMode.always,
        key: _formKey,
        onChanged: () {
          if (onValidate != null) {
            bool validate = _formKey.currentState!.validate();
            if (validate) {
              _formKey.currentState!.save();
              onValidate!(viewAbstract);
            }
          }
        },
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 24.0),
              ...fields.map((e) => buildWidget(context, e)).toList(),
              // ElevatedButton(
              //   onPressed: () {
              //     // validate();
              //   },
              //   child: const Text('Subment'),
              // )
            ]));
  }

  Widget buildWidget(BuildContext context, String field) {
    dynamic fieldValue = viewAbstract.getFieldValue(field);
    fieldValue ??= viewAbstract.getMirrorNewInstance(field);
    TextInputType? textInputType = viewAbstract.getTextInputType(field);
    ViewAbstractControllerInputType textFieldTypeVA =
        viewAbstract.getInputType(field);

    bool isAutoComplete = viewAbstract.getTextInputTypeIsAutoComplete(field);
    bool isAutoCompleteViewAbstract =
        viewAbstract.getTextInputTypeIsAutoCompleteViewAbstract(field);
    // if(fieldType== ViewAbstractEnum){
    //   return EditControllerDropdown(enumViewAbstract: enumViewAbstract, field: field)
    // }
    if (isAutoComplete) {
      return getControllerEditTextAutoComplete(context,
          viewAbstract: viewAbstract,
          field: field,
          controller: getController(context, field: field, value: fieldValue));
    }
    if (isAutoCompleteViewAbstract) {
      return getControllerEditTextViewAbstractAutoComplete(
        context,
        viewAbstract: viewAbstract,
        field: field,
        controller: getController(context, field: field, value: fieldValue),
        onSelected: (selectedViewAbstract) {
          viewAbstract =
              viewAbstract.copyWithNewSuggestion(selectedViewAbstract);

          viewAbstract.parent?.setFieldValue(field, viewAbstract);
        },
      );
    }
    if (fieldValue is ViewAbstract) {
      fieldValue.setParent(viewAbstract);
      fieldValue.setFieldNameFromParent(field);
      if (textFieldTypeVA == ViewAbstractControllerInputType.DROP_DOWN_API) {
        return EditControllerDropdownFromViewAbstract(
            parent: viewAbstract, viewAbstract: fieldValue, field: field);
      }
      return BaseEditPageNew(
        viewAbstract: fieldValue,
        isTheFirst: false,
        onValidate: ((ob) {
          // String? fieldName = ob?.getFieldNameFromParent()!;
          debugPrint("editPageNew subViewAbstract field=>$field value=>$ob");
          viewAbstract.setFieldValue(field, ob);
        }),
      );
    } else if (fieldValue is ViewAbstractEnum) {
      return EditControllerDropdown(
          parent: viewAbstract, enumViewAbstract: fieldValue, field: field);
    } else {
      if (textFieldTypeVA == ViewAbstractControllerInputType.CHECKBOX) {
        return EditControllerCheckBox(viewAbstract: viewAbstract, field: field);
      } else if (textFieldTypeVA ==
          ViewAbstractControllerInputType.COLOR_PICKER) {
      } else if (textFieldTypeVA == ViewAbstractControllerInputType.IMAGE) {
        return EditControllerFilePicker(
          viewAbstract: viewAbstract,
          field: field,
        );
      } else {
        if (textInputType == TextInputType.datetime) {
          return getControllerDateTime(context,
              viewAbstract: viewAbstract,
              field: field,
              value: fieldValue,
              enabled: isFieldEnabled(field));
        } else {
          return getControllerEditText(context,
              viewAbstract: viewAbstract,
              field: field,
              controller:
                  getController(context, field: field, value: fieldValue),
              enabled: isFieldEnabled(field));
        }
      }
      return ListTile(
        title: Text(field),
        subtitle: Text(fieldValue.toString()),
      );
    }
  }
}