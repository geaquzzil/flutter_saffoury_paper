import 'package:animate_icons/animate_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_view_controller/providers/actions/list_scroll_provider.dart';
import 'package:provider/provider.dart';

class ScrollToHideWidget extends StatefulWidget {
  final Widget child;
  final ScrollController? controller;
  final Duration duration;
  final bool showOnlyWhenCloseToTop;
  final double height;
  final bool useAnimatedScaling;
  final bool reverse;
  final bool useAnimatedSwitcher;
  const ScrollToHideWidget(
      {super.key,
      required this.child,
      this.showOnlyWhenCloseToTop = true,
      this.controller,
      this.reverse = false,
      this.useAnimatedScaling = false,
      this.useAnimatedSwitcher = false,
      this.duration = const Duration(milliseconds: 200),
      this.height = 80});

  @override
  State<ScrollToHideWidget> createState() => _ScrollToHideWidgetState();
}

class _ScrollToHideWidgetState extends State<ScrollToHideWidget> {
  late bool isVisible;

  @override
  void initState() {
    super.initState();
    isVisible = widget.reverse ? false : true;
    widget.controller?.addListener(listen);
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller?.removeListener(listen);
  }

  void listen() {
    final direction = widget.controller?.position.userScrollDirection;
    if (widget.reverse) {
      if (widget.showOnlyWhenCloseToTop) {
        if ((widget.controller?.position.pixels ?? 0) > 100) {
          show();
        } else {
          hide();
        }
      } else {
        if (direction == ScrollDirection.forward) {
          hide();
        } else if (direction == ScrollDirection.reverse) {
          show();
        }
      }
    } else {
      if (widget.showOnlyWhenCloseToTop) {
        if ((widget.controller?.position.pixels ?? 0) > 100) {
          hide();
        } else {
          show();
        }
      } else {
        if (direction == ScrollDirection.forward) {
          show();
        } else if (direction == ScrollDirection.reverse) {
          hide();
        }
      }
    }
  }

  void show() {
    if (!isVisible) {
      setState(() {
        isVisible = true;
      });
    }
  }

  void hide() {
    if (isVisible) {
      setState(() {
        isVisible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.useAnimatedSwitcher && widget.useAnimatedScaling) {
      return AnimatedScale(
        duration: widget.duration,
        scale: isVisible ? 1 : 0,
        child: AnimatedSwitcher(
            // transitionBuilder: (child, animation) =>
            //     ScaleTransition(scale: animation),
            duration: widget.duration,
            child: isVisible
                ? widget.child
                : SizedBox(
                    key: UniqueKey(),
                  )),
      );
    } else if (widget.useAnimatedScaling) {
      return AnimatedScale(
          duration: widget.duration,
          scale: isVisible ? 1 : 0,
          child: widget.child);
    } else if (widget.useAnimatedSwitcher) {
      return AnimatedSwitcher(
          // transitionBuilder: (child, animation) =>
          //     ScaleTransition(scale: animation),
          duration: widget.duration,
          child: isVisible
              ? widget.child
              : SizedBox(
                  key: UniqueKey(),
                ));
    }
    return AnimatedContainer(
      duration: widget.duration,
      height: isVisible ? widget.height : 0,
      child: Wrap(children: [widget.child]),
    );
  }

  //TODO NOT WATCH
  double getHeight() {
    if (widget.controller == null) {
      return context.watch<ListScrollProvider>().isScrollForward()
          ? widget.height
          : 0;
    }
    return isVisible ? widget.height : 0;
  }
}
