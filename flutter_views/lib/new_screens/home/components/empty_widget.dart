import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:lottie/lottie.dart';

class EmptyWidget extends StatelessWidget {
  final String? lottiUrl;

  final String? lottieJson;

  final String? title;

  final String? subtitle;

  final bool expand;
  final String lottieAssetPath = "assets/lotties/";

  final Function()? onSubtitleClicked;
  const EmptyWidget(
      {Key? key,
      this.onSubtitleClicked,
      this.lottiUrl,
      this.title,
      this.expand = true,
      this.subtitle,
      this.lottieJson})
      : assert(lottiUrl != null || lottieJson != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    if (title == null && subtitle == null) {
      return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        expand
            ? Expanded(
                child: getLottieWidget(
                context,
              ))
            : getLottieWidget(context, height: 100)
      ]);
    }
    var children2 = [
      const SizedBox(
        height: kSpaceWithText,
      ),
      // expand? Expanded(flex: 2,child: ,):
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
              textAlign: TextAlign.center, style: themeData.textTheme.caption),
    ];
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Text("TODO Lottie.network"),
          expand
              ? Expanded(
                  flex: 4,
                  child: getLottieWidget(
                    context,
                  ))
              : getLottieWidget(context, height: 100),
          if (expand)
            Expanded(
              flex: 8,
              child: Column(children: children2),
            )
          else
            ...children2
        ],
      ),
    );
  }

  Widget getLottieWidget(BuildContext context, {double? height}) {
    Widget widget;
    if (lottiUrl != null) {
      widget = Lottie.network(
        lottiUrl!,
        height: height,
      );
    } else {
      widget = Lottie.asset(
        lottieAssetPath + lottieJson!,
      );
    }
    return ColorFiltered(
        colorFilter: ColorFilter.mode(
          Theme.of(context).colorScheme.onBackground,
          BlendMode.modulate,
        ),
        child: widget);
  }
}
