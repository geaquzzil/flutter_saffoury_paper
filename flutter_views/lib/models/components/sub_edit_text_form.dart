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
  late ViewAbstract viewAbstract;
  @override
  void initState() {
    super.initState();
    viewAbstract = context.read<ActionViewAbstractProvider>().getObject;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
            textCapitalization:
                viewAbstract.getTextInputCapitalization(widget.field),
            decoration: InputDecoration(
              border: const UnderlineInputBorder(),
              filled: true,
              icon: viewAbstract.getTextInputIcon(widget.field),
              hintText: viewAbstract.getTextInputHint(context, widget.field),
              labelText: viewAbstract.getTextInputLabel(context, widget.field),
              prefixText:
                  viewAbstract.getTextInputPrefix(context, widget.field),
            ),
            keyboardType: viewAbstract.getTextInputType(widget.field),
            enabled: viewAbstract.getTextInputIsEnabled(widget.field),
            validator: (String? value) {
              return viewAbstract.getTextInputValidator(
                  context, widget.field, value);
            },
            onSaved: (String? value) {
              print('onSave=   $value');
            },
            inputFormatters: viewAbstract.getTextInputFormatter(widget.field)),
        const SizedBox(height: 24.0)
      ],
    );
  }
}
