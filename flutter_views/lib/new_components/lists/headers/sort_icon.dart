// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/new_screens/controllers/controller_dropbox_list.dart';
import 'package:flutter_view_controller/new_screens/controllers/controller_dropbox_list_icon.dart';

class SortIcon extends StatefulWidget {
  ViewAbstract viewAbstract;
  SortFieldValue? initialValue;
  Function(SortFieldValue?)? onChange;
  SortIcon(
      {super.key,
      required this.viewAbstract,
      this.initialValue,
      this.onChange});

  @override
  State<SortIcon> createState() => _SortIconState();
}

class _SortIconState extends State<SortIcon> {
  SortFieldValue? _initialValue;
  late ViewAbstract _viewAbstract;

  List<DropdownStringListItem>? _generatedList;

  @override
  void initState() {
    _viewAbstract = widget.viewAbstract;
    _initialValue = widget.initialValue ?? _viewAbstract.getSortByInitialType();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SortIcon oldWidget) {
    if (_initialValue != widget.initialValue) {
      _initialValue = widget.initialValue;
    }
    if (_viewAbstract != widget.viewAbstract) {
      _viewAbstract = widget.viewAbstract;
      _initialValue =
          widget.initialValue ?? _viewAbstract.getSortByInitialType();
      _generatedList = null;
    }
    super.didUpdateWidget(oldWidget);
  }

  List<DropdownStringListItem> getSortTypeList() {
    return SortByType.values.map((o) {
      return getSortByTypeItem(o);
    }).toList();
  }

  DropdownStringListItem getSortByTypeItem(SortByType o) {
    return DropdownStringListItem(
      isRadio: true,
      label: o.getFieldLabelString(context, o),
      value: o,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownStringListItem> l = getSortTypeList();
    _generatedList ??= [
      ...l,
      DropdownStringListItem(label: "", isDivider: true),
      ..._viewAbstract.getMainFieldsIconsAndValues(context)
    ];

    return DropdownStringListControllerListenerByIcon(
        showSelectedValueBeside: true,
        icon: Icons.sort_by_alpha,
        initialValue:
            _initialValue?.getDropdownStringListItem(context, _viewAbstract),
        initialValueIfRadio: _initialValue == null
            ? null
            : l.firstWhereOrNull((o) =>
                o.label ==
                _initialValue?.type
                    .getFieldLabelString(context, _initialValue!.type)),
        hint: AppLocalizations.of(context)!.sortBy,
        list: _generatedList!,
        onSelected: (obj) {
          debugPrint("is selected ${obj}");
          if (obj is DropdownStringListItem) {
            widget.onChange?.call(SortFieldValue(
                type: SortByType.ASC, field: obj.value as String));
          }
          if (obj is DropdownStringListItemWithRadio) {
            widget.onChange?.call(SortFieldValue(
                type: obj.radio!.value as SortByType,
                field: obj.value as String));
          }
        });
  }
}
