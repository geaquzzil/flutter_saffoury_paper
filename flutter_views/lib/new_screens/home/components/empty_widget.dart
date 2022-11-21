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
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.network(lottiUrl),
          const SizedBox(
            height: kDefaultPadding,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: themeData.textTheme.titleSmall,
          ),
          const SizedBox(
            height: kDefaultPadding,
          ),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: themeData.textTheme.caption
          ),
        ],
      ),
    );
  }
}
