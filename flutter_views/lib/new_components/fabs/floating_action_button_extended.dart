import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class FloatingActionButtonExtended extends StatefulWidget {
  IconData colapsed;
  Widget expandedWidget;
  void Function()? onPress;
  void Function()? onToggle;
  IconData onExpandIcon;
  FloatingActionButtonExtended(
      {super.key,
      this.colapsed = Icons.arrow_forward,
      this.onExpandIcon = Icons.add,
      this.onToggle,
      this.onPress,
      required this.expandedWidget});

  @override
  State<FloatingActionButtonExtended> createState() =>
      _FloatingActionButtonExtendedState();
}

class _FloatingActionButtonExtendedState
    extends State<FloatingActionButtonExtended> {
  bool _isExtended = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
        heroTag: UniqueKey(),
        onPressed: widget.onPress == null ? null : _onFabPress,
        label: AnimatedSize(
          duration: const Duration(milliseconds: 250),
          // transitionBuilder: (Widget child, Animation<double> animation) =>
          //     FadeTransition(
          //   opacity: animation,
          //   child: SizeTransition(
          //     sizeFactor: animation,
          //     axis: Axis.horizontal,
          //     child: child,
          //   ),
          // ),
          child: !_isExtended
              ? FadeIn(key: UniqueKey(), child: Icon(widget.colapsed))
              : Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Icon(widget.onExpandIcon),
                    ),
                    widget.expandedWidget
                  ],
                ),
        ));
  }

  void _onFabPress() {
    if (widget.onToggle != null) {
      widget.onToggle!();
    }
    if (_isExtended) {
      widget.onPress!();
    }
    setState(() {
      _isExtended = !_isExtended;
    });
  }
}
