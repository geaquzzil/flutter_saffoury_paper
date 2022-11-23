import 'package:flutter/material.dart';

class ShadowWidget extends StatelessWidget {
  Widget child;

  ShadowWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      // decoration: BoxDecoration(
      //   color: Theme.of(context).colorScheme.primary,
      //   // color: Colors.white,
      //   borderRadius: const BorderRadius.only(
      //       topLeft: Radius.circular(10),
      //       topRight: Radius.circular(10),
      //       bottomLeft: Radius.circular(10),
      //       bottomRight: Radius.circular(10)),
      //   boxShadow: [
      //     BoxShadow(
      //       color: Theme.of(context).colorScheme.shadow,
      //       spreadRadius: 2,
      //       blurRadius: 2,
      //       offset: const Offset(0, 0), // changes position of shadow
      //     ),
      //   ],
      // ),
      child: child,
    );
  }
}
