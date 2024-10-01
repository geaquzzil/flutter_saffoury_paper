import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/size_config.dart';

class WrapController extends StatefulWidget {
  final CurrentScreenSize? size;
  final Widget child;
  const WrapController({super.key, this.size, required this.child});

  @override
  State<WrapController> createState() => _WrapControllerState();
}

class _WrapControllerState extends State<WrapController> {
  late CurrentScreenSize _size;

  bool isLargeScreen() {
    return _size == CurrentScreenSize.DESKTOP ||
        _size == CurrentScreenSize.LARGE_TABLET;
  }

  @override
  Widget build(BuildContext context) {
    _size = widget.size ?? findCurrentScreenSize(context);
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            // vertical: 0,
            vertical:
                isLargeScreen() ? kDefaultPadding * .5 : kDefaultPadding * .5,
          ),
          child: isLargeScreen()
              ? SizedBox(height: 40, child: widget.child)
              : widget.child,
        ),
        // if (currentScreenSize != CurrentScreenSize.DESKTOP)
        // if (requiredSpace ?? false) getSpace()
      ],
    );
  }
}
