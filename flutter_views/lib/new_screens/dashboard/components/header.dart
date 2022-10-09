import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/shared_components/search_field.dart';
import 'package:flutter_view_controller/shared_components/today_text.dart';

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const TodayText(),
        const SizedBox(width: kSpacing),
        Expanded(child: SearchField()),
      ],
    );
  }
}
