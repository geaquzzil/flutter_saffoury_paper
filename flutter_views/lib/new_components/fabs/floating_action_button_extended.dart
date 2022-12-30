import 'package:flutter/material.dart';

class FloatingActionButtonExtended extends StatefulWidget {
  IconData colapsed;
  Widget expandedWidget;
  void Function() onPress;
  IconData onExpandIcon;
  FloatingActionButtonExtended(
      {super.key,
      this.colapsed = Icons.arrow_forward,
      this.onExpandIcon = Icons.add,
      required this.onPress,
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
        onPressed: _onFabPress,
        label: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (Widget child, Animation<double> animation) =>
              FadeTransition(
            opacity: animation,
            child: SizeTransition(
              sizeFactor: animation,
              axis: Axis.horizontal,
              child: child,
            ),
          ),
          child: !_isExtended
              ? Icon(widget.colapsed)
              : Row(
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
    if (_isExtended) {
      widget.onPress();
    }
    setState(() {
      _isExtended = !_isExtended;
    });
  }
}
