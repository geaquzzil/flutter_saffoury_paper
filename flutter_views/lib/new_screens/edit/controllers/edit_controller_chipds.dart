import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/new_screens/edit/controllers/ext.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class EditControllerChipsFromViewAbstract<T extends ViewAbstract>
    extends StatefulWidget {
  T viewAbstract;
  ViewAbstract parent;
  String field;
  EditControllerChipsFromViewAbstract(
      {Key? key,
      required this.parent,
      required this.viewAbstract,
      required this.field})
      : super(key: key);

  @override
  State<EditControllerChipsFromViewAbstract<T>> createState() =>
      _EditControllerChipsFromViewAbstract<T>();
}

class _EditControllerChipsFromViewAbstract<T extends ViewAbstract>
    extends State<EditControllerChipsFromViewAbstract<T>> {
  List<T?>? _list;
  Future<List<T?>?> getFuture() async {
    if (_list != null) return _list;
    _list = await widget.viewAbstract
            .listApiReduceSizes(widget.viewAbstract.getFieldToReduceSize())
        as List<T?>;
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
            return CircularProgressIndicator();
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

      decoration: getDecoration(context, widget.viewAbstract),
      // hint: Text(viewAbstract.getMainHeaderLabelTextOnly(context)),
      options: list
          .map((item) => FormBuilderChipOption<T?>(
                value: item,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: Text(item == null
                      ? widget.viewAbstract.getTextInputHint(context) ?? ""
                      : item.getMainHeaderTextOnly(context)),
                ),
              ))
          .toList(),
    );
  }
}
