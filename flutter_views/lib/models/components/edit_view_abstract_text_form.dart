import 'package:flutter/material.dart';
import 'package:flutter_view_controller/components/title_text.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/action_view_abstract_provider.dart';
import 'package:provider/provider.dart';

class SubViewAbstractEditForm extends StatefulWidget {
  String field;
  SubViewAbstractEditForm({Key? key, required this.field}) : super(key: key);

  @override
  State<SubViewAbstractEditForm> createState() =>
      _SubViewAbstractEditFormState();
}

class _SubViewAbstractEditFormState extends State<SubViewAbstractEditForm> {
  late ViewAbstract parentViewAbstract;
  late ViewAbstract currentValue;

  @override
  void initState() {
    super.initState();
    parentViewAbstract = context.read<ActionViewAbstractProvider>().getObject;
    currentValue = parentViewAbstract.getFieldValue(widget.field);
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: TitleText(
        text: currentValue.getHeaderTextOnly(context),
        fontSize: 27,
        fontWeight: FontWeight.w400,
      ),
      children: [],
    );
  }
}
