import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/controllers/controller_dropbox_list.dart';
import 'package:flutter_view_controller/new_screens/controllers/controller_dropbox_list_icon.dart';
import 'package:flutter_view_controller/new_screens/controllers/ext.dart';
import 'package:skeletons/skeletons.dart';

class DropdownFromViewAbstractApi<T extends ViewAbstract>
    extends StatefulWidget {
  T viewAbstract;
  T? initialValue;
  bool byIcon;
  Function(T?)? onChanged;
  DropdownFromViewAbstractApi(
      {super.key,
      this.onChanged,
      this.byIcon = false,
      required this.viewAbstract,
      required this.initialValue});

  @override
  State<DropdownFromViewAbstractApi<T>> createState() =>
      _EditControllerDropdownFromViewAbstractState<T>();
}

class _EditControllerDropdownFromViewAbstractState<T extends ViewAbstract>
    extends State<DropdownFromViewAbstractApi<T>> {
  Future<List<T?>> getFuture() async {
    List<T?>? list = List.empty(growable: true);
    list = [null];
    list.addAll(await widget.viewAbstract.listApiReduceSizes(context: context) as List<T?>);
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<T?>?>(
      future: getFuture(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (widget.byIcon) {
            return DropdownStringListControllerListenerByIcon(
                onSelected: (object) {
                  widget.onChanged?.call(object?.value as T?);
                },
                initialValue: DropdownStringListItem(
                    value: widget.initialValue,
                    label:
                        widget.initialValue?.getMainHeaderTextOnly(context) ??
                            ""),
                icon: widget.viewAbstract.getMainIconData(),
                hint: widget.viewAbstract.getMainHeaderLabelTextOnly(context),
                list: widget.viewAbstract.generateListFromViewAbstract(
                    context, snapshot.data as List<T?>));
          } else {
            return getDropdownController(context, snapshot.data as List<T?>);
          }
        }
        if (widget.byIcon) {
          return const SizedBox(
              width: 15, height: 15, child: CircularProgressIndicator());
        }
        return SkeletonListTile(
          hasLeading: false,
          hasSubtitle: false,
          padding: const EdgeInsets.symmetric(
              horizontal: kDefaultPadding / 2, vertical: kDefaultPadding / 2),
        );
      },
    );
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
      items: list
          .map((item) => DropdownMenuItem<T?>(
                value: item,
                child: Text(
                  item == null
                      ? widget.viewAbstract.getTextInputHint(context) ?? ""
                      : item.getMainHeaderTextOnly(context),
                  style: item != null
                      ? Theme.of(context).textTheme.bodySmall
                      : Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Theme.of(context).disabledColor),
                ),
              ))
          .toList(),
    );
  }
}
