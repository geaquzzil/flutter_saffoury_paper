import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/models/components/view_abstract_master_edit_form.dart';
import 'package:flutter_view_controller/models/components/sub_text_input.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/action_view_abstract_provider.dart';
import 'package:provider/provider.dart';

class MasterEditForm extends StatefulWidget {
  ViewAbstract parent;
  MasterEditForm({Key? key, required this.parent}) : super(key: key);

  @override
  State<MasterEditForm> createState() => _MasterEditFormState();
}

class _MasterEditFormState extends State<MasterEditForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> fields = widget.parent.getFields();

    return Scaffold(
        body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: FormBuilder(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                
                onChanged: () => print("form isChanging"),
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const SizedBox(height: 24.0),
                      ...fields.map((e) => buildWidget(e)).toList(),
                    ]))));
  }

  Widget buildWidget(String field) {
    dynamic fieldValue = widget.parent.getFieldValue(field);

    if (fieldValue is ViewAbstract) {
      return SubViewAbstractEditForm(parent: widget.parent, field: field);
    } else {
      return SubEditTextField(parent: widget.parent, field: field);
    }
  }
}
