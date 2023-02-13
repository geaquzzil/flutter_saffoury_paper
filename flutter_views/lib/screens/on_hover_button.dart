import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/menu_item.dart';
import 'package:flutter_view_controller/utils/dialogs.dart';
import 'package:sprung/sprung.dart';

class OnHoverWidget extends StatefulWidget {
  bool scale;
  ValueNotifier<bool>? onHover;
  Widget Function(bool isHovered) builder;

  OnHoverWidget(
      {Key? key, required this.builder, this.onHover, this.scale = true})
      : super(key: key);

  @override
  State<OnHoverWidget> createState() => _OnHoverWidgetState();
}

class _OnHoverWidgetState extends State<OnHoverWidget> {
  bool isHover = false;
  void onEntered(bool isHover) {
    if (widget.onHover != null) {
      widget.onHover!.value = isHover;
      return;
    }
    setState(() {
      this.isHover = isHover;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hoveredTransform = Matrix4.identity()
      ..translate(-4.0, -8.0, 0.0)
      ..scale(1.2);
    final transform = isHover ? hoveredTransform : Matrix4.identity();
    GlobalKey key = GlobalKey();
    return MouseRegion(
      key: key,
      cursor: SystemMouseCursors.click,
      onEnter: (event) => onEntered(true),
      onExit: (event) => onEntered(false),
      child: AnimatedContainer(
        curve: Sprung.overDamped,
        duration: const Duration(milliseconds: 200),
        transform: widget.scale ? transform : null,
        child: widget.builder(isHover),
      ),
    );
  }
}
