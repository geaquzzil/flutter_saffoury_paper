import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

class EditPage extends StatefulWidget {
  ViewAbstract viewAbstract;
  EditPage({super.key, required this.viewAbstract});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
