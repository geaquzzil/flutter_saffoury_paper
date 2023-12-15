import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:intl/intl.dart';

import '../models/apis/date_object.dart';

class TodayText extends StatelessWidget {
  DateObject? dateObject;
  TodayText({super.key, this.dateObject});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [getTitle(context), getDate(context)],
      ),
    );
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
      style: Theme.of(context).textTheme.bodySmall,
    );
  }

  Widget getDate(BuildContext context) {
    String date = DateFormat.yMMMEd().format(DateTime.now());
    if (dateObject != null) {
      date = dateObject!.getDate(context);
    }
    return Text(
      date,
    );
  }
}
