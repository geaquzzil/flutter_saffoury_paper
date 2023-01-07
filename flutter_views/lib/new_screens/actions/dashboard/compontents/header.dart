import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/new_components/today_text.dart';
import 'package:flutter_view_controller/shared_components/search_field.dart';

import '../../../../models/apis/date_object.dart';
import '../base_dashboard_screen_page.dart';
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
              ValueListenableBuilder<DateObject?>(
                  valueListenable: selectDateChanged,
                  builder: ((context, value, child) => TodayText(
                        dateObject: value,
                      ))),
              Spacer(),
              DateSelector(),
            ],
          ),
        ],
      ),
    );
  }
}
