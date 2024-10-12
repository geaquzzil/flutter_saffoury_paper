import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/forms/nasted/custom_tile_expansion.dart';
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
        // autovalidateMode: AutovalidateMode.always,
        key: formKey,
        skipDisabled: true,
        onChanged: () {
          bool? res = formKey.currentState?.saveAndValidate(
              focusOnInvalid: false, autoScrollWhenFocusOnInvalid: false);

          debugPrint(
              "BaseEditFinal FormBuilder onChanged res $res onChanged${formKey.currentState?.value}");

          // formKey.currentState?.fields["status"]?.

          // onValidateForm(context);
        },
        child: wrapWithColumn(getFormContent(_viewAbstract)));
  }

  List<Widget> getFormContent(ViewAbstract viewAbstract,
      {ViewAbstract? parent, String? fieldNameFromParent}) {
    viewAbstract.onBeforeGenerateView(context, action: ServerActions.edit);
    viewAbstract.setParent(parent);
    viewAbstract.setFieldNameFromParent(fieldNameFromParent);
    var child = <Widget>[
      ...viewAbstract.getMainFields().map((e) {
        return checkToGetControllerWidget(context, viewAbstract, e);
      }),
    ];
    return child;
  }

  Widget wrapWithColumn(List<Widget> childs) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: childs,
    );
  }

  bool isChanged = false;
  Widget checkToGetControllerWidget(
      BuildContext context, ViewAbstract viewAbstract, String field) {
    dynamic fieldValue = viewAbstract.getFieldValue(field) ??
        viewAbstract.getMirrorNewInstance(field);

    bool enabled = viewAbstract.isFieldEnabled(field);

    if (viewAbstract.isViewAbstract(field)) {
      bool shouldWrap = viewAbstract.shouldWrapWithExpansionCardWhenChild();

      if (shouldWrap) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: kDefaultPadding * .25),
          child: ExpansionEdit(
            name: field,
            parentFormKey: formKey,
            viewAbstract: fieldValue,
            valueFromParent: viewAbstract.getFieldValue(field),
          ),
        );
      } else {
        List<Widget> childs = getFormContent(fieldValue,
            parent: viewAbstract, fieldNameFromParent: field);
        return NestedFormBuilder(
          name: field,
          parentFormKey: formKey,
          enabled: enabled,
          skipDisabled: !enabled,
          child: wrapWithColumn(childs),
        );
      }
    }
    return viewAbstract.getFormMainControllerWidget(
        context: context, field: field, formKey: formKey);
  }

  // TextEditingController getController(BuildContext context,
  //     {required String field,
  //     required dynamic value,
  //     bool isAutoCompleteVA = false}) {
  //   if (controllers.containsKey(field)) {
  //     // value = getEditControllerText(value);
  //     // controllers[field]!.text = value;
  //     // FocusScope.of(context).unfocus();
  //     // WidgetsBinding.instance
  //     //     .addPostFrameCallback((_) => controllers[field]!.clear());
  //     return controllers[field]!;
  //   }
  //   value = getEditControllerText(value);
  //   controllers[field] = TextEditingController();
  //   controllers[field]!.text = value;

  //   controllers[field]!.addListener(() {
  //     bool? validate = widget
  //         .formKey?.currentState!.fields[_viewAbstract.getTag(field)]
  //         ?.validate(focusOnInvalid: false);
  //     // formKey?.currentState!.fields[viewAbstract.getTag(field)]?.save();
  //     if (validate ?? false) {
  //       formKey?.currentState!.fields[_viewAbstract.getTag(field)]?.save();
  //     }
  //     debugPrint("onTextChangeListener field=> $field validate=$validate");
  //     _viewAbstract.setFieldValue(field, controllers[field]!.text);
  //     _viewAbstract.onTextChangeListener(
  //         context, field, controllers[field]!.text,
  //         formKey: formKey);

  //     if (_viewAbstract.getParnet != null) {
  //       _viewAbstract.getParnet!.onTextChangeListenerOnSubViewAbstract(
  //           context, _viewAbstract, _viewAbstract.getFieldNameFromParent!,
  //           parentformKey: widget.parentFormKey);
  //     }
  //     if (isAutoCompleteVA) {
  //       if (controllers[field]!.text ==
  //           getEditControllerText(_viewAbstract.getFieldValue(field))) {
  //         return;
  //       }
  //       _viewAbstract =
  //           _viewAbstract.copyWithSetNew(field, controllers[field]!.text);
  //       _viewAbstract.parent?.setFieldValue(field, _viewAbstract);
  //       //  refreshControllers(context);
  //       //removed
  //       // viewAbstractChangeProvider.change(_viewAbstract);
  //     }

  //     // }
  //     // modifieController(field);
  //   });
  //   // FocusScope.of(context).unfocus();
  //   // WidgetsBinding.instance
  //   //     .addPostFrameCallback((_) => controllers[field]!.clear());

  //   _viewAbstract.addTextFieldController(field, controllers[field]!);
  //   return controllers[field]!;
  // }
}
