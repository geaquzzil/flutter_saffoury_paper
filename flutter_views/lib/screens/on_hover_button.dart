import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/menu_item.dart';
import 'package:flutter_view_controller/utils/dialogs.dart';
import 'package:sprung/sprung.dart';

class OnHoverWidget extends StatefulWidget {
  bool scale;
  ValueNotifier<bool>? onHover;
  MouseCursor mouseCursor;
  Widget Function(bool isHovered) builder;

  OnHoverWidget(
      {Key? key,
      required this.builder,
      this.onHover,
      this.mouseCursor = SystemMouseCursors.click,
      this.scale = true})
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
      cursor: widget.mouseCursor,
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

class HoverImage extends StatefulWidget {
  final String image;
  final Widget? bottomWidget;
  final Widget Function(bool isHovered)? builder;
  const HoverImage(
      {super.key, required this.image, this.builder, this.bottomWidget});

  @override
  _HoverImageState createState() => _HoverImageState();
}

class _HoverImageState extends State<HoverImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;
  late Animation padding;
  late bool isHovered;

  @override
  void initState() {
    super.initState();
    isHovered = false;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 275),
      vsync: this,
    );
    _animation = Tween(begin: 1.0, end: 1.2).animate(CurvedAnimation(
        parent: _controller, curve: Curves.ease, reverseCurve: Curves.easeIn));
    padding = Tween(begin: 0.0, end: -25.0).animate(CurvedAnimation(
        parent: _controller, curve: Curves.ease, reverseCurve: Curves.easeIn));
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (value) {
        setState(() {
          isHovered = true;
          _controller.forward();
        });
      },
      onExit: (value) {
        setState(() {
          isHovered = false;
          _controller.reverse();
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: widget.bottomWidget != null
              ? null
              : const [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0.0, 20.0),
                    spreadRadius: -10.0,
                    blurRadius: 20.0,
                  )
                ],
        ),
        child: widget.bottomWidget == null
            ? _getAspectRatio()
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _getAspectRatio(),
                  AnimatedOpacity(
                      opacity: isHovered ? 0 : 1,
                      duration: const Duration(milliseconds: 275),
                      // height: isHovered ? 0 : 100,
                      child: widget.bottomWidget)
                ],
              ),
      ),
    );
  }

  AspectRatio _getAspectRatio() {
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: Container(
          // height: 220.0,
          // width: 170.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
          ),
          clipBehavior: Clip.hardEdge,
          transform: Matrix4(_animation.value, 0, 0, 0, 0, _animation.value, 0,
              0, 0, 0, 1, 0, padding.value, padding.value, 0, 1),
          child: widget.builder == null
              ? Image.network(
                  widget.image,
                  fit: BoxFit.contain,
                )
              : widget.builder!(isHovered)
          // Column(
          //     children: [
          //       widget.builder!(isHovered),
          //       Text("TEST")
          //     ],
          //   )

          ),
    );
  }
}
