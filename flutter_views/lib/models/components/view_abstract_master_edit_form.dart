import 'package:flutter/material.dart';
import 'package:flutter_view_controller/components/title_text.dart';
import 'package:flutter_view_controller/models/components/sub_text_input.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/action_view_abstract_provider.dart';
import 'package:provider/provider.dart';

class SubViewAbstractEditForm extends StatefulWidget {
  String field;
  ViewAbstract parent;
  SubViewAbstractEditForm({Key? key, required this.parent, required this.field})
      : super(key: key);

  @override
  State<SubViewAbstractEditForm> createState() =>
      _SubViewAbstractEditFormState();
}

class _SubViewAbstractEditFormState extends State<SubViewAbstractEditForm> {
  late ViewAbstract currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = widget.parent.getFieldValue(widget.field);
  }

  @override
  Widget build(BuildContext context) {
    List<String> fields = currentValue.getFields();
    return Column(
      children: [
        ExpansionTile(
          childrenPadding: const EdgeInsets.all(30),
          subtitle: currentValue.getSubtitleHeaderText(context),
          title: TitleText(
            text: currentValue.getHeaderTextOnly(context),
            fontSize: 27,
            fontWeight: FontWeight.w400,
          ),
          children: [
            ...fields.map((e) => buildWidget(e)).toList(),
          ],
          leading: currentValue.getCardLeadingEditCard(context),
        ),
        const SizedBox(height: 24.0)
      ],
    );
  }

  Widget buildWidget(String field) {
    dynamic fieldValue = currentValue.getFieldValue(field);

    if (fieldValue is ViewAbstract) {
      return SubViewAbstractEditForm(parent: currentValue, field: field);
    } else {
      return SubEditTextField(parent: currentValue, field: field);
    }
  }
}
