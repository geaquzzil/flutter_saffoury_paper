import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/new_components/rounded_icon_button_network.dart';
import 'package:flutter_view_controller/new_components/today_text.dart';
import 'package:flutter_view_controller/new_screens/base_page.dart';
import 'package:flutter_view_controller/shared_components/search_field.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../models/apis/date_object.dart';
import '../base_dashboard_screen_page.dart';
import 'date_selector.dart';

class DashboardHeader extends StatelessWidget {
  final CurrentScreenSize current_screen_size;
  const DashboardHeader({super.key, required this.current_screen_size});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
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
              const Spacer(),
              if (isLargeScreenFromScreenSize(current_screen_size))
                CustomPopupMenu(
                    barrierColor: kIsWeb ? Colors.black54 : Colors.black26,
                    menuBuilder: () => SizedBox(
                          width: 400,
                          height: 400,
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(kDefualtClipRect),
                            child: Scaffold(
                                body: ValueListenableBuilder<DateObject?>(
                              valueListenable: selectDateChanged,
                              builder: (context, value, child) => TableCalendar(
                                firstDay: DateTime.utc(2023, 10, 16),
                                lastDay: DateTime.utc(2030, 3, 14),
                                focusedDay:
                                    value?.from.toDateTime() ?? "".toDateTime(),
                                onDaySelected: (d, d1) {
                                  selectDateChanged.value =
                                      DateObject.initFromDateTime(d);
                                },
                              ),
                            )),
                          ),
                        ),
                    pressType: PressType.singleClick,
                    arrowColor: kIsWeb
                        ? Theme.of(context).scaffoldBackgroundColor
                        : const Color(0xFF4C4C4C),
                    // controller: _controller,
                    child: Icon(Icons.date_range_outlined))
              else
                DateSelector(),
            ],
          ),
        ],
      ),
    );
  }
}
