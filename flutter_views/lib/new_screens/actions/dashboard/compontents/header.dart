// ignore_for_file: non_constant_identifier_names

import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/today_text.dart';
import 'package:flutter_view_controller/new_screens/base_page.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../models/apis/date_object.dart';
import 'date_selector.dart';

class DashboardHeader extends StatefulWidget {
  final CurrentScreenSize current_screen_size;
  ViewAbstract? object;
  // DateTime? focuseDate;
  DateObject date;
  Function(DateObject? date_object) onSelectedDate;
  DashboardHeader(
      {super.key,
      required this.current_screen_size,
      required this.date,
      this.object,
      required this.onSelectedDate});

  @override
  State<DashboardHeader> createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<DashboardHeader> {
  late DateObject date;
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOn; // Can be toggled on/off by longpressing a date

  final CustomPopupMenuController _controller = CustomPopupMenuController();
  @override
  void initState() {
    date = widget.date;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final popUpSize = findPopupSizeSquare(context);
    return Container(
      color: Theme.of(context).colorScheme.surface,
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
              if (widget.object?.isPrintableMaster() == true)
                IconButton(
                    onPressed: () {
                      widget.object?.printPage(context);
                    },
                    icon: const Icon(Icons.print)),
              if (isLargeScreenFromScreenSize(widget.current_screen_size))
                CustomPopupMenu(
                    menuOnChange: (b) {
                      if (!b) {
                        // debugPrint("Please select Soso ");
                        widget.onSelectedDate(date);
                      }
                    },
                    barrierColor: kIsWeb ? Colors.black54 : Colors.black26,
                    menuBuilder: () => SizedBox(
                          width: popUpSize.width,
                          height: popUpSize.height,
                          child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(kDefualtClipRect),
                              child: Scaffold(
                                body: StatefulBuilder(
                                  builder: (c, setState) => TableCalendar(
                                    // headerVisible: false,
                                    // holidayPredicate: (day) {
                                    //   // Every 20th day of the month will be treated as a holiday
                                    //   return day.day % 8 == 0;
                                    // },

                                    rangeSelectionMode: _rangeSelectionMode,
                                    onPageChanged: (f) => _focusedDay = f,
                                    onFormatChanged: (format) {
                                      if (_calendarFormat != format) {
                                        setState(() {
                                          _calendarFormat = format;
                                        });
                                      }
                                    },
                                    calendarBuilders: CalendarBuilders(
                                      dowBuilder: (context, day) {
                                        if (day.weekday == DateTime.saturday) {
                                          final text =
                                              DateFormat.E().format(day);

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
                                        return null;
                                      },
                                    ),
                                    rangeStartDay:
                                        date.from.toDateTimeOnlyDate(),
                                    rangeEndDay: date.to.toDateTimeOnlyDate(),
                                    selectedDayPredicate: (day) {
                                      return isSameDay(
                                          date.from.toDateTimeOnlyDate(), day);
                                    },
                                    onRangeSelected: (start, end, focuseDate) {
                                      // widget.onSelectedDate.call(date);
                                      setState(() {
                                        date = DateObject.initFromDateTime(
                                            start ?? DateTime.now(),
                                            toDate: end);
                                        _focusedDay = focuseDate;
                                        _rangeSelectionMode =
                                            RangeSelectionMode.toggledOn;
                                      });
                                      debugPrint("selectDateChanged $date");
                                    },
                                    locale: 'en-US',
                                    firstDay: DateTime.utc(2020, 01, 01),
                                    lastDay: DateTime.utc(2030, 01, 01),
                                    focusedDay: _focusedDay,
                                    onDaySelected: (d, d1) {
                                      setState(() {
                                        date = DateObject.initFromDateTime(d);
                                        _focusedDay = d1;
                                        _rangeSelectionMode =
                                            RangeSelectionMode.toggledOff;
                                      });
                                      // onSelectedDate.call(date);
                                      // debugPrint(
                                      //     "selectDateChanged ${selectDateChanged.value}");
                                    },
                                  ),
                                ),
                              )),
                        ),
                    pressType: PressType.singleClick,
                    arrowColor: kIsWeb
                        ? Theme.of(context).scaffoldBackgroundColor
                        : const Color(0xFF4C4C4C),
                    // controller: _controller,
                    child: const Icon(Icons.date_range_outlined))
              else
                const DateSelector(),
            ],
          ),
        ],
      ),
    );
  }
}
