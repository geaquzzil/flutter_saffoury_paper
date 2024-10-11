import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/controllers/ext.dart';
import 'package:flutter_view_controller/new_screens/forms/nasted/nasted_form_builder.dart';

class BaseEditFinal extends StatefulWidget {
  final ViewAbstract viewAbstract;
  const BaseEditFinal({super.key, required this.viewAbstract});

  @override
  State<BaseEditFinal> createState() => _BaseEditFinalState();
}

class _BaseEditFinalState extends State<BaseEditFinal> {
  late ViewAbstract _viewAbstract;
  GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  late List<String> _fields;

  void init() {
    _fields = _viewAbstract.getMainFields(context: context).toList();
  }

  @override
  void initState() {
    _viewAbstract = widget.viewAbstract;
    init();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant BaseEditFinal oldWidget) {
    if (widget.viewAbstract != oldWidget.viewAbstract) {
      debugPrint("didUpdateWidget BaseEditFinal");
      _viewAbstract = widget.viewAbstract;
      formKey.currentState?.reset();
      init();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Map<String, dynamic> getInitialData() {
    return _viewAbstract.toJsonViewAbstract();
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
        initialValue: getInitialData(),
        autovalidateMode: AutovalidateMode.always,
        key: formKey,
        onChanged: () {
          bool? res = formKey.currentState?.saveAndValidate(
              focusOnInvalid: false, autoScrollWhenFocusOnInvalid: false);

          debugPrint(
              "BaseEditFinal FormBuilder onChanged res $res onChanged${formKey.currentState?.value}");

          // formKey.currentState?.fields["status"]?.

          // onValidateForm(context);
        },
        child: getFormContent(_viewAbstract));
  }

  Widget getFormContent(ViewAbstract viewAbstract) {
    var child = <Widget>[
      // const SizedBox(height: kDefaultPadding),
      ...viewAbstract
          .getMainFields()
          .map((e) => checkToGetControllerWidget(context, viewAbstract, e)),
    ];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: child,
    );
  }

  bool isChanged = false;
  Widget checkToGetControllerWidget(
      BuildContext context, ViewAbstract viewAbstract, String field) {
    dynamic fieldValue = viewAbstract.getFieldValue(field) ??
        viewAbstract.getMirrorNewInstance(field);

    bool enabled = viewAbstract.isFieldEnabled(field);
    
    if (viewAbstract.isViewAbstract(field)) {
      return Padding(
        padding: const EdgeInsets.all(30),
        child: NestedFormBuilder(
          name: field,
          parentFormKey: formKey,
          child: getFormContent(fieldValue),
        ),
      );
    }
    return FormBuilderTextField(
      // onTap: () => controller.selection = TextSelection(
      //     baseOffset: 0, extentOffset: controller.value.text.length),
      onSubmitted: (value) =>
          debugPrint("getControllerEditText field $field value $value"),
      // controller: controller,
      enabled: enabled,
      valueTransformer: (value) {
        // viewAbstract.getFieldValueCheckTypeChangeToCurrencyFormat(context,field)
        return value?.toString().trim();
      },
      onChanged: (value) {
        debugPrint("onChange es $field:$value");
        if (!isChanged) {
          var d = formKey.currentState?.fields["comments"];
          debugPrint("onChange es ddd $d");
          // d?.didChange("300");
          // d?.reset();
          isChanged = true;
        }
      },

      name: viewAbstract.getTag(field),
      maxLength: viewAbstract.getTextInputMaxLength(field),
      textCapitalization: viewAbstract.getTextInputCapitalization(field),
      decoration: getDecoration(
        context,
        viewAbstract,
        field: field,
      ),
      keyboardType: viewAbstract.getTextInputType(field),
      inputFormatters: viewAbstract.getTextInputFormatter(field),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (va) => viewAbstract
          .getTextInputValidatorCompose<String?>(context, field)
          .call(va),
      onSaved: (String? value) {
        // viewAbstract.setFieldValue(field, value);
        // debugPrint(
        //     'getControllerEditText onSave= $field:$value textController:${controller.text}');
        // if (viewAbstract.getFieldNameFromParent != null) {
        //   viewAbstract.getParnet?.setFieldValue(
        //       viewAbstract.getFieldNameFromParent ?? "", viewAbstract);
        // }
      },
    );
  }
}
