import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/edit/controllers/ext.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/edit_controllers_utils.dart';

class DropdownCustomListWithFormListener extends StatefulWidget {
  ViewAbstract viewAbstract;
  String field;
  GlobalKey<FormBuilderState>? formKey;
  Function(dynamic selectedObj) onSelected;
  DropdownCustomListWithFormListener(
      {super.key,
      required this.viewAbstract,
      required this.field,
      this.formKey,
      required this.onSelected});

  @override
  State<DropdownCustomListWithFormListener> createState() =>
      _DropdownCustomListWithFormListenerState();
}

class _DropdownCustomListWithFormListenerState
    extends State<DropdownCustomListWithFormListener> {
  late List<dynamic> list;
  late String _field;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _field = widget.field;
    list = widget.viewAbstract
        .getTextInputIsAutoCompleteCustomListMap(context)[_field]!;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant DropdownCustomListWithFormListener oldWidget) {
    list = widget.viewAbstract
        .getTextInputIsAutoCompleteCustomListMap(context)[_field]!;
    // if (_field != widget.field) {
    //   _field = widget.field;
    //   list = widget.viewAbstract
    //       .getTextInputIsAutoCompleteCustomListMap(context)[_field]!;
    // }
    super.didUpdateWidget(oldWidget);
  }

  void postFram(Function c) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      c.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    return wrapController(
        FormBuilderDropdown<dynamic>(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: (obj) {
            widget.viewAbstract.onDropdownChanged(context, _field, obj,
                formKey: widget.formKey);
            widget.viewAbstract.setFieldValue(_field, obj);
            debugPrint(
                'getControllerDropdownCustomList onChanged= field= ${_field} value=   $obj');
            widget.onSelected(obj);
          },
          onReset: () {
            debugPrint("getControllerDropdownCustomList onReset");
            debugPrint(
                "getControllerDropdownCustomList onReset list ${widget.viewAbstract.getTextInputIsAutoCompleteCustomListMap(context)[_field]!}");
            setState(() {
              list = widget.viewAbstract
                  .getTextInputIsAutoCompleteCustomListMap(context)[_field]!;
              //on reset list then updated initialValue not set this funcion to set the initalValue is selected
            
            });
          },
          validator:
              widget.viewAbstract.getTextInputValidatorCompose(context, _field),
          name: widget.viewAbstract.getTag(_field),
          // initialValue: list.firstWhereOrNull((p0) =>
          //     widget.viewAbstract.getFieldValue(_field, context: context) ==
          //     p0),
          initialValue:
              widget.viewAbstract.getFieldValue(_field, context: context),
          decoration: getDecorationIconLabel(context,
              label: widget.viewAbstract.getFieldLabel(context, _field),
              icon: widget.viewAbstract.getFieldIconDataNullAccepted(_field)),
          items: list
              .map((item) => DropdownMenuItem<dynamic>(
                    value: item,
                    child: Text(item == null
                        ? "${AppLocalizations.of(context)!.enter} ${widget.viewAbstract.getFieldLabel(context, _field)}"
                        : item.toString()),
                  ))
              .toList(),
        ),
        requiredSpace: true);
  }
}
