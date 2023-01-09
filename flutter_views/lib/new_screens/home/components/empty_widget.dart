import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:lottie/lottie.dart';

class EmptyWidget extends StatelessWidget {
  String lottiUrl;
  String? title;
  String? subtitle;
  bool expand;

  Function()? onSubtitleClicked;
  EmptyWidget(
      {Key? key,
      this.onSubtitleClicked,
      required this.lottiUrl,
      this.title,
      this.expand = true,
      this.subtitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    if (title == null && subtitle == null) {
      return Center(
          child: expand
              ? Expanded(
                  child: Lottie.network(
                  lottiUrl,
                ))
              : Lottie.network(lottiUrl, height: 100));
    }
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Text("TODO Lottie.network"),
          expand
              ? Expanded(
                  child: Lottie.network(
                  lottiUrl,
                ))
              : Lottie.network(lottiUrl, height: 100),
          const SizedBox(
            height: kSpaceWithText,
          ),
          if (title != null)
            Text(
              title!,
              textAlign: TextAlign.center,
              style: themeData.textTheme.titleSmall,
            ),
          if (title != null)
            const SizedBox(
              height: kSpaceWithText,
            ),
          if (subtitle != null)
            if (onSubtitleClicked != null)
              TextButton(
                child: Text(subtitle!,
                    textAlign: TextAlign.center,
                    style: themeData.textTheme.caption),
                onPressed: () => onSubtitleClicked!.call(),
              )
            else
              Text(subtitle!,
                  textAlign: TextAlign.center,
                  style: themeData.textTheme.caption),
        ],
      ),
    );
  }
}
