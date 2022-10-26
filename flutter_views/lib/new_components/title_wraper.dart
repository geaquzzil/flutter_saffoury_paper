import 'package:flutter/material.dart';
import 'package:flutter_view_controller/components/title_text.dart';

class TitleWraper extends StatelessWidget {
  Widget child;
  String title;
  TitleWraper({Key? key, required this.title, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [buildTitle(context), Expanded(child: child)],
    );
  }

  Widget buildTitle(BuildContext context) {
    return TitleText(
      text: title,
    );
  }
}
