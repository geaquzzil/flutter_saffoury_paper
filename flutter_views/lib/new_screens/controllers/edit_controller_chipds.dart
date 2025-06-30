import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/controllers/ext.dart';

class EditControllerChipsFromViewAbstract<T extends ViewAbstract>
    extends StatefulWidget {
  T viewAbstract;
  ViewAbstract parent;
  String field;
  bool enabled;
  EditControllerChipsFromViewAbstract(
      {super.key,
      required this.parent,
      required this.enabled,
      required this.viewAbstract,
      required this.field});

  @override
  State<EditControllerChipsFromViewAbstract<T>> createState() =>
      _EditControllerChipsFromViewAbstract<T>();
}

class _EditControllerChipsFromViewAbstract<T extends ViewAbstract>
    extends State<EditControllerChipsFromViewAbstract<T>> {
  List<T?>? _list;
  Future<List<T?>?> getFuture() async {
    if (_list != null) return _list;
    _list = await widget.viewAbstract.listCall(context: context) as List<T?>;
    if (mounted) {
      setState(() {});
    }
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
      getSpace()
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

  FormBuilderFilterChip<T?> getDropdownController(
      BuildContext context, List<T?> list) {
    List<T?>? init;
    try {
      List<T> initialValue = (widget.parent
          .getMultiChipInitalValue(context, widget.field) as List<T>);

      init = list
          .where((element) =>
              initialValue.firstWhereOrNull((s) => s.iD == element?.iD) != null)
          .toList();
    } catch (e) {
      debugPrint("EditControllerChipsFromViewAbstract error=> $e");
    }

    debugPrint("EditControllerChipsFromViewAbstract $init");
    return FormBuilderFilterChip<T?>(
      direction: Axis.horizontal,
      spacing: kDefaultPadding,
      enabled: widget.enabled,
      // valueTransformer: ,
      autovalidateMode: AutovalidateMode.disabled,
      // labelPadding: EdgeInsets.all(5),
      // padding: EdgeInsets.all(5),
      initialValue: init,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onChanged: (obj) {
        widget.parent.onMultiChipSelected(context, widget.field, obj);
      },
      validator: (value) {
        if (value == null) {
          return AppLocalizations.of(context)!.errFieldNotSelected(
              widget.viewAbstract.getMainHeaderLabelTextOnly(context));
        } else {
          if (value.isEmpty) {
            return AppLocalizations.of(context)!.errFieldNotSelected(
                widget.viewAbstract.getMainHeaderLabelTextOnly(context));
          }
        }
        return null;
      },
      name: widget.parent.getTag(widget.field),
      onSaved: (newValue) {
        try {
          widget.parent.onMultiChipSaved(context, widget.field, newValue);
        } catch (e) {
          debugPrint("EditControllerChipsFromViewAbstract  error =>$e");
        }
      },

      decoration: InputDecoration(
        border: null,
        filled: false,

        // errorText: "err",
        icon: widget.viewAbstract.getIcon(),
        // iconColor: context
        //         .watch<ErrorFieldsProvider>()
        //         .hasErrorField(viewAbstract, field)
        //     ? Theme.of(context).colorScheme.error
        //     : null,
        hintText: widget.viewAbstract.getTextInputHint(context),
        // labelText: viewAbstract.getMainHeaderLabelTextOnly(context),
      ),
      // hint: Text(viewAbstract.getMainHeaderLabelTextOnly(context)),
      options: list
          .map((item) => FormBuilderChipOption<T?>(
                value: item,
                child: Text(
                  item == null
                      ? widget.viewAbstract.getTextInputHint(context) ?? ""
                      : item.getMainHeaderTextOnly(context),
                ),
              ))
          .toList(),
    );
  }
}
