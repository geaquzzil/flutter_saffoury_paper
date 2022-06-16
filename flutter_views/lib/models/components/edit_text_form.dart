import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_view_controller/models/components/sub_edit_text_form.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/action_view_abstract_provider.dart';
import 'package:provider/provider.dart';

class EditTextField extends StatefulWidget {
  const EditTextField({Key? key}) : super(key: key);

  @override
  State<EditTextField> createState() => _EditTextFieldState();
}

class _EditTextFieldState extends State<EditTextField> {
  late ViewAbstract viewAbstract;
  @override
  void initState() {
    super.initState();
    viewAbstract = context.read<ActionViewAbstractProvider>().getObject;
  }

  @override
  Widget build(BuildContext context) {
    List<String> fields = viewAbstract.getFields();
    return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 24.0),
              for (String field in fields) SubEditTextField(field: field)
            ]));
  }
}