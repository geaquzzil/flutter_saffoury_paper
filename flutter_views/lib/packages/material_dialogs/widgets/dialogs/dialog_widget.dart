import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/packages/material_dialogs/shared/types.dart';
import 'package:lottie/lottie.dart';

/// Displays Material dialog above the current contents of the app

class DialogWidget extends StatelessWidget {
  const DialogWidget({super.key,
    this.title,
    this.msg,
    this.actions,
    this.animationBuilder,
    this.customView = const SizedBox(),
    this.customViewPosition = CustomViewPosition.BEFORE_TITLE,
    this.titleStyle,
    this.msgStyle,
    this.titleAlign,
    this.msgAlign,
    this.dialogWidth,
    this.color,
  });

  /// [actions]Widgets to display a row of buttons after the [msg] widget.
  final List<Widget>? actions;

  /// [customView] a widget to display a custom widget instead of the animation view.
  final Widget customView;

  final CustomViewPosition customViewPosition;

  /// [title] your dialog title
  final String? title;

  /// [msg] your dialog description message
  final String? msg;

  /// [animationBuilder] lottie animations builder
  final LottieBuilder? animationBuilder;

  /// [titleStyle] dialog title text style
  final TextStyle? titleStyle;

  /// [animation] lottie animations path
  final TextStyle? msgStyle;

  /// [titleAlign] dialog title text alignment
  final TextAlign? titleAlign;

  /// [textAlign] dialog description text alignment
  final TextAlign? msgAlign;

  /// [color] dialog's backgorund color
  final Color? color;

  /// [dialogWidth] dialog's width compared to the screen width
  final double? dialogWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: dialogWidth == null
          ? null
          : MediaQuery.of(context).size.width * dialogWidth!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          customViewPosition == CustomViewPosition.BEFORE_ANIMATION
              ? customView
              : const SizedBox(),
          if (animationBuilder != null)
            Container(
              padding: const EdgeInsets.only(top: 20),
              height: 200,
              width: double.infinity,
              child: animationBuilder,
            ),
          customViewPosition == CustomViewPosition.BEFORE_TITLE
              ? customView
              : const SizedBox(),
          title != null
              ? Padding(
                  padding:
                      const EdgeInsets.only(right: 20, left: 20, top: 24.0),
                  child: Text(
                    title!,
                    style: titleStyle,
                    textAlign: titleAlign,
                  ),
                )
              : const SizedBox(
                  height: 4,
                ),
          customViewPosition == CustomViewPosition.BEFORE_MESSAGE
              ? customView
              : const SizedBox(),
          msg != null
              ? Padding(
                  padding:
                      const EdgeInsets.only(right: 20, left: 20, top: 16.0),
                  child: Text(
                    msg!,
                    style: msgStyle,
                    textAlign: msgAlign,
                  ),
                )
              : const SizedBox(
                  height: 20,
                ),
          customViewPosition == CustomViewPosition.BEFORE_ACTION
              ? customView
              : const SizedBox(),
          actions?.isNotEmpty == true
              ? buttons(context)
              : const SizedBox(
                  height: 20,
                ),
          customViewPosition == CustomViewPosition.AFTER_ACTION
              ? customView
              : const SizedBox(),
        ],
      ),
    );
  }

  Widget buttons(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(right: 20, left: 20, top: 16.0, bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(actions!.length, (index) {
          final TextDirection direction = Directionality.of(context);
          double padding = index != 0 ? 8 : 0;
          double rightPadding = 0;
          double leftPadding = 0;
          direction == TextDirection.rtl
              ? rightPadding = padding
              : leftPadding = padding;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: leftPadding, right: rightPadding),
              child: actions![index],
            ),
          );
        }),
      ),
    );
  }
}
