import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/edit/controllers/ext.dart';

class DropdownFromViewAbstractApi<T extends ViewAbstract>
    extends StatefulWidget {
  T viewAbstract;
  T? initialValue;
  Function(T?)? onChanged;
  DropdownFromViewAbstractApi(
      {super.key,
      this.onChanged,
      required this.viewAbstract,
      required this.initialValue});

  @override
  State<DropdownFromViewAbstractApi<T>> createState() =>
      _EditControllerDropdownFromViewAbstractState<T>();
}

class _EditControllerDropdownFromViewAbstractState<T extends ViewAbstract>
    extends State<DropdownFromViewAbstractApi<T>> {
  List<T?>? _list;

  Future<List<T?>?> getFuture() async {
    if (_list != null) return _list;
    _list = [null];
    _list!.addAll(await widget.viewAbstract
            .listApiReduceSizes(widget.viewAbstract.getFieldToReduceSize())
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

  FormBuilderDropdown<T?> getDropdownController(
      BuildContext context, List<T?> list) {
    debugPrint("getDropdownController $list");
    return FormBuilderDropdown<T?>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: widget.onChanged,
      name: widget.viewAbstract.getListableKey(),
      initialValue: list
          .firstWhereOrNull((element) => element.iD == widget.initialValue?.iD),

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
