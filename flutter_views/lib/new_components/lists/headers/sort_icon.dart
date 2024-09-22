// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/new_screens/controllers/controller_dropbox_enum_icon.dart';
import 'package:flutter_view_controller/new_screens/controllers/controller_dropbox_list.dart';
import 'package:flutter_view_controller/new_screens/controllers/controller_dropbox_list_icon.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class SortFieldValue {
  String? field;
  SortByType? type;

  SortFieldValue({
    this.field,
    this.type,
  });

  Map<String, String>? getMap() {
    return field == null || type == null ? null : {type!.name: field!};
  }

  DropdownStringListItem? getDropdownStringListItem(
      BuildContext context, ViewAbstract parent) {
    return field == null
        ? null
        : DropdownStringListItem(
            label: parent.getFieldLabel(context, field!),
            icon: parent.getFieldIconData(field!),
            value: field);
  }
}

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

  String? field;
  SortByType? type;
  void setVariables() {
    type = _initialValue?.type ?? _viewAbstract.getSortByInitialType();
    field = _initialValue?.field ?? _viewAbstract.getSortByInitialFieldName();
  }

  @override
  void initState() {
    _initialValue = widget.initialValue;
    _viewAbstract = widget.viewAbstract;
    setVariables();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SortIcon oldWidget) {
    if (_initialValue != widget.initialValue) {
      _initialValue = widget.initialValue;
      setVariables();
    }
    if (_viewAbstract != widget.viewAbstract) {
      _viewAbstract = widget.viewAbstract;
      _initialValue = widget.initialValue;
      _generatedList = null;
      setVariables();
    }
    super.didUpdateWidget(oldWidget);
  }

  SortFieldValue? getValue() {
    return SortFieldValue(field: field, type: type);
  }

  List<DropdownStringListItem> getSortTypeList() {
    return SortByType.values.map((o) {
      return DropdownStringListItem(
        label: o.getFieldLabelString(context, o),
        value: o,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    _generatedList ??= [
      ...getSortTypeList(),
      DropdownStringListItem(label: "", isDivider: true),
      ..._viewAbstract.getMainFieldsIconsAndValues(context)!
    ];

    return DropdownStringListControllerListenerByIcon(
        showSelectedValueBeside: true,
        icon: Icons.sort_by_alpha,
        initialValue:
            _initialValue?.getDropdownStringListItem(context, _viewAbstract),
        hint: AppLocalizations.of(context)!.sortBy,
        list: _generatedList!,
        onSelected: (obj) {
          debugPrint("is selected ${obj.runtimeType}");
          field = obj?.value.toString();
          widget.onChange?.call(getValue());
          // if (obj == null) {
          //   removeFilterableSelected(context, widget.viewAbstract);
          // } else {
          //   listProvider.clear(findCustomKey());
          //   addFilterableSortField(
          //       context, obj.value.toString(), obj.label);
          // }
          // notifyListApi(context);
          // debugPrint("is selected $obj");
        });
    return Row(
      children: [
        DropdownStringListControllerListenerByIcon(
            showSelectedValueBeside: true,
            icon: Icons.sort_by_alpha,
            initialValue: _initialValue?.getDropdownStringListItem(
                context, _viewAbstract),
            hint: AppLocalizations.of(context)!.sortBy,
            list: widget.viewAbstract.getMainFieldsIconsAndValues(context),
            onSelected: (obj) {
              debugPrint("is selected ${obj.runtimeType}");
              field = obj?.value.toString();
              widget.onChange?.call(getValue());
              // if (obj == null) {
              //   removeFilterableSelected(context, widget.viewAbstract);
              // } else {
              //   listProvider.clear(findCustomKey());
              //   addFilterableSortField(
              //       context, obj.value.toString(), obj.label);
              // }
              // notifyListApi(context);
              // debugPrint("is selected $obj");
            }),
        DropdownEnumControllerListenerByIcon<SortByType>(
          viewAbstractEnum: SortByType.ASC,
          initialValue: _initialValue?.type,
          showSelectedValueBeside: true,
          onSelected: (object) {
            type = object;
            widget.onChange?.call(getValue());

            // addFilterableSort(context, object as SortByType);
            // notifyListApi(context);
          },
        ),
        const Spacer(),
      ],
    );
  }
}
