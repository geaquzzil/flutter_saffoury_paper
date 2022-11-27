import 'package:flutter/material.dart';

class FloatingActionButtonExtended extends StatefulWidget {
  FloatingActionButtonExtended(
      {super.key,
      this.colapsed = Icons.arrow_forward,
      required this.onPress,
      required this.expandedWidget});

  IconData colapsed;
  Widget expandedWidget;
  void Function() onPress;

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
              ? const Icon(Icons.arrow_forward)
              : Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(right: 4.0),
                      child: Icon(Icons.add),
                    ),
                    Text("Add To Order")
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
