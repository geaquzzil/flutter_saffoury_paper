import 'package:flutter/material.dart';
import 'package:flutter_view_controller/components/title_text.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/edit/controllers/edit_controller_master.dart';
import 'package:flutter_view_controller/new_screens/edit/sub_viewabstract/components/sub_edit_viewabstract_header.dart';
import 'package:flutter_view_controller/new_screens/edit/sub_viewabstract/components/sub_edit_viewabstract_trailing.dart';
import 'package:flutter_view_controller/providers/actions/edits/edit_error_list_provider.dart';
import 'package:flutter_view_controller/providers/actions/edits/sub_edit_viewabstract_provider.dart';
import 'package:provider/provider.dart';

class EditSubViewAbstractWidget extends StatefulWidget {
  ViewAbstract parent;
  String field;
  EditSubViewAbstractWidget(
      {Key? key, required this.parent, required this.field})
      : super(key: key);

  @override
  State<EditSubViewAbstractWidget> createState() =>
      _EditSubViewAbstractWidgetState();
}

class _EditSubViewAbstractWidgetState extends State<EditSubViewAbstractWidget> {
  late List<String> fields;
  bool isFirstRun = true;
  @override
  void initState() {
    super.initState();
    fields = widget.parent.getFields();
    Provider.of<EditSubsViewAbstractControllerProvider>(context, listen: false)
        .add(
            widget.field,
            widget.parent,
            widget.parent
                .isNullableAlreadyFromParentCheck(context, widget.field));
  }

  // Color? getColor(BuildContext context) {
  //   return context
  //           .watch<ErrorFieldsProvider>()
  //           .formValidationManager
  //           .hasError(widget.parent)
  //       ? Colors.red
  //       : null;
  // }

  @override
  Widget build(BuildContext context) {
    return EditSubViewAbstractHeader(
      viewAbstract: widget.parent,
      field: widget.field,
    );
    return ExpansionTile(
      key: PageStorageKey("${DateTime.now().millisecondsSinceEpoch}"),
      maintainState: true,

      initiallyExpanded: context
              .watch<EditSubsViewAbstractControllerProvider>()
              .getIsNullable(widget.field) &&
          isFirstRun,
      onExpansionChanged: (expanded) {
        isFirstRun = false;
      },
      // collapsedIconColor: getColor(context),
      // collapsedTextColor: getColor(context),
      // iconColor: getColor(context),
      // textColor: getColor(context),
      childrenPadding: const EdgeInsets.all(30),
      subtitle: widget.parent.getSubtitleHeaderText(context),
      title: TitleText(
        text: widget.parent.getHeaderTextOnly(context),
        fontSize: 27,
        fontWeight: FontWeight.w400,
      ),
      trailing: EditSubViewAbstractTrailingWidget(
          view_abstract: widget.parent, field: widget.field),

      children: [
        ...fields.map((e) => buildWidget(e)).toList(),
      ],
    );
  }

  Widget buildWidget(String field) {
    dynamic fieldValue = widget.parent.getFieldValue(field);
    if (fieldValue is ViewAbstract) {
      fieldValue.setParent(widget.parent);
      fieldValue.setFieldNameFromParent(field);
      // return Text("FDFD");
      return EditSubViewAbstractWidget(parent: fieldValue, field: field);
    } else {
      return EditControllerMasterWidget(
          viewAbstract: widget.parent, field: field);
    }
  }
}
