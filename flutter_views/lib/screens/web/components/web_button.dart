import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';

class WebButtonAnimated extends StatefulWidget {
  final Color from;
  final Color to;
  final Widget Function(Color color) child;
  final ValueNotifier<bool>? isChanged;
  const WebButtonAnimated(
      {super.key,
      required this.from,
      required this.to,
      this.isChanged,
      required this.child});

  @override
  State<WebButtonAnimated> createState() => _WebButtonAnimatedState();
}

class _WebButtonAnimatedState extends State<WebButtonAnimated>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _colorTween;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 275));
    _colorTween = ColorTween(begin: widget.from, end: widget.to)
        .animate(_animationController);
    if (widget.isChanged != null) {
      widget.isChanged!.addListener(() {
        debugPrint("colorTween finished ${widget.isChanged!.value}");
        if (widget.isChanged!.value == false) {
          _animationController.reverse();
        } else {
          _animationController.forward();
        }
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _colorTween,
        builder: (context, child) => widget.child.call(_colorTween.value));
  }
}

class WebButton extends StatelessWidget {
  final String title;
  final bool primary;
  final double width;
  Color? color;
  final void Function()? onPressed;
  WebButton(
      {super.key,
      this.primary = true,
      required this.title,
      this.onPressed,
      this.color,
      this.width = 200});

  @override
  Widget build(BuildContext context) {
    if (color != null) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8.0),
          ),
          height: 48.0,
          width: width,
          padding: const EdgeInsets.symmetric(
            horizontal: 28.0,
          ),
          child: TextButton(
            onPressed: onPressed,
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
    }
    if (primary) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          height: 48.0,
          width: width,
          padding: const EdgeInsets.symmetric(
            horizontal: 28.0,
          ),
          child: TextButton(
            onPressed: onPressed,
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: kPrimaryColor,
          ),
        ),
        height: 48.0,
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 28.0),
        child: TextButton(
          onPressed: onPressed,
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                color: kPrimaryColor,
                fontSize: 13.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
