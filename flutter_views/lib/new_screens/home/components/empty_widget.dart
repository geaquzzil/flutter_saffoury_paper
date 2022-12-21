import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:lottie/lottie.dart';

class EmptyWidget extends StatelessWidget {
  String lottiUrl;
  String title;
  String subtitle;

  Function()? onSubtitleClicked;
  EmptyWidget(
      {Key? key,
      this.onSubtitleClicked,
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
          // Lottie.network(lottiUrl, height: 200, width: 200),
          Text("TODO Lottie.network"),
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
          if (onSubtitleClicked != null)
            TextButton(
              child: Text(subtitle,
                  textAlign: TextAlign.center,
                  style: themeData.textTheme.caption),
              onPressed: () => onSubtitleClicked!.call(),
            )
          else
            Text(subtitle,
                textAlign: TextAlign.center,
                style: themeData.textTheme.caption),
        ],
      ),
    );
  }
}
