import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/components/title_text.dart';
import 'package:flutter_view_controller/models/components/form_validator.dart';
import 'package:flutter_view_controller/models/components/view_abstract_master_edit_form.dart';
import 'package:flutter_view_controller/models/components/sub_text_input.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/action_view_abstract_provider.dart';
import 'package:flutter_view_controller/providers/edit_error_list_provider.dart';
import 'package:provider/provider.dart';

class MasterEditForm extends StatefulWidget {
  ViewAbstract parent;
  MasterEditForm({Key? key, required this.parent}) : super(key: key);

  @override
  State<MasterEditForm> createState() => _MasterEditFormState();
}

class _MasterEditFormState extends State<MasterEditForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _formValidationManager = FormValidationManager();
  @override
  void initState() {
    super.initState();
    context.read<ErrorFieldsProvider>().change(_formValidationManager);
  }

  @override
  void dispose() {
    _formValidationManager.dispose();
    super.dispose();
  }

  void showMaterialBanner() => ScaffoldMessenger.of(context).showMaterialBanner(
        MaterialBanner(
          leading: Icon(Icons.error),
          content: Expanded(
            child: ListView.builder(
              itemCount: _formValidationManager.erroredFields.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () => _formValidationManager
                    .erroredFields[index].focusNode
                    .requestFocus(),
                child: Text(_formValidationManager.erroredFields[index]
                    .getErrorMessage(context)!),
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('DISMISS'),
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    List<String> fields = widget.parent.getFields();

    return Scaffold(
        body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: FormBuilder(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: () => {
                      context
                          .read<ErrorFieldsProvider>()
                          .change(_formValidationManager)
                    },
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const SizedBox(height: 24.0),
                      ...fields
                          .map((e) => buildWidget(widget.parent, e))
                          .toList(),
                      ElevatedButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          final validationSuccess =
                              _formKey.currentState!.validate();
                          if (!validationSuccess) {
                            _formKey.currentState!.save();
                            print(_formKey.currentState?.value);
                            showMaterialBanner();
                          }
                          if (validationSuccess) {
                            //loop to formkeys validate

                            _formKey.currentState!.save();
                            final formData = _formKey.currentState?.value;

                            print(formData);
                            // widget.parent.setFieldValue(
                            //     _formKey.currentState!.value);
                            // Provider.of<ActionViewAbstractProvider>(
                            //     context,
                            //     listen: false)
                            //     .save();
                            // Navigator.pop(context);

                          }
                        },
                        child: Text('Subment'),
                      )
                    ]))));
  }

  Widget buildViewAbstractMasterWidget(
      ViewAbstract currentViewAbstract, String field) {
    List<String> fields = currentViewAbstract.getFields();

    return Column(
      children: [
        ExpansionTile(
          collapsedIconColor: context
                  .watch<ErrorFieldsProvider>()
                  .formValidationManager
                  .hasError(currentViewAbstract)
              ? Colors.red
              : null,
          collapsedTextColor: context
                  .watch<ErrorFieldsProvider>()
                  .formValidationManager
                  .hasError(currentViewAbstract)
              ? Colors.red
              : null,
          iconColor: context
                  .watch<ErrorFieldsProvider>()
                  .formValidationManager
                  .hasError(currentViewAbstract)
              ? Colors.red
              : null,
          textColor: context
                  .watch<ErrorFieldsProvider>()
                  .formValidationManager
                  .hasError(currentViewAbstract)
              ? Colors.red
              : null,
          childrenPadding: const EdgeInsets.all(30),
          subtitle: currentViewAbstract.getSubtitleHeaderText(context),
          title: TitleText(
            text: currentViewAbstract.getHeaderTextOnly(context),
            fontSize: 27,
            fontWeight: FontWeight.w400,
          ),
          leading: currentViewAbstract.getCardLeadingEditCard(context),
          children: [
            ...fields.map((e) => buildWidget(currentViewAbstract, e)).toList(),
          ],
        ),
        const SizedBox(height: 24.0)
      ],
    );
  }

  Widget buildWidget(ViewAbstract viewAbstract, String field) {
    dynamic fieldValue = viewAbstract.getFieldValue(field);
    if (fieldValue is ViewAbstract) {
      return buildViewAbstractMasterWidget(fieldValue, field);
    } else {
      return getControl(viewAbstract, field);
    }
  }

  Widget getControl(ViewAbstract viewAbstract, String field) {
    TextInputType? textInputType = viewAbstract.getTextInputType(field);
    if (kDebugMode) {
      print("$field =  $textInputType");
    }
    if (textInputType == null) getEditText(viewAbstract, field);
    if (textInputType == TextInputType.datetime) {
      return getDateTime(viewAbstract, field);
    } else {
      return getEditText(viewAbstract, field);
    }
  }

  Widget getDateTime(ViewAbstract viewAbstract, String field) {
    dynamic fieldValue = viewAbstract.getFieldValue(field);
    return Column(children: [
      FormBuilderDateTimePicker(
        name: viewAbstract.getTag(field),
        firstDate: DateTime(2020),
        lastDate: DateTime(2030),
        initialDate: viewAbstract.getDateTimeFromField(fieldValue),
        decoration: getDecoration(viewAbstract, field),
      ),
      getSpace()
    ]);
  }

  Widget getSpace() {
    return const SizedBox(height: 24.0);
  }

  InputDecoration getDecoration(ViewAbstract viewAbstract, String field) {
    return InputDecoration(
      border: const UnderlineInputBorder(),
      filled: true,
      icon: viewAbstract.getTextInputIcon(field),
      hintText: viewAbstract.getTextInputHint(context, field),
      labelText: viewAbstract.getTextInputLabel(context, field),
      prefixText: viewAbstract.getTextInputPrefix(context, field),
    );
  }

  Widget getEditText(ViewAbstract viewAbstract, String field) {
    return Column(
      children: [
        FormBuilderTextField(
            valueTransformer: (value) {
              return value?.trim();
            },
            name: viewAbstract.getTag(field),
            initialValue: viewAbstract.getFieldValue(field),
            maxLength: viewAbstract.getTextInputMaxLength(field),
            textCapitalization: viewAbstract.getTextInputCapitalization(field),
            decoration: getDecoration(viewAbstract, field),
            keyboardType: viewAbstract.getTextInputType(field),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            //TODO enabled: viewAbstract.getTextInputIsEnabled(widget.field),
            focusNode: _formValidationManager.getFocusNodeForField(
                viewAbstract.getTag(field), viewAbstract, field),
            validator: _formValidationManager.wrapValidator(
                viewAbstract.getTag(field), viewAbstract, field, (value) {
              return viewAbstract.getTextInputValidator(context, field, value);
            }),
            onSaved: (String? value) {
              print('onSave=   $value');
            },
            inputFormatters: viewAbstract.getTextInputFormatter(field)),
        getSpace()
      ],
    );
  }
}
//TODO typeAhed is like autocomplete