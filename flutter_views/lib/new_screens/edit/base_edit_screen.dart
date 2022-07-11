import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/models/components/form_validator.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/edit/controllers/edit_controller_master.dart';
import 'package:flutter_view_controller/new_screens/edit/sub_viewabstract/components/sub_edit_viewabstract_header.dart';
import 'package:flutter_view_controller/new_screens/edit/sub_viewabstract/components/sub_edit_viewabstract_nullable_button.dart';
import 'package:flutter_view_controller/providers/actions/edits/edit_error_list_provider.dart';
import 'package:flutter_view_controller/providers/actions/edits/sub_edit_viewabstract_provider.dart';
import 'package:provider/provider.dart';

class BaseEditPage extends StatefulWidget {
  ViewAbstract parent;
  BaseEditPage({Key? key, required this.parent}) : super(key: key);

  @override
  State<BaseEditPage> createState() => _BaseEditPageState();
}

class _BaseEditPageState extends State<BaseEditPage> {
  _BaseEditPageState() {
    debugPrint("constructor _BaseEditPageState");
  }
  final _formKey = GlobalKey<FormBuilderState>();
  late List<String> fields;
  @override
  void didUpdateWidget(BaseEditPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    debugPrint("didUpdateWidget _BaseEditPageState");
    // Provider.of<ErrorFieldsProvider>(context, listen: false).clear();
    Provider.of<EditSubsViewAbstractControllerProvider>(context, listen: false)
        .clear();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint("didChangeDependencies _BaseEditPageState");
  }

  @override
  void initState() {
    debugPrint("initState _BaseEditPageState");
    super.initState();
    ErrorFieldsProvider errorFieldsProvider =
        Provider.of<ErrorFieldsProvider>(context, listen: false);

    errorFieldsProvider.initState();

    fields = widget.parent.getFields();
  }

  @override
  void dispose() {
    debugPrint("dispose _BaseEditPageState");
    Provider.of<ErrorFieldsProvider>(context, listen: false).clear();
    Provider.of<EditSubsViewAbstractControllerProvider>(context, listen: false)
        .clear();
    super.dispose();
  }

  void validate() {
    FocusScope.of(context).unfocus();
    final validationSuccess = _formKey.currentState!.validate();
    if (!validationSuccess) {
      _formKey.currentState!.save();
      debugPrint("validate ${_formKey.currentState?.value}");
      // showMaterialBanner();
    }
    if (validationSuccess) {
      //loop to formkeys validate

      _formKey.currentState!.save();
      final formData = _formKey.currentState?.value;
      debugPrint("validate $formData");
      // widget.parent.setFieldValue(
      //     _formKey.currentState!.value);
      // Provider.of<ActionViewAbstractProvider>(
      //     context,
      //     listen: false)
      //     .save();
      // Navigator.pop(context);

    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: buildForm());
  }

  FormBuilder buildForm() {
    return FormBuilder(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        // onChanged: () => {
        //       context
        //           .read<ErrorFieldsProvider>()
        //           .change(_formValidationManager)
        //     },
        key: _formKey,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 24.0),
              ...fields.map((e) => buildWidget(widget.parent, e)).toList(),
              ElevatedButton(
                onPressed: () {
                  validate();
                },
                child: const Text('Subment'),
              )
            ]));
  }

  Widget buildWidget(ViewAbstract viewAbstract, String field) {
    dynamic fieldValue = viewAbstract.getFieldValue(field);
    if (fieldValue is ViewAbstract) {
      fieldValue.setParent(viewAbstract);

      fieldValue.setFieldNameFromParent(field);
      // return Text("FDFD");
      return EditSubViewAbstractHeader(viewAbstract: fieldValue, field: field);
    } else {
      return EditControllerMasterWidget(
          viewAbstract: viewAbstract, field: field);
    }
  }
}
