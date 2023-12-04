import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
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

  @override
  void initState() {
    list = widget.viewAbstract
        .getTextInputIsAutoCompleteCustomListMap(context)[widget.field]!;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    list = widget.viewAbstract
        .getTextInputIsAutoCompleteCustomListMap(context)[widget.field]!;
  }

  @override
  Widget build(BuildContext context) {
    list = widget.viewAbstract
        .getTextInputIsAutoCompleteCustomListMap(context)[widget.field]!;
    return wrapController(
        FormBuilderDropdown<dynamic>(
          autovalidateMode: AutovalidateMode.always,
          onChanged: (obj) {
            widget.viewAbstract.onDropdownChanged(context, widget.field, obj,
                formKey: widget.formKey);
            widget.viewAbstract.setFieldValue(widget.field, obj);
            debugPrint(
                'getControllerDropdownCustomList onChanged= field= ${widget.field} value=   $obj');
            widget.onSelected(obj);
          },
          onReset: () {
            debugPrint("getControllerDropdownCustomList onReset");
            debugPrint(
                "getControllerDropdownCustomList onReset list ${widget.viewAbstract.getTextInputIsAutoCompleteCustomListMap(context)[widget.field]!}");
            setState(() {
              list = widget.viewAbstract
                  .getTextInputIsAutoCompleteCustomListMap(
                      context)[widget.field]!;
            });
          },
          validator: widget.viewAbstract
              .getTextInputValidatorCompose(context, widget.field),
          name: widget.viewAbstract.getTag(widget.field),
          initialValue: list.firstWhereOrNull((p0) =>
              widget.viewAbstract
                  .getFieldValue(widget.field, context: context) ==
              p0),
          decoration: getDecorationIconLabel(context,
              label: widget.viewAbstract.getFieldLabel(context, widget.field),
              icon: widget.viewAbstract
                  .getFieldIconDataNullAccepted(widget.field)),
          items: list
              .map((item) => DropdownMenuItem<dynamic>(
                    value: item,
                    child: Text(item == null
                        ? "${AppLocalizations.of(context)!.enter} ${widget.viewAbstract.getFieldLabel(context, widget.field)}"
                        : item.toString()),
                  ))
              .toList(),
        ),
        requiredSpace: true);
  }
}
