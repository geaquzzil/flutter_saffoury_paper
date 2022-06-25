import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

class SubEditTextField extends StatefulWidget {
  String field;
  ViewAbstract parent;
  SubEditTextField({Key? key, required this.parent, required this.field})
      : super(key: key);

  @override
  State<SubEditTextField> createState() => _SubEditTextFieldState();
}

class _SubEditTextFieldState extends State<SubEditTextField> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
            initialValue: widget.parent.getFieldValue(widget.field),
            maxLength: widget.parent.getTextInputMaxLength(widget.field),
            textCapitalization:
                widget.parent.getTextInputCapitalization(widget.field),
            decoration: InputDecoration(
              border: const UnderlineInputBorder(),
              filled: true,
              icon: widget.parent.getTextInputIcon(widget.field),
              hintText: widget.parent.getTextInputHint(context, widget.field),
              labelText: widget.parent.getTextInputLabel(context, widget.field),
              prefixText:
                  widget.parent.getTextInputPrefix(context, widget.field),
            ),
            keyboardType: widget.parent.getTextInputType(widget.field),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            enabled: widget.parent.getTextInputIsEnabled(widget.field),
            validator: (String? value) {
              return widget.parent
                  .getTextInputValidator(context, widget.field, value);
            },
            onSaved: (String? value) {
              print('onSave=   $value');
            },
            inputFormatters: widget.parent.getTextInputFormatter(widget.field)),
        const SizedBox(height: 24.0)
      ],
    );
  }
}
