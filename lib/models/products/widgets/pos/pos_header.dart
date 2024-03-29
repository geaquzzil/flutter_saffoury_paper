import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/new_components/today_text.dart';
import 'package:flutter_view_controller/shared_components/search_field.dart';

class PosHeader extends StatelessWidget {
  const PosHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: SearchField(onSearch: (value) {})),
         TodayText(),
        const SizedBox(width: kSpacing),
        IconButton(onPressed: () {}, icon: Icon(Icons.info)),
        const SizedBox(width: kSpacing),
        IconButton(onPressed: () {}, icon: Icon(Icons.camera_alt))
      ],
    );
  }
}
