import 'package:flutter/material.dart';
import 'package:sprung/sprung.dart';

class OnHoverWidget extends StatefulWidget {
  Widget Function(bool isHovered) builder;

  OnHoverWidget({Key? key, required this.builder}) : super(key: key);

  @override
  State<OnHoverWidget> createState() => _OnHoverWidgetState();
}

class _OnHoverWidgetState extends State<OnHoverWidget> {
  bool isHover = false;
  void onEntered(bool isHover) {
    setState(() {
      this.isHover = isHover;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hoveredTransform = Matrix4.identity()
      ..translate(-4, -8, 0)
      ..scale(1.2);
    final transform = isHover ? hoveredTransform : Matrix4.identity();
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (event) => onEntered(true),
      onExit: (event) => onEntered(false),
      child: AnimatedContainer(
        curve: Sprung.overDamped,
        duration: Duration(milliseconds: 200),
        transform: transform,
        child: widget.builder(isHover),
      ),
    );
  }
}
