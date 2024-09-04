import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/new_screens/base_page.dart';
import 'package:intl/intl.dart';

import '../models/apis/date_object.dart';

class TodayText extends StatelessWidget {
  DateObject? dateObject;
  bool requireTime;
  TodayText({super.key, this.dateObject, this.requireTime = false});

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: const BoxConstraints(maxWidth: 300),
        child: ListTile(
          title: getTitle(context),
          subtitle: getDate(context),
        ));
  }

  Widget getTitle(BuildContext context) {
    String title = "";

    if (dateObject != null) {
      title = dateObject!.getTitle(context);
    } else {
      title = AppLocalizations.of(context)!.today;
    }
    return Text(
      title,
      // style: Theme.of(context).textTheme.bodySmall,
    );
  }

  Widget getDate(BuildContext context) {
    String date = DateFormat.yMMMEd().format(DateTime.now());
    date = requireTime
        ? "$date ${DateFormat("HH:mm").format(DateTime.now())}"
        : date;
    if (dateObject != null) {
      date = dateObject!.getDate(context);
    }
    return Text(
      date,
    );
  }
}

class TodayTextTicker extends StatefulWidget {
  bool requireTime;
  TodayTextTicker({super.key, this.requireTime = false});

  @override
  State<TodayTextTicker> createState() => _TodayTextTickerState();
}

class _TodayTextTickerState extends State<TodayTextTicker> with TickerWidget {
  @override
  Widget build(BuildContext context) {
    return TodayText(
      requireTime: widget.requireTime,
    );
  }

  @override
  int getTickerSecond() => 60;
}
