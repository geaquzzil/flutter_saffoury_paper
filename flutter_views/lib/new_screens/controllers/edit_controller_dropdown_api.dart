import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/controllers/ext.dart';

class EditControllerDropdownFromViewAbstract<T extends ViewAbstract>
    extends StatefulWidget {
  T viewAbstract;
  ViewAbstract parent;
  bool enabled;
  GlobalKey<FormBuilderState>? formKey;
  String field;
  EditControllerDropdownFromViewAbstract(
      {super.key,
      required this.parent,
      this.formKey,
      required this.enabled,
      required this.viewAbstract,
      required this.field});

  @override
  State<EditControllerDropdownFromViewAbstract<T>> createState() =>
      _EditControllerDropdownFromViewAbstractState<T>();
}

class _EditControllerDropdownFromViewAbstractState<T extends ViewAbstract>
    extends State<EditControllerDropdownFromViewAbstract<T>> {
  List<T?>? _list;
  Future<List<T?>?> getFuture() async {
    if (_list != null) return _list;
    _list = [null];
    _list!.addAll(await widget.viewAbstract.listApiReduceSizes(context: context)
        as List<T?>);
    // if (mounted) {
    //   setState(() {});
    // }
    return _list;
  }

  @override
  Widget build(BuildContext context) {
    List<T?> savedList = widget.viewAbstract
        .getLastReduseSize(widget.viewAbstract.getFieldToReduceSize())
        .cast();
    return Column(children: [
      if (savedList.isNotEmpty)
        getDropdownController(context, savedList)
      else
        FutureBuilder<List<T?>?>(
          future: getFuture(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return getDropdownController(context, snapshot.data as List<T?>);
            }
            return const CircularProgressIndicator();
          },
        ),
      // getSpace()
    ]);
  }

  int getEqualID() {
    dynamic val = widget.parent.getFieldValue(widget.field);
    if (val == null) {
      return -100;
    } else if (val is ViewAbstract) {
      return val.iD;
    } else {
      return -100;
    }
  }

  FormBuilderDropdown<T?> getDropdownController(
      BuildContext context, List<T?> list) {
    debugPrint("getDropdownController $list");
    return FormBuilderDropdown<T?>(
      isExpanded: true,
      enabled: widget.enabled,
      // valueTransformer: ,
      autovalidateMode: AutovalidateMode.always,
      onChanged: (obj) {
        if (obj == null) {
          widget.parent.setFieldValue(widget.field, obj);
        }
        widget.parent.onDropdownChanged(context, widget.field, obj,
            formKey: widget.formKey);
      },
      validator: ((value) => widget.parent
          .getTextInputValidatorCompose(context, widget.field)
          .call(value)),
      name: widget.parent.getTag(widget.field),
      initialValue:
          list.firstWhereOrNull((element) => element.iD == getEqualID()),

      onSaved: (newValue) {
        widget.parent.setFieldValue(widget.field, newValue);
        debugPrint('FormBuilderDropdown onSave=   $newValue');
      },

      decoration: getDecoration(context, widget.viewAbstract),
      // hint: Text(viewAbstract.getMainHeaderLabelTextOnly(context)),
      items: list
          .map((item) => DropdownMenuItem<T?>(
                value: item,
                child: Text(item == null
                    ? widget.viewAbstract.getTextInputHint(context) ?? ""
                    : item.getMainHeaderTextOnly(context)),
              ))
          .toList(),
    );
  }
}
