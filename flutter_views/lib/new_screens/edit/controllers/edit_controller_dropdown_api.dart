import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/new_screens/edit/controllers/ext.dart';

class EditControllerDropdownFromViewAbstract<T extends ViewAbstract>
    extends StatefulWidget {
  T viewAbstract;
  ViewAbstract parent;
  String field;
  EditControllerDropdownFromViewAbstract(
      {Key? key,
      required this.parent,
      required this.viewAbstract,
      required this.field})
      : super(key: key);

  @override
  State<EditControllerDropdownFromViewAbstract<T>> createState() =>
      _EditControllerDropdownFromViewAbstractState<T>();
}

class _EditControllerDropdownFromViewAbstractState<T extends ViewAbstract>
    extends State<EditControllerDropdownFromViewAbstract<T>> {
  List<dynamic>? _list;
  getFuture() async {
    if (_list != null) return _list;
    _list = await widget.viewAbstract
        .listApiReduceSizes(widget.viewAbstract.getFieldToReduceSize());
    setState(() {});
    return _list;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      FutureBuilder<List<dynamic>?>(
        future: getFuture(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return getDropdownController(
                context, snapshot.data as List<T> ?? []);
          }
          return CircularProgressIndicator();
        },
      ),
      getSpace()
    ]);
  }

  FormBuilderDropdown<T?> getDropdownController(
      BuildContext context, List<T?> list) {
    list.insert(0, null);
    return FormBuilderDropdown<T?>(
      onChanged: (obj) =>
          widget.parent.onDropdownChanged(context, widget.field, obj),
      validator:
          widget.parent.getTextInputValidatorCompose(context, widget.field),
      name: widget.parent.getTag(widget.field),
      initialValue: widget.parent.getFieldValue(widget.field),
      onSaved: (newValue) {
        widget.parent.setFieldValue(widget.field, newValue);
        debugPrint('FormBuilderDropdown onSave=   $newValue');
      },
      decoration: getDecoration(context, widget.viewAbstract),
      // hint: Text(viewAbstract.getMainHeaderLabelTextOnly(context)),
      items: list
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item == null
                    ? widget.viewAbstract.getTextInputHint(context) ?? ""
                    : item.getMainHeaderTextOnly(context)),
              ))
          .toList(),
    );
  }
}
