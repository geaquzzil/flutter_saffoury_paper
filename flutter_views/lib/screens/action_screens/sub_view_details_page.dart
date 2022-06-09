import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

class SubDetailsView extends StatefulWidget {
  String filedLabel;
  dynamic fieldValue;
  ViewAbstract parent;
  SubDetailsView(
      {Key? key,
      required this.parent,
      required this.filedLabel,
      required this.fieldValue})
      : super(key: key);

  @override
  State<SubDetailsView> createState() => _SubDetailsViewState();
}

class _SubDetailsViewState extends State<SubDetailsView> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
