import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/new_components/today_text.dart';
import 'package:flutter_view_controller/shared_components/search_field.dart';

import 'date_selector.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const TodayText(),
              const SizedBox(width: kDefaultPadding),
              Spacer(),
              Expanded(child: DateSelector()),
            ],
          ),
        ],
      ),
    );
  }
}
