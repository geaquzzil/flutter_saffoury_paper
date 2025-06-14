import 'package:flutter/material.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:lottie/lottie.dart';

class LottieColorFilter extends StatelessWidget {
  final String? lottiUrl;
  final String? lottieJson;
  final double? height;
  final Color? color;
  final String lottieAssetPath = "assets/lotties/";
  const LottieColorFilter(
      {super.key, this.color, this.lottiUrl, this.lottieJson, this.height});

  @override
  Widget build(BuildContext context) {
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
          color ?? Theme.of(context).colorScheme.surface,
          BlendMode.modulate,
        ),
        child: widget);
  }
}

class EmptyWidget extends StatelessWidget {
  final String? lottiUrl;

  final String? lottieJson;

  final String? title;

  final String? subtitle;

  final bool expand;
  final String lottieAssetPath = "assets/lotties/";

  final Function()? onSubtitleClicked;

  const EmptyWidget(
      {super.key,
      this.onSubtitleClicked,
      this.lottiUrl,
      this.title,
      this.expand = true,
      this.subtitle,
      this.lottieJson});

  const EmptyWidget.loading({
    super.key,
    this.lottiUrl = "https://assets3.lottiefiles.com/packages/lf20_mr1olA.json",
    this.expand = true,
  })  : onSubtitleClicked = null,
        lottieJson = null,
        title = null,
        subtitle = null;

  EmptyWidget.error(
    BuildContext context, {
    super.key,
    this.onSubtitleClicked,
    this.expand = true,
  })  : subtitle = AppLocalizations.of(context)!.cantConnectConnectToRetry,
        lottiUrl =
            "https://assets7.lottiefiles.com/packages/lf20_0s6tfbuc.json",
        lottieJson = null,
        title = AppLocalizations.of(context)!.cantConnect;

  EmptyWidget.emptyList(
    BuildContext context, {
    super.key,
    this.lottiUrl =
        "https://assets7.lottiefiles.com/packages/lf20_0s6tfbuc.json",
    this.expand = true,
    this.onSubtitleClicked,
    this.lottieJson,
  })  : subtitle = AppLocalizations.of(context)!.noItems,
        title = AppLocalizations.of(context)!.no_content;

  EmptyWidget.emptyPage(
    BuildContext context, {
    super.key,
    this.lottiUrl =
        "https://assets7.lottiefiles.com/packages/lf20_0s6tfbuc.json",
    this.expand = true,
    this.onSubtitleClicked,
    this.lottieJson,
    //todo translate
  })  : subtitle = AppLocalizations.of(context)!.no_content,
        title = AppLocalizations.of(context)!.no_content;

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
                style: themeData.textTheme.bodySmall),
            onPressed: () => onSubtitleClicked!.call(),
          )
        else
          Text(subtitle!,
              textAlign: TextAlign.center,
              style: themeData.textTheme.bodySmall),
    ];
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Text("TODO Lottie.network"),
          if (lottiUrl != null || lottieJson != null)
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
    return widget;
    return ColorFiltered(
        colorFilter: ColorFilter.mode(
          Theme.of(context).colorScheme.surface,
          BlendMode.modulate,
        ),
        child: widget);
  }
}
