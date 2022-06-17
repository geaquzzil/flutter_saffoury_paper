import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/components/title_text.dart';
import 'package:flutter_view_controller/models/components/sub_text_input.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/action_view_abstract_provider.dart';
import 'package:provider/provider.dart';

class SubViewAbstractEditForm extends StatefulWidget {
  String field;
  ViewAbstract parent;
  SubViewAbstractEditForm({Key? key, required this.parent, required this.field})
      : super(key: key);

  @override
  State<SubViewAbstractEditForm> createState() =>
      _SubViewAbstractEditFormState();
}

class _SubViewAbstractEditFormState extends State<SubViewAbstractEditForm> {
  late ViewAbstract currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = widget.parent.getFieldValue(widget.field);
  }

  @override
  Widget build(BuildContext context) {
    List<String> fields = currentValue.getFields();
    return Column(
      children: [
        ExpansionTile(
          childrenPadding: const EdgeInsets.all(30),
          subtitle: currentValue.getSubtitleHeaderText(context),
          title: TitleText(
            text: currentValue.getHeaderTextOnly(context),
            fontSize: 27,
            fontWeight: FontWeight.w400,
          ),
          leading: currentValue.getCardLeadingEditCard(context),
          children: [
            FormBuilder(
                key: widget.key,
                child: Column(
                  children: [
                    const SizedBox(height: 24.0),
                    ...fields.map((e) => buildWidget(e)).toList(),
                  ],
                ))
          ],
        ),
        const SizedBox(height: 24.0)
      ],
    );
  }

  Widget buildWidget(String field) {
    // _formKey.currentState!.save();

    // FocusScope.of(context).unfocus();

    dynamic fieldValue = currentValue.getFieldValue(field);

    if (fieldValue is ViewAbstract) {
      return Text('T');
    } else {
      return getFormText(field);
    }
  }

  Widget getFormText(String field) {
    return Column(
      children: [
        FormBuilderTextField(
            name: currentValue.getTag(field),
            initialValue: currentValue.getFieldValue(field),
            maxLength: currentValue.getTextInputMaxLength(field),
            textCapitalization: currentValue.getTextInputCapitalization(field),
            decoration: InputDecoration(
              border: const UnderlineInputBorder(),
              filled: true,
              icon: currentValue.getTextInputIcon(field),
              hintText: currentValue.getTextInputHint(context, field),
              labelText: currentValue.getTextInputLabel(context, field),
              prefixText: currentValue.getTextInputPrefix(context, field),
            ),
            keyboardType: currentValue.getTextInputType(field),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            //TODO enabled: widget.parent.getTextInputIsEnabled(widget.field),
            validator: (String? value) {
              return currentValue.getTextInputValidator(context, field, value);
            },
            onSaved: (String? value) {
              print('onSave=   $value');
            },
            inputFormatters: currentValue.getTextInputFormatter(field)),
        const SizedBox(height: 24.0)
      ],
    );
  }
}
