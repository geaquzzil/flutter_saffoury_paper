import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoadingList extends StatelessWidget {
  const ShimmerLoadingList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.outline,
      highlightColor: Theme.of(context).colorScheme.onBackground,
      period: const Duration(seconds: 1),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.outline)),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                width: 100,
                height: 75,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 250,
                    height: 10,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 150,
                    height: 10,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
