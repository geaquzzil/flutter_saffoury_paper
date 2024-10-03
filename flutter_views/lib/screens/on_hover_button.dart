import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:sprung/sprung.dart';

class OnHoverWidget extends StatefulWidget {
  bool scale;
  ValueNotifier<bool>? onHover;
  bool scaleDown;
  MouseCursor mouseCursor;
  Widget Function(bool isHovered) builder;

  OnHoverWidget(
      {super.key,
      required this.builder,
      this.onHover,
      this.scaleDown = false,
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

  double getScaleInfo() {
    if (widget.scale) {
      if (widget.scaleDown) {
        return .98;
      }
      return 1.02;
    } else {
      return 1;
    }
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
        child: AnimatedScale(
          curve: Sprung.overDamped,
          duration: const Duration(milliseconds: 200),
          scale: !isHover
              ? 1
              : widget.scale
                  ? getScaleInfo()
                  : 1,
          child: widget.builder(isHover),
        )

        // AnimatedContainer(
        //   curve: Sprung.overDamped,
        //   duration: const Duration(milliseconds: 200),
        //   transform: widget.scale ? transform : null,
        //   child: widget.builder(isHover),
        // ),
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
    padding = Tween(begin: 1.0, end: 0.95).animate(CurvedAnimation(
        parent: _controller, curve: Curves.ease, reverseCurve: Curves.easeIn));
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
          clipBehavior: Clip.antiAlias,
          // margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: widget.roundedCorners
                ? BorderRadius.circular(kBorderRadius)
                : null,
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
          child: _getAspectRatio()

          //  widget.bottomWidget == null
          //     ? _getAspectRatio()
          //     : AspectRatio(
          //         aspectRatio: 1 / 1,
          //         child: Column(
          //           mainAxisSize: MainAxisSize.max,
          //           crossAxisAlignment: CrossAxisAlignment.center,
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             Expanded(child: getBody()),
          //             AnimatedOpacity(
          //                 opacity: isHovered ? 0 : 1,
          //                 duration: const Duration(milliseconds: 275),
          //                 // height: isHovered ? 0 : 100,
          //                 child: widget.bottomWidget)
          //           ],
          //         ),
          //       ),
          ),
    );
    return child;
  }

  AspectRatio _getAspectRatio() {
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: getBody(),
    );
  }

  Widget getBody() {
    return Transform.scale(
      scale: padding.value,
      child: widget.builder == null
          ? Image.network(
              widget.image,
              fit: BoxFit.contain,
            )
          : widget.builder!(isHovered),
    );
  }
}
