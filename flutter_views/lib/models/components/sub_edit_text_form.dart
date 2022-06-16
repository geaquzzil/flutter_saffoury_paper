import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/action_view_abstract_provider.dart';
import 'package:provider/provider.dart';

class SubEditTextField extends StatefulWidget {
  String field;
  SubEditTextField({Key? key, required this.field}) : super(key: key);

  @override
  State<SubEditTextField> createState() => _SubEditTextFieldState();
}

class _SubEditTextFieldState extends State<SubEditTextField> {
  late ViewAbstract parentViewAbstract;
  @override
  void initState() {
    super.initState();
    parentViewAbstract = context.read<ActionViewAbstractProvider>().getObject;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
            initialValue: parentViewAbstract.getFieldValue(widget.field),
            textCapitalization:
                parentViewAbstract.getTextInputCapitalization(widget.field),
            decoration: InputDecoration(
              border: const UnderlineInputBorder(),
              filled: true,
              icon: parentViewAbstract.getTextInputIcon(widget.field),
              hintText: parentViewAbstract.getTextInputHint(context, widget.field),
              labelText: parentViewAbstract.getTextInputLabel(context, widget.field),
              prefixText:
                  parentViewAbstract.getTextInputPrefix(context, widget.field),
            ),
            keyboardType: parentViewAbstract.getTextInputType(widget.field),
            enabled: parentViewAbstract.getTextInputIsEnabled(widget.field),
            validator: (String? value) {
              return parentViewAbstract.getTextInputValidator(
                  context, widget.field, value);
            },
            onSaved: (String? value) {
              print('onSave=   $value');
            },
            inputFormatters: parentViewAbstract.getTextInputFormatter(widget.field)),
        const SizedBox(height: 24.0)
      ],
    );
  }
}
