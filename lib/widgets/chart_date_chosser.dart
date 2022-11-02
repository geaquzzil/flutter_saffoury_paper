import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/new_components/edit_listeners/controller_dropbox_enum.dart';

class ChartDateChooser<T extends ViewAbstractEnum> extends StatefulWidget {
  Widget Function() onSelected;
  ChartDateChooser({Key? key,required this.onSelected}) : super(key: key);

  @override
  State<ChartDateChooser> createState() => _ChartDateChooserState();
}

class _ChartDateChooserState extends State<ChartDateChooser> {
  @override
  Widget build(BuildContext context) {
    
    return Container();
  }
}
