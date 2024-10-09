import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:sprung/sprung.dart';

class OnHoverDecoratedBox extends StatefulWidget {
  final Widget child;
  const OnHoverDecoratedBox({super.key, required this.child});

  @override
  State<OnHoverDecoratedBox> createState() => _OnHoverDecoratedBoxState();
}

class _OnHoverDecoratedBoxState extends State<OnHoverDecoratedBox>
    with TickerProviderStateMixin {
  DecorationTween decorationTween() => DecorationTween(
        end: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          border: Border.all(
              style: BorderStyle.solid,
              width: 1,
              color: Theme.of(context).colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(kBorderRadius),
          // boxShadow: <BoxShadow>[
          //   BoxShadow(
          //     color: Theme.of(context).colorScheme.shadow.withOpacity(.9),
          //     blurRadius: 3.0,
          //     spreadRadius: 4.0,
          //     offset: const Offset(0, 2.0),
          //   ),
          // ],
        ),
        begin: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          border: Border.all(
            style: BorderStyle.none,
          ),
          borderRadius: BorderRadius.circular(kBorderRadius / 2),
          // No shadow.
        ),
      );

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool isHover = false;
  void onEntered(bool isHover) {
    if (isHover) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => onEntered(true),
      onExit: (event) => onEntered(false),
      child: DecoratedBoxTransition(
          decoration: decorationTween().animate(_controller),
          child: Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: widget.child,
          )),
    );
  }
}

/// if Child is ExpansionTile or ListTile we should set the background to [Colors.transparent]
class OnHoverWidget extends StatefulWidget {
  bool scale;
  ValueNotifier<bool>? onHover;
  bool scaleDown;
  MouseCursor mouseCursor;
  double scaleValue;
  Widget Function(bool isHovered) builder;

  OnHoverWidget(
      {super.key,
      required this.builder,
      this.onHover,
      this.scaleDown = false,
      this.mouseCursor = SystemMouseCursors.click,
      this.scaleValue = 0.02,
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
        return 1 - widget.scaleValue;
      }
      return 1 + widget.scaleValue;
    } else {
      return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
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
