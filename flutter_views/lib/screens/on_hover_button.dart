import 'package:flutter/material.dart';
import 'package:sprung/sprung.dart';

class OnHoverWidget extends StatefulWidget {
  bool scale;
  ValueNotifier<bool>? onHover;
  MouseCursor mouseCursor;
  Widget Function(bool isHovered) builder;

  OnHoverWidget(
      {super.key,
      required this.builder,
      this.onHover,
      this.mouseCursor = SystemMouseCursors.click,
      this.scale = true});

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
  final bool animatedScale;
  final bool roundedCorners;
  final Widget Function(bool isHovered)? builder;
  const HoverImage(
      {super.key,
      required this.image,
      this.animatedScale = true,
      this.roundedCorners = true,
      this.builder,
      this.bottomWidget});

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
    _animation = Tween(begin: 1.0, end: 1.08).animate(CurvedAnimation(
        parent: _controller, curve: Curves.ease, reverseCurve: Curves.easeIn));
    padding =
        Tween(begin: 0.0, end: widget.bottomWidget == null ? -10.0 : -10.0)
            .animate(CurvedAnimation(
                parent: _controller,
                curve: Curves.ease,
                reverseCurve: Curves.easeIn));
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget child = MouseRegion(
      onEnter: (value) {
        setState(() {
          isHovered = true;
          if (widget.animatedScale) {
            _controller.forward();
          }
        });
      },
      onExit: (value) {
        setState(() {
          isHovered = false;
          if (widget.animatedScale) {
            _controller.reverse();
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius:
              widget.roundedCorners ? BorderRadius.circular(20.0) : null,
          boxShadow: widget.bottomWidget != null
              ? null
              : const [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0.0, 0.0),
                    spreadRadius: -10.0,
                    blurRadius: 20.0,
                  )
                ],
        ),
        child: widget.bottomWidget == null
            ? _getAspectRatio()
            : Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                        child: AspectRatio(aspectRatio: 1, child: getBody())),
                    AnimatedOpacity(
                        opacity: isHovered ? 0 : 1,
                        duration: const Duration(milliseconds: 275),
                        // height: isHovered ? 0 : 100,
                        child: widget.bottomWidget)
                  ],
                ),
              ),
      ),
    );
    if (widget.bottomWidget != null) {
      return AspectRatio(
        aspectRatio: 1 / 1,
        child: child,
      );
    }
    return child;
  }

  AspectRatio _getAspectRatio() {
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: getBody(),
    );
  }

  Container getBody() {
    return Container(
        // height: 220.0,
        // width: 170.0,
        decoration: BoxDecoration(
          borderRadius:
              widget.roundedCorners ? BorderRadius.circular(20.0) : null,
        ),
        clipBehavior: Clip.hardEdge,
        // transform: Matrix4.identity()..scale(1, 1, 1),
        transform: Matrix4(_animation.value, 0, 0, 0, 0, _animation.value, 0, 0,
            0, 0, 1, 0, padding.value, padding.value, 0, 1),
        child: widget.builder == null
            ? Image.network(
                widget.image,
                fit: BoxFit.contain,
              )
            : widget.builder!(isHovered));
  }
}
