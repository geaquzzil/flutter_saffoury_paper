import 'package:flutter/material.dart';

import '../constants.dart';

class MainBody extends StatelessWidget {
  const MainBody(
      {Key? key,
      required this.child,
      this.padding = const EdgeInsets.only(top: 40.0) // Default padding
      })
      : super(key: key);

  final Widget? child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: padding,
      decoration: const BoxDecoration(
        // color: kWhite,
        // ignore: unnecessary_const
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(60.0),
          topRight: Radius.circular(60.0),
        ),
      ),
      child: child,
    );
  }
}
