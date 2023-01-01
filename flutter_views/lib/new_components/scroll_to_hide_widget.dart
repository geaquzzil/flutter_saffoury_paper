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
  final double height;
  ScrollToHideWidget(
      {super.key,
      required this.child,
      this.controller,
      this.duration = const Duration(milliseconds: 200),
      this.height = 80});

  @override
  State<ScrollToHideWidget> createState() => _ScrollToHideWidgetState();
}

class _ScrollToHideWidgetState extends State<ScrollToHideWidget> {
  bool isVisible = true;

  @override
  void initState() {
    super.initState();

    widget.controller?.addListener(listen);
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller?.removeListener(listen);
  }

  void listen() {
    final direction = widget.controller?.position.userScrollDirection;
    if (direction == ScrollDirection.forward) {
      show();
    } else if (direction == ScrollDirection.reverse) {
      hide();
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
    return AnimatedContainer(
      duration: widget.duration,
      height: 0,
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
