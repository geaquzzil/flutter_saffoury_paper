import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/view_abstract.dart';
import '../../providers/actions/edits/edit_error_list_provider.dart';
import '../../providers/actions/edits/sub_edit_viewabstract_provider.dart';
import '../../screens/base_shared_actions_header.dart';

class BaseEditPageNew extends StatelessWidget {
  ViewAbstract viewAbstract;
  late GlobalKey<FormBuilderState> _formKey;
  late List<String> fields;
  late EditSubsViewAbstractControllerProvider prov;
  BaseEditPageNew({Key? key, required this.viewAbstract}) : super(key: key);
  void init(BuildContext context) {
    prov = Provider.of<EditSubsViewAbstractControllerProvider>(context,
        listen: false);

    _formKey = Provider.of<ErrorFieldsProvider>(context, listen: false)
        .getFormBuilderState;

    fields = viewAbstract.getMainFields();
  }

  @override
  Widget build(BuildContext context) {
    init(context);
    return SingleChildScrollView(
        controller: ScrollController(),
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: Column(
          children: [
            BaseSharedHeaderViewDetailsActions(
              viewAbstract: viewAbstract,
            ),
            buildForm(),
          ],
        ));
  }

  FormBuilder buildForm() {
    debugPrint("_BaseEdit buildForm ${viewAbstract.runtimeType}");
    return FormBuilder(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 24.0),
              ...fields.map((e) => buildWidget(viewAbstract, e)).toList(),
              ElevatedButton(
                onPressed: () {
                  // validate();
                },
                child: const Text('Subment'),
              )
            ]));
  }

  Widget buildWidget(ViewAbstract viewAbstract, String field) {
    dynamic fieldValue = viewAbstract.getFieldValue(field);
    fieldValue ??= viewAbstract.getMirrorNewInstance(field);
    return ListTile(
      title: Text(field),
      subtitle: Text(fieldValue.toString()),
    );
    // debugPrint(
    //     "_BaseEdit buildWidget ${widget.parent.runtimeType} field=>$field");
    // dynamic fieldValue = viewAbstract.getFieldValue(field);
    // // Type? fieldTypeMirror = viewAbstract.getMirrorFieldType(field);
    // fieldValue ??= viewAbstract.getMirrorNewInstance(field);
    // ViewAbstractControllerInputType textFieldTypeVA =
    //     viewAbstract.getInputType(field);

    // // debugPrint("fieldValueType is ${fieldValue.runtimeType}");
    // // debugPrint("fieldTypeMirror field $field is=> $fieldTypeMirror");
    // // debugPrint(
    // //     "fieldTypeMirror field $field is viewAbstract=> ${fieldTypeMirror == ViewAbstract}");
    // // if (checkIfNullAndViewAbstractField(viewAbstract,
    // //     fieldValue: fieldValue, fieldName: field)) {
    // //   fieldValue = viewAbstract.getMirrorNewInstanceViewAbstract(field);
    // //   fieldValue.setParent(viewAbstract);
    // //   fieldValue.setFieldNameFromParent(field);
    // //   return EditSubViewAbstractHeader(viewAbstract: fieldValue, field: field);
    // // }
    // if (fieldValue is ViewAbstract) {
    //   fieldValue.setParent(viewAbstract);
    //   fieldValue.setFieldNameFromParent(field);
    //   if (textFieldTypeVA == ViewAbstractControllerInputType.DROP_DOWN_API) {
    //     return EditControllerDropdownFromViewAbstract(
    //         parent: viewAbstract, viewAbstract: fieldValue, field: field);
    //   }
    //   // return Text("FDFD");
    //   return EditSubViewAbstractHeader(viewAbstract: fieldValue, field: field);
    // } else if (fieldValue is ViewAbstractEnum) {
    //   return EditControllerDropdown(
    //       parent: viewAbstract, enumViewAbstract: fieldValue, field: field);
    // } else {
    //   return EditControllerMasterWidget(
    //       viewAbstract: viewAbstract, field: field);
    // }
  }
}
