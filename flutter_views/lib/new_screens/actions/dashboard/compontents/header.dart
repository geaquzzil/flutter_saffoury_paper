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
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../models/apis/date_object.dart';
import '../base_dashboard_screen_page.dart';
import 'date_selector.dart';

class DashboardHeader extends StatelessWidget {
  final CurrentScreenSize current_screen_size;
  // DateTime? focuseDate;
  DateObject date;
  Function(DateObject? date_object) onSelectedDate;
  DashboardHeader(
      {Key? key,
      required this.current_screen_size,
      required this.date,
      required this.onSelectedDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final popUpSize = findPopupSizeSquare(context);
    return Container(
      color: Theme.of(context).colorScheme.background,
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TodayText(
                dateObject: date,
              ),
              const Spacer(),
              if (isLargeScreenFromScreenSize(current_screen_size))
                CustomPopupMenu(
                    barrierColor: kIsWeb ? Colors.black54 : Colors.black26,
                    menuBuilder: () => SizedBox(
                          width: popUpSize.width,
                          height: popUpSize.height,
                          child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(kDefualtClipRect),
                              child: Scaffold(
                                body: TableCalendar(
                                  // calendarStyle:CalendarStyle().. ,
                                  // eventLoader: (day) {
                                  //   if (day.weekday == DateTime.monday) {
                                  //     return [Event('Cyclic event')];
                                  //   }

                                  //   return [];
                                  // },
                                  calendarBuilders: CalendarBuilders(
                                    dowBuilder: (context, day) {
                                      if (day.weekday == DateTime.saturday) {
                                        final text = DateFormat.E().format(day);

                                        return Center(
                                          child: Text(
                                            text,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  rangeStartDay: date.from.toDateTimeOnlyDate(),
                                  rangeEndDay: date.to.toDateTimeOnlyDate(),
                                  rangeSelectionMode:
                                      RangeSelectionMode.toggledOn,
                                  selectedDayPredicate: (day) {
                                    return isSameDay(
                                        date.from.toDateTimeOnlyDate(), day);
                                  },
                                  onRangeSelected: (start, end, focuseDate) {
                                    date = DateObject.initFromDateTime(
                                        start ?? DateTime.now(),
                                        toDate: end);
                                    onSelectedDate.call(date);
                                    debugPrint("selectDateChanged ${date}");
                                  },
                                  locale: 'en-US',
                                  firstDay: DateTime.utc(2023, 10, 16),
                                  lastDay: DateTime.utc(2030, 3, 14),
                                  focusedDay: date.from.toDateTimeOnlyDate(),
                                  onDaySelected: (d, d1) {
                                    date = DateObject.initFromDateTime(d);
                                    // onSelectedDate.call(date);
                                    // debugPrint(
                                    //     "selectDateChanged ${selectDateChanged.value}");
                                  },
                                ),
                              )),
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
