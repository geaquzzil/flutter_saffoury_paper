import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_inputs_validaters.dart'
    as v;

import '../../new_screens/controllers/ext.dart';

class EditableWidget extends StatefulWidget {
  ViewAbstract viewAbstract;
  void Function(ViewAbstract? viewAbstract)? onValidated;
  void Function(FocusNode? lastNode)? onFocusChange;
  EditableWidget(
      {super.key,
      required this.viewAbstract,
      this.onValidated,
      this.onFocusChange});

  @override
  State<EditableWidget> createState() => _EditableWidget();
}

class _EditableWidget extends State<EditableWidget> {
  late List<String> fields;
  // late Map<String, List<String>> fieldsGroups;
  late GlobalKey<FormBuilderState> _formKey;
  Map<String, TextEditingController> controllers = {};
  Map<String, FocusNode> focusNodes = {};
  FocusNode? _lastFocusNode;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint("didChangeDependencies _BaseEditPageState");
    if (_lastFocusNode != null) {
      debugPrint("didChangeDependencies _lastFocusNode");
      FocusScope.of(context).requestFocus(_lastFocusNode);
    }
  }

  @override
  void initState() {
    debugPrint("initState _BaseEditPageState");
    super.initState();
    _formKey = GlobalKey<FormBuilderState>();
    fields = widget.viewAbstract.getMainFieldsWithOutGroups(context);
    // fieldsGroups = widget.viewAbstract.getMainFieldsGroups(context);

    // debugPrint("initState $fieldsGroups");
  }

  @override
  void dispose() {
    controllers.forEach((key, value) {
      controllers[key]!.removeListener(() {
        widget.viewAbstract
            .onTextChangeListener(context, key, controllers[key]!.text);
        // modifieController(key);
      });
      controllers[key]!.dispose();
    });
    focusNodes.forEach((key, value) {
      value.dispose();
    });
    widget.viewAbstract.dispose();
    controllers.clear();
    focusNodes.clear();
    super.dispose();
  }

  void validate() {
    // FocusScope.of(context).unfocus();
    final validationSuccess =
        _formKey.currentState!.validate(focusOnInvalid: false);
    if (!validationSuccess) {
      _formKey.currentState!.save();
      debugPrint("! validationSuccess ");
      if (widget.onValidated != null) {
        widget.onValidated!(null);
      }
    }
    if (validationSuccess) {
      _formKey.currentState!.save();
      final formData = _formKey.currentState?.value;
      var newObject = widget.viewAbstract.copyWith(formData ?? {});
      debugPrint("validate $newObject");
      if (widget.onValidated != null) {
        widget.onValidated!(newObject);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: buildForm());
  }

  void modifieController(String field) {
    debugPrint("\n");
    controllers.forEach((key, value) {
      if (key != field) {
        // controllers[key]!.removeListener(() {
        //   // widget.viewAbstract
        //   //     .onTextChangeListener(context, key, controllers[key]!.text);
        //   // modifieController(key);
        // });
        // controllers[key]!.removeListener(() {});
        String v = getEditControllerText(
            widget.viewAbstract.getFieldValue(key, context: context));
        debugPrint("modifieController for key=>$key value => $v");
        controllers[key]!.value = TextEditingValue(
            selection:
                TextSelection(baseOffset: v.length, extentOffset: v.length),
            text: v);
        // controllers[key]!.text = v;
        // controllers[key]!.addListener(() {
        //   widget.viewAbstract
        //       .onTextChangeListener(context, key, controllers[key]!.text);
        //   modifieController(key);
        // });
      }
    });
  }

  FocusNode getFocusNode({required String field}) {
    if (focusNodes.containsKey(field)) {
      return focusNodes[field]!;
    }
    focusNodes[field] = FocusNode();
    return focusNodes[field]!;
  }

  TextEditingController getController(
      {required String field, required dynamic value}) {
    if (controllers.containsKey(field)) {
      return controllers[field]!;
    }
    value = getEditControllerText(value);
    controllers[field] = TextEditingController();
    controllers[field]!.text = value;
    controllers[field]!.addListener(() {
      widget.viewAbstract.onTextChangeListener(
          context, field, controllers[field]!.text,
          formKey: _formKey);
      // modifieController(field);
    });
    widget.viewAbstract.addTextFieldController(field, controllers[field]!);
    return controllers[field]!;
  }

  FormBuilder buildForm() {
    return FormBuilder(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: fields
              .where((element) =>
                  !widget.viewAbstract.isViewAbstract(element) &&
                  widget.viewAbstract.getInputType(element) ==
                      v.FormFieldControllerType.EDIT_TEXT)
              .map((e) => buildTextField(e))
              .toList(),
        ));
  }

  Widget buildTextField(String fieldName) {
    return Column(
      children: [
        Focus(
          // focusNode: getFocusNode(field: fieldName),
          onFocusChange: (value) {
            debugPrint("onFocusChange $value");
            if (value) {
              setState(() {
                _lastFocusNode = getFocusNode(field: fieldName);
                debugPrint("onFocusChange $fieldName $value");
              });
            }
          },
          child: FormBuilderTextField(
            focusNode: getFocusNode(field: fieldName),
            controller: getController(
                field: fieldName,
                value: widget.viewAbstract
                    .getFieldValue(fieldName, context: context)),
            valueTransformer: (value) {
              return value?.trim();
            },
            name: widget.viewAbstract.getTag(fieldName),
            maxLength: widget.viewAbstract.getTextInputMaxLength(fieldName),
            textCapitalization:
                widget.viewAbstract.getTextInputCapitalization(fieldName),
            decoration:
                getDecoration(context, widget.viewAbstract, field: fieldName),
            keyboardType: widget.viewAbstract.getTextInputType(fieldName),
            inputFormatters:
                widget.viewAbstract.getTextInputFormatter(fieldName),
            autovalidateMode: AutovalidateMode.always,
            validator: widget.viewAbstract
                .getTextInputValidatorCompose(context, fieldName),
            onSubmitted: (value) => debugPrint("onSubmitted"),
            onEditingComplete: () => debugPrint("onEditingComplete"),
            onChanged: (value) {
              // widget.viewAbstract.onTextChangeListener(context, fieldName, value);
              validate();
            },
            onSaved: (String? value) {
              widget.viewAbstract.setFieldValue(fieldName, value);
              debugPrint('EditControllerEditText onSave= $fieldName:$value');
              if (widget.viewAbstract.getFieldNameFromParent != null) {
                widget.viewAbstract.getParent?.setFieldValue(
                    widget.viewAbstract.getFieldNameFromParent ?? "",
                    widget.viewAbstract);
              }
            },
          ),
        ),
        getSpace()
      ],
    );
  }
}
