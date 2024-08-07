// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';

class GetPremiumCard extends StatelessWidget {
  const GetPremiumCard({
    required this.onPressed,
    this.backgroundColor,
    super.key,
  });

  final Color? backgroundColor;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(kBorderRadius),
      color: backgroundColor ?? Theme.of(context).cardColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(kBorderRadius),
        onTap: onPressed,
        child: Container(
          constraints: const BoxConstraints(
            minWidth: 250,
            maxWidth: 350,
            minHeight: 200,
            maxHeight: 200,
          ),
          padding: const EdgeInsets.all(10),
          child: const Stack(
            children: [
              Align(
                  alignment: Alignment.topRight,
                  child: Icon(
                    Icons.dangerous,
                    size: 180,
                  )
                  // child: SvgPicture.asset(
                  //   ImageVectorPath.wavyBus,
                  //   width: 180,
                  //   height: 180,
                  //   fit: BoxFit.contain,
                  // ),
                  ),
              Padding(
                padding: EdgeInsets.all(15),
                child: _Info(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Get\nPremium\nAccount",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "To add more members",
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
