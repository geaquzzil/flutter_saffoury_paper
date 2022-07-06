import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:lottie/lottie.dart';

class EmptyWidget extends StatelessWidget {
  String lottiUrl;
  String title;
  String subtitle;
  EmptyWidget(
      {Key? key,
      required this.lottiUrl,
      required this.title,
      required this.subtitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Lottie.network(lottiUrl),
        Text(
          title,
          style: themeData.textTheme.bodyText1,
        ),
        SizedBox(
          height: kDefaultPadding / 2,
        ),
        Text(
          subtitle,
          style: themeData.textTheme.subtitle1,
        ),
      ],
    );
  }


}
